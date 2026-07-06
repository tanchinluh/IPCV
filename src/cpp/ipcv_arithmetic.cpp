#define IPCV_CORE_EXPORTS
#include "ipcv_arithmetic.h"

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

bool is_binary_mask(const cv::Mat& image)
{
    if (image.depth() != CV_8U || image.channels() != 1)
    {
        return false;
    }

    for (int row = 0; row < image.rows; row++)
    {
        const unsigned char *p = image.ptr<unsigned char>(row);
        for (int col = 0; col < image.cols; col++)
        {
            if (p[col] != 0 && p[col] != 255)
            {
                return false;
            }
        }
    }
    return true;
}

double scalar_value(const IpcvDecodedImage& image)
{
    if (image.data == NULL || image.rows != 1 || image.cols != 1 || image.channels != 1)
    {
        return 0.0;
    }

    switch (image.depth)
    {
    case IPCV_DEPTH_8U:
        return *reinterpret_cast<const unsigned char*>(image.data);
    case IPCV_DEPTH_8S:
        return *reinterpret_cast<const signed char*>(image.data);
    case IPCV_DEPTH_16U:
        return *reinterpret_cast<const unsigned short*>(image.data);
    case IPCV_DEPTH_16S:
        return *reinterpret_cast<const short*>(image.data);
    case IPCV_DEPTH_32S:
        return *reinterpret_cast<const int*>(image.data);
    case IPCV_DEPTH_32F:
        return *reinterpret_cast<const float*>(image.data);
    case IPCV_DEPTH_64F:
        return *reinterpret_cast<const double*>(image.data);
    default:
        return 0.0;
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

extern "C" IPCV_CORE_API int ipcv_binary_arithmetic(const IpcvDecodedImage *left, const IpcvDecodedImage *right, int operation, IpcvDecodedImage *output)
{
    if (output == NULL)
    {
        return -1;
    }

    std::memset(output, 0, sizeof(*output));
    if (left == NULL || right == NULL)
    {
        set_error(output, "missing image input");
        return -1;
    }

    try
    {
        cv::setNumThreads(1);
        cv::setUseOptimized(false);

        cv::Mat leftMat;
        cv::Mat rightMat;
        char error[256] = {0};
        if (!image_to_mat(*left, leftMat, error))
        {
            set_error(output, error);
            return -1;
        }
        if (!image_to_mat(*right, rightMat, error))
        {
            set_error(output, error);
            return -1;
        }

        cv::Mat result;
        const bool rightIsScalar = right->rows == 1 && right->cols == 1 && right->channels == 1;
        if (rightIsScalar)
        {
            const cv::Scalar scalar = cv::Scalar::all(scalar_value(*right));
            switch (operation)
            {
            case IPCV_ARITH_ADD:
                cv::add(leftMat, scalar, result);
                break;
            case IPCV_ARITH_SUBTRACT:
                cv::subtract(leftMat, scalar, result);
                break;
            case IPCV_ARITH_MULTIPLY:
                cv::multiply(leftMat, scalar, result);
                break;
            case IPCV_ARITH_DIVIDE:
                cv::divide(leftMat, scalar, result);
                break;
            case IPCV_ARITH_ABSDIFF:
                cv::absdiff(leftMat, scalar, result);
                break;
            default:
                set_error(output, "unsupported arithmetic operation");
                return -1;
            }
        }
        else
        {
            if (leftMat.rows != rightMat.rows || leftMat.cols != rightMat.cols)
            {
                set_error(output, "The two input images do not have same image size.");
                return -1;
            }

            if ((operation == IPCV_ARITH_MULTIPLY || operation == IPCV_ARITH_DIVIDE) && is_binary_mask(rightMat))
            {
                cv::Mat mask;
                rightMat.convertTo(mask, leftMat.depth(), 1.0 / 255.0);
                if (leftMat.channels() == 3)
                {
                    cv::cvtColor(mask, mask, cv::COLOR_GRAY2BGR);
                }
                else if (leftMat.channels() == 4)
                {
                    cv::cvtColor(mask, mask, cv::COLOR_GRAY2BGRA);
                }
                if (operation == IPCV_ARITH_MULTIPLY)
                {
                    cv::multiply(leftMat, mask, result);
                }
                else
                {
                    cv::divide(leftMat, mask, result);
                }
            }
            else
            {
                if (leftMat.channels() != rightMat.channels())
                {
                    set_error(output, "The two input images do not have same channel number.");
                    return -1;
                }
                if (leftMat.type() != rightMat.type())
                {
                    set_error(output, "The two input images do not have same type.");
                    return -1;
                }

                switch (operation)
                {
                case IPCV_ARITH_ADD:
                    cv::add(leftMat, rightMat, result);
                    break;
                case IPCV_ARITH_SUBTRACT:
                    cv::subtract(leftMat, rightMat, result);
                    break;
                case IPCV_ARITH_MULTIPLY:
                    cv::multiply(leftMat, rightMat, result);
                    break;
                case IPCV_ARITH_DIVIDE:
                    cv::divide(leftMat, rightMat, result);
                    break;
                case IPCV_ARITH_ABSDIFF:
                    cv::absdiff(leftMat, rightMat, result);
                    break;
                default:
                    set_error(output, "unsupported arithmetic operation");
                    return -1;
                }
            }
        }

        if (!mat_to_image(result, output))
        {
            if (output->error[0] == 0)
            {
                set_error(output, "could not convert result image");
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
        set_error(output, "unknown arithmetic failure");
        return -1;
    }
}
