#define IPCV_CORE_EXPORTS
#include "ipcv_image_io.h"

#include <opencv2/core.hpp>
#include <opencv2/imgcodecs.hpp>

#include <climits>
#include <cstdlib>
#include <cstring>
#include <exception>
#include <string>
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

int ipcv_depth_from_mat_depth(int depth)
{
    return depth == CV_32F ? IPCV_DEPTH_64F : depth;
}

bool validate_stack_page(const cv::Mat& page, int rows, int cols, int channels, int depth)
{
    return !page.empty() && page.rows == rows && page.cols == cols && page.channels() == channels && page.depth() == depth;
}

bool copy_page_to_stack_layout(const cv::Mat& page, int pageIndex, int rows, int cols, int channels, int targetDepth, unsigned char *destination)
{
    const size_t elemBytes = depth_size(targetDepth);
    if (elemBytes == 0)
    {
        return false;
    }

    cv::Mat converted;
    const cv::Mat *source = &page;
    if (page.depth() == CV_32F)
    {
        page.convertTo(converted, CV_64F);
        source = &converted;
    }

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
                const unsigned char *src = source->ptr<unsigned char>(row) + ((col * channels + srcCh) * elemBytes);
                const size_t dstOffset = (((static_cast<size_t>(pageIndex) * channels + ch) * rows * cols) + static_cast<size_t>(col) * rows + row) * elemBytes;
                std::memcpy(destination + dstOffset, src, elemBytes);
            }
        }
    }

    return true;
}

bool has_jpeg_extension(const char *filename)
{
    std::string path(filename == NULL ? "" : filename);
    const std::string::size_type dot = path.find_last_of('.');
    if (dot == std::string::npos)
    {
        return false;
    }

    std::string ext = path.substr(dot + 1);
    for (std::string::size_type i = 0; i < ext.size(); i++)
    {
        if (ext[i] >= 'A' && ext[i] <= 'Z')
        {
            ext[i] = static_cast<char>(ext[i] - 'A' + 'a');
        }
    }

    return ext == "jpg" || ext == "jpeg" || ext == "jpe";
}

bool has_png_extension(const char *filename)
{
    std::string path(filename == NULL ? "" : filename);
    const std::string::size_type dot = path.find_last_of('.');
    if (dot == std::string::npos)
    {
        return false;
    }

    std::string ext = path.substr(dot + 1);
    for (std::string::size_type i = 0; i < ext.size(); i++)
    {
        if (ext[i] >= 'A' && ext[i] <= 'Z')
        {
            ext[i] = static_cast<char>(ext[i] - 'A' + 'a');
        }
    }

    return ext == "png";
}
}

extern "C" IPCV_CORE_API int ipcv_image_info(const char *filename, int flags, IpcvImageInfo *info)
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
        const size_t pageCount = cv::imcount(filename, flags);
        info->pages = pageCount > static_cast<size_t>(INT_MAX) ? INT_MAX : static_cast<int>(pageCount);
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

extern "C" IPCV_CORE_API int ipcv_write_image(const char *filename, const unsigned char *data, int rows, int cols, int channels, int depth, int jpeg_quality, char *error, size_t error_size)
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
        if (has_jpeg_extension(filename))
        {
            params.push_back(cv::IMWRITE_JPEG_QUALITY);
            params.push_back(jpeg_quality);
        }
        else if (has_png_extension(filename) && jpeg_quality >= 0 && jpeg_quality <= 9)
        {
            params.push_back(cv::IMWRITE_PNG_COMPRESSION);
            params.push_back(jpeg_quality);
        }

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

extern "C" IPCV_CORE_API int ipcv_decode_image(const char *filename, int flags, IpcvDecodedImage *image)
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

extern "C" IPCV_CORE_API int ipcv_decode_image_stack(const char *filename, int flags, IpcvDecodedImageStack *stack)
{
    if (stack == NULL)
    {
        return -1;
    }

    std::memset(stack, 0, sizeof(*stack));
    if (filename == NULL || filename[0] == 0)
    {
        std::strncpy(stack->error, "empty filename", sizeof(stack->error) - 1);
        return -1;
    }

    try
    {
        cv::setNumThreads(1);
        cv::setUseOptimized(false);

        std::vector<cv::Mat> pages;
        if (!cv::imreadmulti(filename, pages, flags) || pages.empty())
        {
            std::strncpy(stack->error, "OpenCV could not read multipage image", sizeof(stack->error) - 1);
            return -1;
        }

        const int rows = pages[0].rows;
        const int cols = pages[0].cols;
        const int channels = pages[0].channels();
        const int sourceDepth = pages[0].depth();
        const int targetDepth = ipcv_depth_from_mat_depth(sourceDepth);
        const int pageCount = static_cast<int>(pages.size());
        const size_t elemBytes = depth_size(targetDepth);
        if (elemBytes == 0)
        {
            std::strncpy(stack->error, "unsupported multipage image depth", sizeof(stack->error) - 1);
            return -1;
        }
        if (channels != 1 && channels != 3)
        {
            std::strncpy(stack->error, "multipage image must be grayscale or RGB", sizeof(stack->error) - 1);
            return -1;
        }

        stack->rows = rows;
        stack->cols = cols;
        stack->channels = channels;
        stack->pages = pageCount;
        stack->depth = targetDepth;
        stack->byte_count = static_cast<size_t>(rows) * cols * channels * pageCount * elemBytes;
        stack->data = static_cast<unsigned char*>(std::malloc(stack->byte_count));
        if (stack->data == NULL)
        {
            std::strncpy(stack->error, "out of memory", sizeof(stack->error) - 1);
            return -1;
        }

        for (int i = 0; i < pageCount; i++)
        {
            if (!validate_stack_page(pages[i], rows, cols, channels, sourceDepth))
            {
                ipcv_free_decoded_image_stack(stack);
                std::strncpy(stack->error, "all multipage image pages must have the same size, channels, and depth", sizeof(stack->error) - 1);
                return -1;
            }
            if (!copy_page_to_stack_layout(pages[i], i, rows, cols, channels, targetDepth, stack->data))
            {
                ipcv_free_decoded_image_stack(stack);
                std::strncpy(stack->error, "could not convert multipage image data", sizeof(stack->error) - 1);
                return -1;
            }
        }

        return 0;
    }
    catch (const cv::Exception& e)
    {
        std::strncpy(stack->error, e.what(), sizeof(stack->error) - 1);
        stack->error[sizeof(stack->error) - 1] = 0;
        return -1;
    }
    catch (const std::exception& e)
    {
        std::strncpy(stack->error, e.what(), sizeof(stack->error) - 1);
        stack->error[sizeof(stack->error) - 1] = 0;
        return -1;
    }
    catch (...)
    {
        std::strncpy(stack->error, "unknown multipage decoder failure", sizeof(stack->error) - 1);
        return -1;
    }
}

extern "C" IPCV_CORE_API void ipcv_free_decoded_image(IpcvDecodedImage *image)
{
    if (image == NULL)
    {
        return;
    }

    std::free(image->data);
    image->data = NULL;
    image->byte_count = 0;
}

extern "C" IPCV_CORE_API void ipcv_free_decoded_image_stack(IpcvDecodedImageStack *stack)
{
    if (stack == NULL)
    {
        return;
    }

    std::free(stack->data);
    stack->data = NULL;
    stack->byte_count = 0;
}
