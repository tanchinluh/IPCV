#define IPCV_CORE_EXPORTS
#include "ipcv_filtering.h"

#include <opencv2/core.hpp>
#include <opencv2/imgproc.hpp>

#include <cstdlib>
#include <cstring>
#include <exception>

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
}

extern "C" IPCV_CORE_API int ipcv_filter2d_image(const IpcvDecodedImage *source, const IpcvDecodedImage *kernel, int output_depth_mode, IpcvDecodedImage *output)
{
    if (output == NULL)
    {
        return -1;
    }

    std::memset(output, 0, sizeof(*output));
    if (source == NULL || kernel == NULL)
    {
        set_error(output, "missing image or kernel input");
        return -1;
    }

    try
    {
        cv::setNumThreads(1);
        cv::setUseOptimized(false);

        cv::Mat sourceMat;
        cv::Mat kernelMat;
        cv::Mat filtered;
        char error[256] = {0};
        if (!image_to_mat(*source, sourceMat, error))
        {
            set_error(output, error);
            return -1;
        }
        if (!image_to_mat(*kernel, kernelMat, error))
        {
            set_error(output, error);
            return -1;
        }
        if (kernelMat.channels() != 1)
        {
            set_error(output, "filter kernel must be a 2D matrix");
            return -1;
        }

        const int ddepth = output_depth_mode == IPCV_FILTER_OUTPUT_DOUBLE ? CV_64F : -1;
        cv::filter2D(sourceMat, filtered, ddepth, kernelMat);
        if (!mat_to_image(filtered, output))
        {
            if (output->error[0] == 0)
            {
                set_error(output, "could not convert filtered image");
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
        set_error(output, "unknown filtering failure");
        return -1;
    }
}

extern "C" IPCV_CORE_API int ipcv_blur_image(const IpcvDecodedImage *source, int kernel_rows, int kernel_cols, IpcvDecodedImage *output)
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
    if (kernel_rows <= 0 || kernel_cols <= 0)
    {
        set_error(output, "kernel size must be positive");
        return -1;
    }

    try
    {
        cv::setNumThreads(1);
        cv::setUseOptimized(false);

        cv::Mat sourceMat;
        cv::Mat filtered;
        char error[256] = {0};
        if (!image_to_mat(*source, sourceMat, error))
        {
            set_error(output, error);
            return -1;
        }

        cv::blur(sourceMat, filtered, cv::Size(kernel_cols, kernel_rows));
        if (!mat_to_image(filtered, output))
        {
            if (output->error[0] == 0)
            {
                set_error(output, "could not convert blur result");
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
        set_error(output, "unknown blur failure");
        return -1;
    }
}

extern "C" IPCV_CORE_API int ipcv_gaussian_blur_image(const IpcvDecodedImage *source, int kernel_rows, int kernel_cols, double sigma_x, double sigma_y, IpcvDecodedImage *output)
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
    if (kernel_rows <= 0 || kernel_cols <= 0 || (kernel_rows % 2) == 0 || (kernel_cols % 2) == 0)
    {
        set_error(output, "Gaussian kernel size must be positive and odd");
        return -1;
    }
    if (sigma_x < 0.0 || sigma_y < 0.0)
    {
        set_error(output, "Gaussian sigma values must be non-negative");
        return -1;
    }

    try
    {
        cv::setNumThreads(1);
        cv::setUseOptimized(false);

        cv::Mat sourceMat;
        cv::Mat filtered;
        char error[256] = {0};
        if (!image_to_mat(*source, sourceMat, error))
        {
            set_error(output, error);
            return -1;
        }

        cv::GaussianBlur(sourceMat, filtered, cv::Size(kernel_cols, kernel_rows), sigma_x, sigma_y);
        if (!mat_to_image(filtered, output))
        {
            if (output->error[0] == 0)
            {
                set_error(output, "could not convert Gaussian blur result");
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
        set_error(output, "unknown Gaussian blur failure");
        return -1;
    }
}

extern "C" IPCV_CORE_API int ipcv_bilateral_filter_image(const IpcvDecodedImage *source, int diameter, double sigma_color, double sigma_space, IpcvDecodedImage *output)
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
    if (diameter <= 0)
    {
        set_error(output, "bilateral filter diameter must be positive");
        return -1;
    }
    if (sigma_color <= 0.0 || sigma_space <= 0.0)
    {
        set_error(output, "bilateral filter sigma values must be positive");
        return -1;
    }

    try
    {
        cv::setNumThreads(1);
        cv::setUseOptimized(false);

        cv::Mat sourceMat;
        cv::Mat filtered;
        char error[256] = {0};
        if (!image_to_mat(*source, sourceMat, error))
        {
            set_error(output, error);
            return -1;
        }

        cv::bilateralFilter(sourceMat, filtered, diameter, sigma_color, sigma_space);
        if (!mat_to_image(filtered, output))
        {
            if (output->error[0] == 0)
            {
                set_error(output, "could not convert bilateral filter result");
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
        set_error(output, "unknown bilateral filter failure");
        return -1;
    }
}
