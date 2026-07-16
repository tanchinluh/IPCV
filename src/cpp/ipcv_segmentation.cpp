#define IPCV_CORE_EXPORTS
#include "ipcv_segmentation.h"

#include <opencv2/core.hpp>
#include <opencv2/imgproc.hpp>
#include <opencv2/ximgproc.hpp>

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

extern "C" IPCV_CORE_API int ipcv_kmeans_image(const IpcvDecodedImage *source, int cluster_count, IpcvDecodedImage *labels, IpcvDecodedImage *centers)
{
    if (labels == NULL || centers == NULL)
    {
        return -1;
    }
    std::memset(labels, 0, sizeof(*labels));
    std::memset(centers, 0, sizeof(*centers));
    if (source == NULL || cluster_count < 2)
    {
        set_error(labels, "k-means requires an image and at least two clusters");
        return -1;
    }

    try
    {
        cv::Mat source_mat;
        char error[256] = {0};
        if (!image_to_mat(*source, source_mat, error))
        {
            set_error(labels, error);
            return -1;
        }
        if (source_mat.empty() || source_mat.channels() > 4)
        {
            set_error(labels, "unsupported image channel count");
            return -1;
        }

        cv::Mat samples;
        source_mat.convertTo(samples, CV_32F);
        samples = samples.reshape(1, source_mat.rows * source_mat.cols);
        cv::Mat label_vector;
        cv::Mat center_matrix;
        cv::kmeans(samples, cluster_count, label_vector,
                   cv::TermCriteria(cv::TermCriteria::EPS + cv::TermCriteria::MAX_ITER, 100, 0.1),
                   3, cv::KMEANS_PP_CENTERS, center_matrix);

        cv::Mat label_image = label_vector.reshape(1, source_mat.rows);
        label_image.convertTo(label_image, CV_64F);
        label_image += 1.0;
        center_matrix.convertTo(center_matrix, CV_64F);

        if (!mat_to_image(label_image, labels) || !mat_to_image(center_matrix, centers))
        {
            if (labels->error[0] == 0) set_error(labels, "could not convert k-means output");
            ipcv_free_decoded_image(centers);
            return -1;
        }
        return 0;
    }
    catch (const cv::Exception& e)
    {
        set_error(labels, e.what());
        return -1;
    }
    catch (const std::exception& e)
    {
        set_error(labels, e.what());
        return -1;
    }
}

extern "C" IPCV_CORE_API int ipcv_grabcut_image(const IpcvDecodedImage *source, const double rect[4], int iterations, IpcvDecodedImage *mask, IpcvDecodedImage *foreground)
{
    if (mask == NULL || foreground == NULL)
    {
        return -1;
    }
    std::memset(mask, 0, sizeof(*mask));
    std::memset(foreground, 0, sizeof(*foreground));
    if (source == NULL || rect == NULL || iterations < 1)
    {
        set_error(mask, "grabcut requires an image, rectangle, and positive iteration count");
        return -1;
    }

    try
    {
        cv::Mat source_mat;
        char error[256] = {0};
        if (!image_to_mat(*source, source_mat, error))
        {
            set_error(mask, error);
            return -1;
        }
        if (source_mat.depth() != CV_8U || (source_mat.channels() != 3 && source_mat.channels() != 4))
        {
            set_error(mask, "grabcut requires an 8-bit RGB image");
            return -1;
        }
        if (source_mat.channels() == 4)
        {
            cv::cvtColor(source_mat, source_mat, cv::COLOR_BGRA2BGR);
        }

        int x = static_cast<int>(std::round(rect[0]));
        int y = static_cast<int>(std::round(rect[1]));
        int width = static_cast<int>(std::round(rect[2]));
        int height = static_cast<int>(std::round(rect[3]));
        cv::Rect bounds(0, 0, source_mat.cols, source_mat.rows);
        cv::Rect roi(x, y, width, height);
        roi &= bounds;
        if (roi.width < 2 || roi.height < 2)
        {
            set_error(mask, "grabcut rectangle must overlap the image with at least 2 pixels in each direction");
            return -1;
        }

        cv::Mat gc_mask(source_mat.size(), CV_8UC1, cv::Scalar(cv::GC_BGD));
        cv::Mat bg_model, fg_model;
        cv::grabCut(source_mat, gc_mask, roi, bg_model, fg_model, iterations, cv::GC_INIT_WITH_RECT);
        cv::Mat foreground_mask = (gc_mask == cv::GC_FGD) | (gc_mask == cv::GC_PR_FGD);
        cv::Mat binary_mask = cv::Mat::zeros(source_mat.size(), CV_8UC1);
        binary_mask.setTo(1, foreground_mask);
        cv::Mat foreground_image = cv::Mat::zeros(source_mat.size(), source_mat.type());
        source_mat.copyTo(foreground_image, foreground_mask);

        if (!mat_to_image(binary_mask, mask) || !mat_to_image(foreground_image, foreground))
        {
            if (mask->error[0] == 0) set_error(mask, "could not convert grabcut output");
            ipcv_free_decoded_image(foreground);
            return -1;
        }
        return 0;
    }
    catch (const cv::Exception& e)
    {
        set_error(mask, e.what());
        return -1;
    }
    catch (const std::exception& e)
    {
        set_error(mask, e.what());
        return -1;
    }
}

extern "C" IPCV_CORE_API int ipcv_superpixels_image(const IpcvDecodedImage *source, int region_size, double ruler, int iterations, IpcvDecodedImage *labels, IpcvDecodedImage *contours)
{
    if (labels == NULL || contours == NULL)
    {
        return -1;
    }
    std::memset(labels, 0, sizeof(*labels));
    std::memset(contours, 0, sizeof(*contours));
    if (source == NULL || region_size < 2 || ruler <= 0 || iterations < 1)
    {
        set_error(labels, "superpixels require positive region size, ruler, and iteration count");
        return -1;
    }

    try
    {
        cv::Mat source_mat;
        char error[256] = {0};
        if (!image_to_mat(*source, source_mat, error))
        {
            set_error(labels, error);
            return -1;
        }
        if (source_mat.depth() != CV_8U || (source_mat.channels() != 1 && source_mat.channels() != 3))
        {
            set_error(labels, "superpixels require an 8-bit grayscale or RGB image");
            return -1;
        }
        cv::Mat color_image = source_mat;
        if (source_mat.channels() == 1)
        {
            cv::cvtColor(source_mat, color_image, cv::COLOR_GRAY2BGR);
        }

        cv::Ptr<cv::ximgproc::SuperpixelSLIC> slic = cv::ximgproc::createSuperpixelSLIC(color_image, cv::ximgproc::SLICO, region_size, static_cast<float>(ruler));
        slic->iterate(iterations);
        cv::Mat label_image;
        cv::Mat contour_image;
        slic->getLabels(label_image);
        slic->getLabelContourMask(contour_image, false);
        label_image.convertTo(label_image, CV_64F);

        if (!mat_to_image(label_image, labels) || !mat_to_image(contour_image, contours))
        {
            if (labels->error[0] == 0) set_error(labels, "could not convert superpixel output");
            ipcv_free_decoded_image(contours);
            return -1;
        }
        return 0;
    }
    catch (const cv::Exception& e)
    {
        set_error(labels, e.what());
        return -1;
    }
    catch (const std::exception& e)
    {
        set_error(labels, e.what());
        return -1;
    }
}
