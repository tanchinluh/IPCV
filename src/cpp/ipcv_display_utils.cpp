#define IPCV_CORE_EXPORTS
#include "ipcv_display_utils.h"

#include <opencv2/core.hpp>
#include <opencv2/highgui.hpp>

#include <cstdlib>
#include <cstring>
#include <exception>

namespace
{
void copy_error(char *destination, int destination_size, const char *message)
{
    if (destination == NULL || destination_size <= 0)
    {
        return;
    }

    std::strncpy(destination, message, static_cast<size_t>(destination_size) - 1);
    destination[destination_size - 1] = 0;
}

void set_buffer_error(IpcvByteBuffer *buffer, const char *message)
{
    if (buffer == NULL)
    {
        return;
    }

    copy_error(buffer->error, static_cast<int>(sizeof(buffer->error)), message);
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

bool image_to_mat(const IpcvDecodedImage& image, cv::Mat& mat, char *error, int error_size)
{
    const size_t elem_bytes = depth_size(image.depth);
    const size_t expected_bytes = static_cast<size_t>(image.rows) * image.cols * image.channels * elem_bytes;
    if (image.data == NULL || image.rows <= 0 || image.cols <= 0 || image.channels <= 0 || elem_bytes == 0 || image.byte_count != expected_bytes)
    {
        copy_error(error, error_size, "invalid image input");
        return false;
    }

    mat.create(image.rows, image.cols, CV_MAKETYPE(image.depth, image.channels));
    copy_scilab_layout_to_mat(image.data, mat);
    return true;
}
}

extern "C" IPCV_CORE_API int ipcv_display_image(const IpcvDecodedImage *source, const char *window_name, double *status, char *error, int error_size)
{
    if (status != NULL)
    {
        *status = 0;
    }
    if (source == NULL)
    {
        copy_error(error, error_size, "missing display image input");
        return -1;
    }

    try
    {
        cv::Mat image;
        if (!image_to_mat(*source, image, error, error_size))
        {
            return -1;
        }

        cv::imshow(window_name == NULL ? "Display Window" : window_name, image);
        if (status != NULL)
        {
            *status = cv::waitKey(1) >= 0 ? -1.0 : 0.0;
        }
        return 0;
    }
    catch (const cv::Exception& e)
    {
        copy_error(error, error_size, e.what());
        return -1;
    }
    catch (const std::exception& e)
    {
        copy_error(error, error_size, e.what());
        return -1;
    }
}

extern "C" IPCV_CORE_API int ipcv_inspect_image(const IpcvDecodedImage *source, const char *window_name, char *error, int error_size)
{
    if (source == NULL)
    {
        copy_error(error, error_size, "missing inspect image input");
        return -1;
    }

    try
    {
        cv::Mat image;
        if (!image_to_mat(*source, image, error, error_size))
        {
            return -1;
        }

        const char *name = window_name == NULL ? "Inspect Window" : window_name;
        for (;;)
        {
            cv::namedWindow(name, cv::WINDOW_NORMAL | cv::WINDOW_KEEPRATIO | cv::WINDOW_GUI_EXPANDED);
            cv::imshow(name, image);
            if (cv::waitKey(30) >= 0)
            {
                break;
            }
        }

        cv::destroyWindow(name);
        return 0;
    }
    catch (const cv::Exception& e)
    {
        copy_error(error, error_size, e.what());
        return -1;
    }
    catch (const std::exception& e)
    {
        copy_error(error, error_size, e.what());
        return -1;
    }
}

extern "C" IPCV_CORE_API int ipcv_image_to_utf(const IpcvDecodedImage *source, IpcvByteBuffer *output)
{
    if (output == NULL)
    {
        return -1;
    }

    std::memset(output, 0, sizeof(*output));
    if (source == NULL)
    {
        set_buffer_error(output, "missing image input");
        return -1;
    }

    try
    {
        cv::Mat image;
        char error[256] = {0};
        if (!image_to_mat(*source, image, error, static_cast<int>(sizeof(error))))
        {
            set_buffer_error(output, error);
            return -1;
        }
        if (image.depth() != CV_8U)
        {
            set_buffer_error(output, "mat2utfimg requires a uint8 image");
            return -1;
        }

        const size_t capacity = static_cast<size_t>(image.rows) * image.cols * image.channels() * 2;
        output->data = static_cast<unsigned char*>(std::malloc(capacity == 0 ? 1 : capacity));
        if (output->data == NULL)
        {
            set_buffer_error(output, "out of memory");
            return -1;
        }

        int current = 0;
        for (int row = 0; row < image.rows; row++)
        {
            const unsigned char *row_data = image.ptr<unsigned char>(row);
            for (int col = 0; col < image.cols; col++)
            {
                for (int channel = image.channels() - 1; channel >= 0; channel--)
                {
                    const unsigned char pixel = row_data[col * image.channels() + channel];
                    if (pixel <= 127 && pixel > 0)
                    {
                        output->data[current++] = pixel;
                    }
                    else if (pixel == 0)
                    {
                        output->data[current++] = pixel + 1;
                    }
                    else
                    {
                        output->data[current++] = static_cast<unsigned char>((pixel >> 6) + 0xC0);
                        output->data[current++] = static_cast<unsigned char>((pixel & 0x3F) + 0x80);
                    }
                }
            }
        }

        output->count = current;
        return 0;
    }
    catch (const cv::Exception& e)
    {
        set_buffer_error(output, e.what());
        return -1;
    }
    catch (const std::exception& e)
    {
        set_buffer_error(output, e.what());
        return -1;
    }
}

extern "C" IPCV_CORE_API void ipcv_free_byte_buffer(IpcvByteBuffer *buffer)
{
    if (buffer == NULL)
    {
        return;
    }

    std::free(buffer->data);
    buffer->data = NULL;
    buffer->count = 0;
    buffer->error[0] = 0;
}
