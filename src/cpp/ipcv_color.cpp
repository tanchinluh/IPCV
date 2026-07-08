#define IPCV_CORE_EXPORTS
#include "ipcv_color.h"

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

void copy_scilab_layout_to_mat(const unsigned char *source, cv::Mat& destination, bool swapRgbChannels)
{
    const int rows = destination.rows;
    const int cols = destination.cols;
    const int channels = destination.channels();
    const size_t elemBytes = destination.elemSize1();

    for (int ch = 0; ch < channels; ch++)
    {
        int dstCh = ch;
        if (swapRgbChannels && (channels == 3 || channels == 4) && ch < 3)
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

void copy_to_scilab_layout(const cv::Mat& source, unsigned char *destination, bool swapRgbChannels)
{
    const int rows = source.rows;
    const int cols = source.cols;
    const int channels = source.channels();
    const size_t elemBytes = source.elemSize1();

    for (int ch = 0; ch < channels; ch++)
    {
        int srcCh = ch;
        if (swapRgbChannels && (channels == 3 || channels == 4) && ch < 3)
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

void copy_float_to_double_scilab_layout(const cv::Mat& source, double *destination, bool swapRgbChannels)
{
    const int rows = source.rows;
    const int cols = source.cols;
    const int channels = source.channels();

    for (int ch = 0; ch < channels; ch++)
    {
        int srcCh = ch;
        if (swapRgbChannels && (channels == 3 || channels == 4) && ch < 3)
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

bool image_to_mat(const IpcvDecodedImage& image, cv::Mat& mat, bool swapRgbChannels, char *error)
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
    copy_scilab_layout_to_mat(image.data, mat, swapRgbChannels);
    return true;
}

bool mat_to_image(const cv::Mat& mat, bool swapRgbChannels, IpcvDecodedImage *image)
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
        copy_float_to_double_scilab_layout(mat, reinterpret_cast<double*>(image->data), swapRgbChannels);
    }
    else
    {
        copy_to_scilab_layout(mat, image->data, swapRgbChannels);
    }
    return true;
}

int opencv_conversion_code(int conversion)
{
    switch (conversion)
    {
    case IPCV_COLOR_RGB2GRAY:
        return cv::COLOR_BGR2GRAY;
    case IPCV_COLOR_RGB2LAB:
        return cv::COLOR_BGR2Lab;
    case IPCV_COLOR_BGR2LAB:
        return cv::COLOR_BGR2Lab;
    case IPCV_COLOR_RGB2HSV:
        return cv::COLOR_BGR2HSV;
    case IPCV_COLOR_HSV2RGB:
        return cv::COLOR_HSV2BGR;
    case IPCV_COLOR_RGB2YCRCB:
        return cv::COLOR_BGR2YCrCb;
    case IPCV_COLOR_YCRCB2RGB:
        return cv::COLOR_YCrCb2BGR;
    case IPCV_COLOR_LAB2RGB:
        return cv::COLOR_Lab2BGR;
    case IPCV_COLOR_GRAY2RGB:
        return cv::COLOR_GRAY2BGR;
    case IPCV_COLOR_RGB2HLS:
        return cv::COLOR_BGR2HLS;
    case IPCV_COLOR_HLS2RGB:
        return cv::COLOR_HLS2BGR;
    case IPCV_COLOR_RGB2XYZ:
        return cv::COLOR_BGR2XYZ;
    case IPCV_COLOR_XYZ2RGB:
        return cv::COLOR_XYZ2BGR;
    case IPCV_COLOR_RGB2LUV:
        return cv::COLOR_BGR2Luv;
    case IPCV_COLOR_LUV2RGB:
        return cv::COLOR_Luv2BGR;
    case IPCV_COLOR_RGB2YUV:
        return cv::COLOR_BGR2YUV;
    case IPCV_COLOR_YUV2RGB:
        return cv::COLOR_YUV2BGR;
    default:
        return -1;
    }
}

int expected_input_channels(int conversion)
{
    return conversion == IPCV_COLOR_GRAY2RGB ? 1 : 3;
}

bool conversion_input_is_rgb(int conversion)
{
    switch (conversion)
    {
    case IPCV_COLOR_RGB2GRAY:
    case IPCV_COLOR_RGB2LAB:
    case IPCV_COLOR_RGB2HSV:
    case IPCV_COLOR_RGB2YCRCB:
    case IPCV_COLOR_RGB2HLS:
    case IPCV_COLOR_RGB2XYZ:
    case IPCV_COLOR_RGB2LUV:
    case IPCV_COLOR_RGB2YUV:
        return true;
    default:
        return false;
    }
}

bool conversion_output_is_rgb(int conversion)
{
    switch (conversion)
    {
    case IPCV_COLOR_HSV2RGB:
    case IPCV_COLOR_YCRCB2RGB:
    case IPCV_COLOR_LAB2RGB:
    case IPCV_COLOR_GRAY2RGB:
    case IPCV_COLOR_HLS2RGB:
    case IPCV_COLOR_XYZ2RGB:
    case IPCV_COLOR_LUV2RGB:
    case IPCV_COLOR_YUV2RGB:
        return true;
    default:
        return false;
    }
}
}

extern "C" IPCV_CORE_API int ipcv_convert_color_image(const IpcvDecodedImage *source, int conversion, IpcvDecodedImage *output)
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

    const int code = opencv_conversion_code(conversion);
    if (code < 0)
    {
        set_error(output, "unsupported color conversion");
        return -1;
    }

    try
    {
        cv::setNumThreads(1);
        cv::setUseOptimized(false);

        cv::Mat sourceMat;
        cv::Mat converted;
        char error[256] = {0};
        if (!image_to_mat(*source, sourceMat, conversion_input_is_rgb(conversion), error))
        {
            set_error(output, error);
            return -1;
        }
        const int expectedChannels = expected_input_channels(conversion);
        if (sourceMat.channels() != expectedChannels)
        {
            if (expectedChannels == 1)
            {
                set_error(output, "color conversion requires a single-channel image");
            }
            else
            {
                set_error(output, "color conversion requires a 3-channel image");
            }
            return -1;
        }
        if (sourceMat.depth() == CV_64F)
        {
            sourceMat.convertTo(sourceMat, CV_32F);
        }

        cv::cvtColor(sourceMat, converted, code);
        if (!mat_to_image(converted, conversion_output_is_rgb(conversion), output))
        {
            if (output->error[0] == 0)
            {
                set_error(output, "could not convert color result");
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
        set_error(output, "unknown color conversion failure");
        return -1;
    }
}
