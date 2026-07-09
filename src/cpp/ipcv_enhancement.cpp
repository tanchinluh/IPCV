#define IPCV_CORE_EXPORTS
#include "ipcv_enhancement.h"

#include <opencv2/core.hpp>
#include <opencv2/imgproc.hpp>
#include <opencv2/photo.hpp>

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

bool make_mask_8u(const IpcvDecodedImage& image, cv::Mat& mask, char *error)
{
    cv::Mat maskMat;
    if (!image_to_mat(image, maskMat, error))
    {
        return false;
    }
    if (maskMat.channels() != 1)
    {
        if (error != NULL)
        {
            std::strcpy(error, "mask must be single-channel");
        }
        return false;
    }

    cv::compare(maskMat, cv::Scalar(0), mask, cv::CMP_NE);
    return true;
}
}

extern "C" IPCV_CORE_API int ipcv_dct_image(const IpcvDecodedImage *source, int direction, IpcvDecodedImage *output)
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

        cv::Mat sourceMat;
        cv::Mat source64;
        cv::Mat transformed;
        char error[256] = {0};
        if (!image_to_mat(*source, sourceMat, error))
        {
            set_error(output, error);
            return -1;
        }
        if (sourceMat.channels() != 1)
        {
            set_error(output, "DCT requires a single-channel matrix");
            return -1;
        }

        sourceMat.convertTo(source64, CV_64F);
        cv::dct(source64, transformed, direction == IPCV_DCT_INVERSE ? cv::DCT_INVERSE : 0);
        if (!mat_to_image(transformed, output))
        {
            if (output->error[0] == 0)
            {
                set_error(output, "could not convert DCT result");
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
        set_error(output, "unknown DCT failure");
        return -1;
    }
}

extern "C" IPCV_CORE_API int ipcv_clahe_image(const IpcvDecodedImage *source, double clip_limit, IpcvDecodedImage *output)
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

        cv::Mat sourceMat;
        cv::Mat sourceClahe;
        cv::Mat equalized;
        char error[256] = {0};
        if (!image_to_mat(*source, sourceMat, error))
        {
            set_error(output, error);
            return -1;
        }
        cv::Ptr<cv::CLAHE> clahe = cv::createCLAHE();
        clahe->setClipLimit(clip_limit);
        clahe->setTilesGridSize(cv::Size(8, 8));

        if (sourceMat.channels() == 1)
        {
            if (sourceMat.depth() == CV_8U || sourceMat.depth() == CV_16U)
            {
                sourceClahe = sourceMat;
            }
            else
            {
                sourceMat.convertTo(sourceClahe, CV_8U);
            }
            clahe->apply(sourceClahe, equalized);
        }
        else if (sourceMat.channels() == 3)
        {
            cv::Mat source8u;
            cv::Mat lab;
            std::vector<cv::Mat> labChannels;

            if (sourceMat.depth() == CV_8U)
            {
                source8u = sourceMat;
            }
            else
            {
                sourceMat.convertTo(source8u, CV_8U);
            }

            cv::cvtColor(source8u, lab, cv::COLOR_BGR2Lab);
            cv::split(lab, labChannels);
            clahe->apply(labChannels[0], labChannels[0]);
            cv::merge(labChannels, lab);
            cv::cvtColor(lab, equalized, cv::COLOR_Lab2BGR);
        }
        else
        {
            set_error(output, "adaptive histogram equalization requires a single-channel or RGB image");
            return -1;
        }

        if (!mat_to_image(equalized, output))
        {
            if (output->error[0] == 0)
            {
                set_error(output, "could not convert CLAHE result");
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
        set_error(output, "unknown CLAHE failure");
        return -1;
    }
}

extern "C" IPCV_CORE_API int ipcv_denoise_image(const IpcvDecodedImage *source, double h, double h_color, int template_window_size, int search_window_size, IpcvDecodedImage *output)
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
    if (h <= 0.0 || h_color <= 0.0)
    {
        set_error(output, "denoise strength values must be positive");
        return -1;
    }
    if (template_window_size <= 0 || search_window_size <= 0 || (template_window_size % 2) == 0 || (search_window_size % 2) == 0)
    {
        set_error(output, "denoise window sizes must be positive and odd");
        return -1;
    }

    try
    {
        cv::setNumThreads(1);
        cv::setUseOptimized(false);

        cv::Mat sourceMat;
        cv::Mat denoised;
        char error[256] = {0};
        if (!image_to_mat(*source, sourceMat, error))
        {
            set_error(output, error);
            return -1;
        }
        if (sourceMat.depth() != CV_8U)
        {
            set_error(output, "denoise currently supports uint8 images");
            return -1;
        }
        if (sourceMat.channels() == 1)
        {
            cv::fastNlMeansDenoising(sourceMat, denoised, static_cast<float>(h), template_window_size, search_window_size);
        }
        else if (sourceMat.channels() == 3)
        {
            cv::fastNlMeansDenoisingColored(sourceMat, denoised, static_cast<float>(h), static_cast<float>(h_color), template_window_size, search_window_size);
        }
        else
        {
            set_error(output, "denoise supports single-channel or RGB images");
            return -1;
        }

        if (!mat_to_image(denoised, output))
        {
            if (output->error[0] == 0)
            {
                set_error(output, "could not convert denoise result");
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
        set_error(output, "unknown denoise failure");
        return -1;
    }
}

extern "C" IPCV_CORE_API int ipcv_inpaint_image(const IpcvDecodedImage *source, const IpcvDecodedImage *mask, double radius, int method, IpcvDecodedImage *output)
{
    if (output == NULL)
    {
        return -1;
    }

    std::memset(output, 0, sizeof(*output));
    if (source == NULL || mask == NULL)
    {
        set_error(output, "missing image or mask input");
        return -1;
    }
    if (method != cv::INPAINT_NS && method != cv::INPAINT_TELEA)
    {
        set_error(output, "inpaint method must be 0 or 1");
        return -1;
    }

    try
    {
        cv::setNumThreads(1);
        cv::setUseOptimized(false);

        cv::Mat sourceMat;
        cv::Mat source8u;
        cv::Mat mask8u;
        cv::Mat restored;
        char error[256] = {0};
        if (!image_to_mat(*source, sourceMat, error))
        {
            set_error(output, error);
            return -1;
        }
        if (!make_mask_8u(*mask, mask8u, error))
        {
            set_error(output, error);
            return -1;
        }
        if (sourceMat.rows != mask8u.rows || sourceMat.cols != mask8u.cols)
        {
            set_error(output, "mask size must match source image size");
            return -1;
        }
        if (sourceMat.depth() == CV_8U)
        {
            source8u = sourceMat;
        }
        else
        {
            sourceMat.convertTo(source8u, CV_8U);
        }

        cv::inpaint(source8u, mask8u, restored, radius, method);
        if (!mat_to_image(restored, output))
        {
            if (output->error[0] == 0)
            {
                set_error(output, "could not convert inpaint result");
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
        set_error(output, "unknown inpaint failure");
        return -1;
    }
}
