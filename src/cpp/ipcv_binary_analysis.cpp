#define IPCV_CORE_EXPORTS
#include "ipcv_binary_analysis.h"

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
    const size_t elemBytes = destination.elemSize1();

    for (int ch = 0; ch < channels; ch++)
    {
        int dstCh = ch;
        if ((channels == 3 || channels == 4) && ch < 3)
        {
            dstCh = 2 - ch;
        }

        for (int col = 0; col < cols; col++)
        {
            for (int row = 0; row < rows; row++)
            {
                const size_t srcOffset = (static_cast<size_t>(ch) * rows * cols + static_cast<size_t>(col) * rows + row) * elemBytes;
                unsigned char *dst = destination.ptr<unsigned char>(row) + ((col * channels + dstCh) * elemBytes);
                std::memcpy(dst, source + srcOffset, elemBytes);
            }
        }
    }
}

void copy_to_scilab_layout(const cv::Mat& source, unsigned char *destination)
{
    const int rows = source.rows;
    const int cols = source.cols;
    const int channels = source.channels();
    const size_t elemBytes = source.elemSize1();

    for (int ch = 0; ch < channels; ch++)
    {
        int srcCh = ch;
        if ((channels == 3 || channels == 4) && ch < 3)
        {
            srcCh = 2 - ch;
        }

        for (int col = 0; col < cols; col++)
        {
            for (int row = 0; row < rows; row++)
            {
                const unsigned char *src = source.ptr<unsigned char>(row) + ((col * channels + srcCh) * elemBytes);
                const size_t dstOffset = (static_cast<size_t>(ch) * rows * cols + static_cast<size_t>(col) * rows + row) * elemBytes;
                std::memcpy(destination + dstOffset, src, elemBytes);
            }
        }
    }
}

void copy_float_to_double_scilab_layout(const cv::Mat& source, double *destination)
{
    const int rows = source.rows;
    const int cols = source.cols;
    const int channels = source.channels();

    for (int ch = 0; ch < channels; ch++)
    {
        int srcCh = ch;
        if ((channels == 3 || channels == 4) && ch < 3)
        {
            srcCh = 2 - ch;
        }

        for (int col = 0; col < cols; col++)
        {
            for (int row = 0; row < rows; row++)
            {
                const float *src = source.ptr<float>(row) + (col * channels + srcCh);
                const size_t dstOffset = static_cast<size_t>(ch) * rows * cols + static_cast<size_t>(col) * rows + row;
                destination[dstOffset] = static_cast<double>(*src);
            }
        }
    }
}

bool image_to_mat(const IpcvDecodedImage& image, cv::Mat& mat, char *error)
{
    const size_t elemBytes = depth_size(image.depth);
    const size_t expectedBytes = static_cast<size_t>(image.rows) * image.cols * image.channels * elemBytes;
    if (image.data == NULL || image.rows <= 0 || image.cols <= 0 || image.channels <= 0 || elemBytes == 0 || image.byte_count != expectedBytes)
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
    image->depth = mat.depth() == CV_32F ? IPCV_DEPTH_64F : mat.depth();
    image->byte_count = mat.depth() == CV_32F ? mat.total() * mat.channels() * sizeof(double) : mat.total() * mat.elemSize();
    image->data = static_cast<unsigned char*>(std::malloc(image->byte_count));
    if (image->data == NULL)
    {
        set_error(image, "out of memory");
        return false;
    }

    if (mat.depth() == CV_32F)
    {
        copy_float_to_double_scilab_layout(mat, reinterpret_cast<double*>(image->data));
    }
    else
    {
        copy_to_scilab_layout(mat, image->data);
    }
    return true;
}

bool make_binary_mask(const IpcvDecodedImage *source, cv::Mat& mask, IpcvDecodedImage *output)
{
    cv::Mat sourceMat;
    char error[256] = {0};
    if (!image_to_mat(*source, sourceMat, error))
    {
        set_error(output, error);
        return false;
    }
    if (sourceMat.channels() != 1)
    {
        set_error(output, "binary analysis requires a single-channel image");
        return false;
    }

    cv::compare(sourceMat, cv::Scalar(0), mask, cv::CMP_NE);
    return true;
}

int validate_distance_method(int method)
{
    switch (method)
    {
    case 1:
    case 2:
    case 3:
        return method;
    default:
        return -1;
    }
}
}

extern "C" IPCV_CORE_API int ipcv_distance_l1_image(const IpcvDecodedImage *source, IpcvDecodedImage *output)
{
    if (output == NULL)
    {
        return -1;
    }

    std::memset(output, 0, sizeof(*output));
    if (source == NULL)
    {
        set_error(output, "missing image input");
        return -1;
    }

    try
    {
        cv::setNumThreads(1);
        cv::setUseOptimized(false);

        cv::Mat mask;
        cv::Mat dist;
        if (!make_binary_mask(source, mask, output))
        {
            return -1;
        }

        cv::distanceTransform(mask, dist, 1, 3);
        if (!mat_to_image(dist, output))
        {
            if (output->error[0] == 0)
            {
                set_error(output, "could not convert distance result");
            }
            return -1;
        }
        return 0;
    }
    catch (const cv::Exception& e)
    {
        set_error(output, e.what());
        return -1;
    }
    catch (const std::exception& e)
    {
        set_error(output, e.what());
        return -1;
    }
    catch (...)
    {
        set_error(output, "unknown distance transform failure");
        return -1;
    }
}

extern "C" IPCV_CORE_API int ipcv_distance_transform_image(const IpcvDecodedImage *source, int method, IpcvDecodedImage *output)
{
    if (output == NULL)
    {
        return -1;
    }

    std::memset(output, 0, sizeof(*output));
    if (source == NULL)
    {
        set_error(output, "missing image input");
        return -1;
    }

    const int distanceType = validate_distance_method(method);
    if (distanceType < 0)
    {
        set_error(output, "distance method must be 1, 2, or 3");
        return -1;
    }

    try
    {
        cv::setNumThreads(1);
        cv::setUseOptimized(false);

        cv::Mat mask;
        cv::Mat dist;
        if (!make_binary_mask(source, mask, output))
        {
            return -1;
        }

        cv::distanceTransform(mask, dist, distanceType, 3);
        cv::normalize(dist, dist, 0, 1.0, cv::NORM_MINMAX);
        if (!mat_to_image(dist, output))
        {
            if (output->error[0] == 0)
            {
                set_error(output, "could not convert distance transform result");
            }
            return -1;
        }
        return 0;
    }
    catch (const cv::Exception& e)
    {
        set_error(output, e.what());
        return -1;
    }
    catch (const std::exception& e)
    {
        set_error(output, e.what());
        return -1;
    }
    catch (...)
    {
        set_error(output, "unknown distance transform failure");
        return -1;
    }
}

extern "C" IPCV_CORE_API int ipcv_fill_binary_image(const IpcvDecodedImage *source, IpcvDecodedImage *output)
{
    if (output == NULL)
    {
        return -1;
    }

    std::memset(output, 0, sizeof(*output));
    if (source == NULL)
    {
        set_error(output, "missing image input");
        return -1;
    }

    try
    {
        cv::setNumThreads(1);
        cv::setUseOptimized(false);

        cv::Mat mask;
        cv::Mat filled;
        std::vector<std::vector<cv::Point> > contours;
        std::vector<cv::Vec4i> hierarchy;
        if (!make_binary_mask(source, mask, output))
        {
            return -1;
        }

        cv::findContours(mask, contours, hierarchy, cv::RETR_CCOMP, cv::CHAIN_APPROX_SIMPLE, cv::Point(0, 0));
        filled = cv::Mat::zeros(mask.size(), CV_8UC1);
        for (size_t i = 0; i < contours.size(); i++)
        {
            cv::drawContours(filled, contours, static_cast<int>(i), cv::Scalar(255), -1, 8, hierarchy, 0, cv::Point());
        }

        if (!mat_to_image(filled, output))
        {
            if (output->error[0] == 0)
            {
                set_error(output, "could not convert filled binary image");
            }
            return -1;
        }
        return 0;
    }
    catch (const cv::Exception& e)
    {
        set_error(output, e.what());
        return -1;
    }
    catch (const std::exception& e)
    {
        set_error(output, e.what());
        return -1;
    }
    catch (...)
    {
        set_error(output, "unknown binary fill failure");
        return -1;
    }
}

extern "C" IPCV_CORE_API int ipcv_label_binary_image(const IpcvDecodedImage *source, IpcvDecodedImage *output)
{
    if (output == NULL)
    {
        return -1;
    }

    std::memset(output, 0, sizeof(*output));
    if (source == NULL)
    {
        set_error(output, "missing image input");
        return -1;
    }

    try
    {
        cv::setNumThreads(1);
        cv::setUseOptimized(false);

        cv::Mat mask;
        cv::Mat labels;
        cv::Mat labels64;
        if (!make_binary_mask(source, mask, output))
        {
            return -1;
        }

        cv::connectedComponents(mask, labels, 4, CV_32S);
        labels.convertTo(labels64, CV_64F);
        if (!mat_to_image(labels64, output))
        {
            if (output->error[0] == 0)
            {
                set_error(output, "could not convert label image");
            }
            return -1;
        }
        return 0;
    }
    catch (const cv::Exception& e)
    {
        set_error(output, e.what());
        return -1;
    }
    catch (const std::exception& e)
    {
        set_error(output, e.what());
        return -1;
    }
    catch (...)
    {
        set_error(output, "unknown binary label failure");
        return -1;
    }
}
