#define IPCV_CORE_EXPORTS
#include "ipcv_morphology.h"

#include <opencv2/core.hpp>
#include <opencv2/imgproc.hpp>
#include <opencv2/ximgproc.hpp>

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

extern "C" IPCV_CORE_API int ipcv_create_structuring_element(int shape, int rows, int cols, IpcvDecodedImage *output)
{
    if (output == NULL)
    {
        return -1;
    }

    std::memset(output, 0, sizeof(*output));
    if (rows <= 0 || cols <= 0)
    {
        set_error(output, "structuring element size must be positive");
        return -1;
    }
    if (shape < cv::MORPH_RECT || shape > cv::MORPH_DIAMOND)
    {
        set_error(output, "unsupported structuring element shape");
        return -1;
    }

    try
    {
        cv::Mat element = cv::getStructuringElement(shape, cv::Size(cols, rows), cv::Point(-1, -1));
        if (!mat_to_image(element, output))
        {
            if (output->error[0] == 0)
            {
                set_error(output, "could not create structuring element");
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
        set_error(output, "unknown morphology element failure");
        return -1;
    }
}

extern "C" IPCV_CORE_API int ipcv_morphology_image(const IpcvDecodedImage *source,
                                                   const IpcvDecodedImage *element,
                                                   int operation,
                                                   int iterations,
                                                   int anchor_row,
                                                   int anchor_col,
                                                   int border_type,
                                                   int use_default_border_value,
                                                   double border_value,
                                                   IpcvDecodedImage *output)
{
    if (output == NULL)
    {
        return -1;
    }

    std::memset(output, 0, sizeof(*output));
    if (source == NULL || element == NULL)
    {
        set_error(output, "missing image or structuring element input");
        return -1;
    }
    if (iterations < 1)
    {
        set_error(output, "iterations must be greater than zero");
        return -1;
    }

    try
    {
        cv::setNumThreads(1);
        cv::setUseOptimized(false);

        cv::Mat sourceMat;
        cv::Mat elementMat;
        cv::Mat result;
        char error[256] = {0};
        if (!image_to_mat(*source, sourceMat, error))
        {
            set_error(output, error);
            return -1;
        }
        if (!image_to_mat(*element, elementMat, error))
        {
            set_error(output, error);
            return -1;
        }
        if (elementMat.channels() != 1)
        {
            set_error(output, "structuring element must be a 2D matrix");
            return -1;
        }

        cv::Point anchor(anchor_col, anchor_row);
        cv::Scalar borderScalar = use_default_border_value ? cv::morphologyDefaultBorderValue() : cv::Scalar::all(border_value);

        if (operation == cv::MORPH_ERODE)
        {
            cv::erode(sourceMat, result, elementMat, anchor, iterations, border_type, borderScalar);
        }
        else if (operation == cv::MORPH_DILATE)
        {
            cv::dilate(sourceMat, result, elementMat, anchor, iterations, border_type, borderScalar);
        }
        else
        {
            cv::morphologyEx(sourceMat, result, operation, elementMat, anchor, iterations, border_type, borderScalar);
        }

        if (!mat_to_image(result, output))
        {
            if (output->error[0] == 0)
            {
                set_error(output, "could not convert morphology result");
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
        set_error(output, "unknown morphology failure");
        return -1;
    }
}

extern "C" IPCV_CORE_API int ipcv_thin_image(const IpcvDecodedImage *source, int thinning_type, IpcvDecodedImage *output)
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
    if (thinning_type != cv::ximgproc::THINNING_ZHANGSUEN && thinning_type != cv::ximgproc::THINNING_GUOHALL)
    {
        set_error(output, "unsupported thinning method");
        return -1;
    }

    try
    {
        cv::setNumThreads(1);
        cv::setUseOptimized(false);

        cv::Mat sourceMat;
        cv::Mat binary;
        cv::Mat result;
        char error[256] = {0};
        if (!image_to_mat(*source, sourceMat, error))
        {
            set_error(output, error);
            return -1;
        }
        if (sourceMat.channels() != 1)
        {
            set_error(output, "thinning expects a single channel image");
            return -1;
        }

        cv::compare(sourceMat, cv::Scalar::all(0), binary, cv::CMP_GT);
        cv::ximgproc::thinning(binary, result, thinning_type);

        if (!mat_to_image(result, output))
        {
            if (output->error[0] == 0)
            {
                set_error(output, "could not convert thinning result");
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
        set_error(output, "unknown thinning failure");
        return -1;
    }
}
