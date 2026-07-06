#define IPCV_DECODE_EXPORTS
#include "ipcv_decode.h"

#include <opencv2/core.hpp>
#include <opencv2/imgcodecs.hpp>

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

void set_info_error(IpcvImageInfo *info, const char *message)
{
    if (info == NULL)
    {
        return;
    }

    std::strncpy(info->error, message, sizeof(info->error) - 1);
    info->error[sizeof(info->error) - 1] = 0;
}

void set_buffer_error(char *error, size_t errorSize, const char *message)
{
    if (error == NULL || errorSize == 0)
    {
        return;
    }

    std::strncpy(error, message, errorSize - 1);
    error[errorSize - 1] = 0;
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
}

extern "C" IPCV_DECODE_API int ipcv_image_info(const char *filename, int flags, IpcvImageInfo *info)
{
    if (info == NULL)
    {
        return -1;
    }

    std::memset(info, 0, sizeof(*info));
    if (filename == NULL || filename[0] == 0)
    {
        set_info_error(info, "empty filename");
        return -1;
    }

    try
    {
        cv::setNumThreads(1);
        cv::setUseOptimized(false);

        cv::Mat image = cv::imread(filename, flags);
        if (image.empty())
        {
            set_info_error(info, "OpenCV could not read image");
            return -1;
        }

        info->width = image.cols;
        info->height = image.rows;
        info->depth = image.depth();
        info->channels = image.channels();
        return 0;
    }
    catch (const cv::Exception& e)
    {
        set_info_error(info, e.what());
        return -1;
    }
    catch (const std::exception& e)
    {
        set_info_error(info, e.what());
        return -1;
    }
    catch (...)
    {
        set_info_error(info, "unknown image info failure");
        return -1;
    }
}

extern "C" IPCV_DECODE_API int ipcv_write_image(const char *filename, const unsigned char *data, int rows, int cols, int channels, int depth, int jpeg_quality, char *error, size_t error_size)
{
    if (error != NULL && error_size > 0)
    {
        error[0] = 0;
    }

    if (filename == NULL || filename[0] == 0)
    {
        set_buffer_error(error, error_size, "empty filename");
        return -1;
    }
    if (data == NULL || rows <= 0 || cols <= 0 || channels <= 0)
    {
        set_buffer_error(error, error_size, "empty image");
        return -1;
    }

    try
    {
        cv::setNumThreads(1);
        cv::setUseOptimized(false);

        const size_t elemBytes = depth_size(depth);
        if (elemBytes == 0)
        {
            set_buffer_error(error, error_size, "unsupported image depth");
            return -1;
        }

        cv::Mat image(rows, cols, CV_MAKETYPE(depth, channels));
        copy_scilab_layout_to_mat(data, image);
        std::vector<int> params;
        params.push_back(cv::IMWRITE_JPEG_QUALITY);
        params.push_back(jpeg_quality);

        return cv::imwrite(filename, image, params) ? 1 : 0;
    }
    catch (const cv::Exception& e)
    {
        set_buffer_error(error, error_size, e.what());
        return -1;
    }
    catch (const std::exception& e)
    {
        set_buffer_error(error, error_size, e.what());
        return -1;
    }
    catch (...)
    {
        set_buffer_error(error, error_size, "unknown image write failure");
        return -1;
    }
}

extern "C" IPCV_DECODE_API int ipcv_decode_image(const char *filename, int flags, IpcvDecodedImage *image)
{
    if (image == NULL)
    {
        return -1;
    }

    std::memset(image, 0, sizeof(*image));
    if (filename == NULL || filename[0] == 0)
    {
        set_error(image, "empty filename");
        return -1;
    }

    try
    {
        cv::setNumThreads(1);
        cv::setUseOptimized(false);

        cv::Mat decoded = cv::imread(filename, flags);
        if (decoded.empty())
        {
            set_error(image, "OpenCV could not read image");
            return -1;
        }

        if (!decoded.isContinuous())
        {
            decoded = decoded.clone();
        }

        image->rows = decoded.rows;
        image->cols = decoded.cols;
        image->channels = decoded.channels();
        image->depth = decoded.depth() == CV_32F ? IPCV_DEPTH_64F : decoded.depth();
        image->byte_count = decoded.depth() == CV_32F ? decoded.total() * decoded.channels() * sizeof(double) : decoded.total() * decoded.elemSize();
        image->data = static_cast<unsigned char*>(std::malloc(image->byte_count));
        if (image->data == NULL)
        {
            set_error(image, "out of memory");
            return -1;
        }

        if (decoded.depth() == CV_32F)
        {
            copy_float_to_double_scilab_layout(decoded, reinterpret_cast<double*>(image->data));
        }
        else
        {
            copy_to_scilab_layout(decoded, image->data);
        }
        return 0;
    }
    catch (const cv::Exception& e)
    {
        set_error(image, e.what());
        return -1;
    }
    catch (const std::exception& e)
    {
        set_error(image, e.what());
        return -1;
    }
    catch (...)
    {
        set_error(image, "unknown decoder failure");
        return -1;
    }
}

extern "C" IPCV_DECODE_API void ipcv_free_decoded_image(IpcvDecodedImage *image)
{
    if (image == NULL)
    {
        return;
    }

    std::free(image->data);
    image->data = NULL;
    image->byte_count = 0;
}
