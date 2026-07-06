#define IPCV_CORE_EXPORTS
#include "ipcv_segmentation.h"

#include <opencv2/core.hpp>
#include <opencv2/imgproc.hpp>

#include <cstdlib>
#include <cstring>
#include <exception>
#include <vector>

namespace
{
void set_error(IpcvDecodedImage *image, const char *message)
{
    if (image == NULL)
    {
        return;
    }

    std::strncpy(image->error, message, sizeof(image->error) - 1);
    image->error[sizeof(image->error) - 1] = 0;
}

size_t depth_size(int depth)
{
    switch (depth)
    {
    case IPCV_DEPTH_8U:
    case IPCV_DEPTH_8S:
        return 1;
    case IPCV_DEPTH_16U:
    case IPCV_DEPTH_16S:
        return 2;
    case IPCV_DEPTH_32S:
    case IPCV_DEPTH_32F:
        return 4;
    case IPCV_DEPTH_64F:
        return 8;
    default:
        return 0;
    }
}

void copy_scilab_layout_to_mat(const unsigned char *source, cv::Mat& destination)
{
    const int rows = destination.rows;
    const int cols = destination.cols;
    const int channels = destination.channels();
    const size_t elem_bytes = destination.elemSize1();

    for (int ch = 0; ch < channels; ch++)
    {
        int dst_ch = ch;
        if ((channels == 3 || channels == 4) && ch < 3)
        {
            dst_ch = 2 - ch;
        }

        for (int col = 0; col < cols; col++)
        {
            for (int row = 0; row < rows; row++)
            {
                const size_t src_offset = (static_cast<size_t>(ch) * rows * cols + static_cast<size_t>(col) * rows + row) * elem_bytes;
                unsigned char *dst = destination.ptr<unsigned char>(row) + ((col * channels + dst_ch) * elem_bytes);
                std::memcpy(dst, source + src_offset, elem_bytes);
            }
        }
    }
}

void copy_to_scilab_layout(const cv::Mat& source, unsigned char *destination)
{
    const int rows = source.rows;
    const int cols = source.cols;
    const int channels = source.channels();
    const size_t elem_bytes = source.elemSize1();

    for (int ch = 0; ch < channels; ch++)
    {
        int src_ch = ch;
        if ((channels == 3 || channels == 4) && ch < 3)
        {
            src_ch = 2 - ch;
        }

        for (int col = 0; col < cols; col++)
        {
            for (int row = 0; row < rows; row++)
            {
                const unsigned char *src = source.ptr<unsigned char>(row) + ((col * channels + src_ch) * elem_bytes);
                const size_t dst_offset = (static_cast<size_t>(ch) * rows * cols + static_cast<size_t>(col) * rows + row) * elem_bytes;
                std::memcpy(destination + dst_offset, src, elem_bytes);
            }
        }
    }
}

bool image_to_mat(const IpcvDecodedImage& image, cv::Mat& mat, char *error)
{
    const size_t elem_bytes = depth_size(image.depth);
    const size_t expected_bytes = static_cast<size_t>(image.rows) * image.cols * image.channels * elem_bytes;
    if (image.data == NULL || image.rows <= 0 || image.cols <= 0 || image.channels <= 0 || elem_bytes == 0 || image.byte_count != expected_bytes)
    {
        if (error != NULL)
        {
            std::strcpy(error, "invalid image input");
        }
        return false;
    }

    mat.create(image.rows, image.cols, CV_MAKETYPE(image.depth, image.channels));
    copy_scilab_layout_to_mat(image.data, mat);
    return true;
}

bool mat_to_image(const cv::Mat& mat, IpcvDecodedImage *image)
{
    if (image == NULL || mat.empty())
    {
        return false;
    }

    std::memset(image, 0, sizeof(*image));
    image->rows = mat.rows;
    image->cols = mat.cols;
    image->channels = mat.channels();
    image->depth = mat.depth();
    image->byte_count = mat.total() * mat.elemSize();
    image->data = static_cast<unsigned char*>(std::malloc(image->byte_count));
    if (image->data == NULL)
    {
        set_error(image, "out of memory");
        return false;
    }

    copy_to_scilab_layout(mat, image->data);
    return true;
}
}

extern "C" IPCV_CORE_API int ipcv_watershed_image(const IpcvDecodedImage *source, const IpcvDecodedImage *markers, int object_count, IpcvDecodedImage *color_output, IpcvDecodedImage *marker_output)
{
    if (color_output == NULL || marker_output == NULL)
    {
        return -1;
    }

    std::memset(color_output, 0, sizeof(*color_output));
    std::memset(marker_output, 0, sizeof(*marker_output));
    if (source == NULL || markers == NULL)
    {
        set_error(color_output, "missing watershed input");
        return -1;
    }
    if (object_count < 0)
    {
        set_error(color_output, "object count must be non-negative");
        return -1;
    }

    try
    {
        cv::setNumThreads(1);
        cv::setUseOptimized(false);

        cv::Mat source_mat;
        cv::Mat marker_mat;
        char error[256] = {0};
        if (!image_to_mat(*source, source_mat, error))
        {
            set_error(color_output, error);
            return -1;
        }
        if (!image_to_mat(*markers, marker_mat, error))
        {
            set_error(color_output, error);
            return -1;
        }
        if (source_mat.channels() != 3 || source_mat.depth() != CV_8U)
        {
            set_error(color_output, "watershed requires an 8-bit RGB image");
            return -1;
        }
        if (marker_mat.channels() != 1 || marker_mat.rows != source_mat.rows || marker_mat.cols != source_mat.cols)
        {
            set_error(color_output, "watershed markers must be a single-channel image with the same size as the source");
            return -1;
        }

        cv::Mat watershed_markers;
        marker_mat.convertTo(watershed_markers, CV_32S);
        cv::watershed(source_mat, watershed_markers);

        cv::RNG rng(12345);
        std::vector<cv::Vec3b> colors;
        for (int i = 0; i < object_count; i++)
        {
            colors.push_back(cv::Vec3b(static_cast<uchar>(rng.uniform(0, 256)), static_cast<uchar>(rng.uniform(0, 256)), static_cast<uchar>(rng.uniform(0, 256))));
        }

        cv::Mat color_result = cv::Mat::zeros(watershed_markers.size(), CV_8UC3);
        for (int row = 0; row < watershed_markers.rows; row++)
        {
            for (int col = 0; col < watershed_markers.cols; col++)
            {
                const int index = watershed_markers.at<int>(row, col);
                if (index > 0 && index <= object_count)
                {
                    color_result.at<cv::Vec3b>(row, col) = colors[index - 1];
                }
            }
        }

        if (!mat_to_image(color_result, color_output))
        {
            if (color_output->error[0] == 0)
            {
                set_error(color_output, "could not convert watershed color output");
            }
            return -1;
        }
        if (!mat_to_image(watershed_markers, marker_output))
        {
            if (marker_output->error[0] == 0)
            {
                set_error(marker_output, "could not convert watershed marker output");
            }
            ipcv_free_decoded_image(color_output);
            return -1;
        }
        return 0;
    }
    catch (const cv::Exception& e)
    {
        set_error(color_output, e.what());
        return -1;
    }
    catch (const std::exception& e)
    {
        set_error(color_output, e.what());
        return -1;
    }
    catch (...)
    {
        set_error(color_output, "unknown watershed failure");
        return -1;
    }
}
