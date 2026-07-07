#define IPCV_CORE_EXPORTS
#include "ipcv_spatial_transform.h"

#include <opencv2/core.hpp>
#include <opencv2/geometry.hpp>
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

int to_opencv_interpolation(int interpolation)
{
    switch (interpolation)
    {
    case IPCV_INTER_NEAREST:
        return cv::INTER_NEAREST;
    case IPCV_INTER_LINEAR:
        return cv::INTER_LINEAR;
    case IPCV_INTER_CUBIC:
        return cv::INTER_CUBIC;
    case IPCV_INTER_AREA:
        return cv::INTER_AREA;
    case IPCV_INTER_LANCZOS:
        return cv::INTER_LANCZOS4;
    default:
        return -1;
    }
}
}

extern "C" IPCV_CORE_API int ipcv_resize_image(const IpcvDecodedImage *source, int target_rows, int target_cols, int interpolation, IpcvDecodedImage *output)
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
    if (target_rows <= 0 || target_cols <= 0)
    {
        set_error(output, "target image size must be positive");
        return -1;
    }

    const int cvInterpolation = to_opencv_interpolation(interpolation);
    if (cvInterpolation < 0)
    {
        set_error(output, "unsupported interpolation method");
        return -1;
    }

    try
    {
        cv::setNumThreads(1);
        cv::setUseOptimized(false);

        cv::Mat sourceMat;
        cv::Mat resized;
        char error[256] = {0};
        if (!image_to_mat(*source, sourceMat, error))
        {
            set_error(output, error);
            return -1;
        }

        cv::resize(sourceMat, resized, cv::Size(target_cols, target_rows), 0, 0, cvInterpolation);
        if (!mat_to_image(resized, output))
        {
            if (output->error[0] == 0)
            {
                set_error(output, "could not convert resized image");
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
        set_error(output, "unknown resize failure");
        return -1;
    }
}

extern "C" IPCV_CORE_API int ipcv_pyramid_image(const IpcvDecodedImage *source, int direction, IpcvDecodedImage *output)
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
        cv::Mat transformed;
        char error[256] = {0};
        if (!image_to_mat(*source, sourceMat, error))
        {
            set_error(output, error);
            return -1;
        }

        if (direction == IPCV_PYRAMID_REDUCE)
        {
            cv::pyrDown(sourceMat, transformed);
        }
        else if (direction == IPCV_PYRAMID_EXPAND)
        {
            cv::pyrUp(sourceMat, transformed);
        }
        else
        {
            set_error(output, "unsupported pyramid direction");
            return -1;
        }

        if (!mat_to_image(transformed, output))
        {
            if (output->error[0] == 0)
            {
                set_error(output, "could not convert pyramid image");
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
        set_error(output, "unknown pyramid failure");
        return -1;
    }
}

extern "C" IPCV_CORE_API int ipcv_affine_transform_image(const IpcvDecodedImage *source, const IpcvDecodedImage *matrix, int target_rows, int target_cols, IpcvDecodedImage *output)
{
    if (output == NULL)
    {
        return -1;
    }

    std::memset(output, 0, sizeof(*output));
    if (source == NULL || matrix == NULL)
    {
        set_error(output, "missing image or affine matrix input");
        return -1;
    }
    if (target_rows <= 0 || target_cols <= 0)
    {
        set_error(output, "target image size must be positive");
        return -1;
    }

    try
    {
        cv::setNumThreads(1);
        cv::setUseOptimized(false);

        cv::Mat sourceMat;
        cv::Mat matrixMat;
        cv::Mat transformed;
        char error[256] = {0};
        if (!image_to_mat(*source, sourceMat, error))
        {
            set_error(output, error);
            return -1;
        }
        if (!image_to_mat(*matrix, matrixMat, error))
        {
            set_error(output, error);
            return -1;
        }
        if (matrixMat.channels() != 1)
        {
            set_error(output, "affine matrix must be single-channel");
            return -1;
        }
        if (matrixMat.rows == 3 && matrixMat.cols == 2)
        {
            matrixMat = matrixMat.t();
        }
        if (matrixMat.rows != 2 || matrixMat.cols != 3)
        {
            set_error(output, "affine matrix must be 2x3");
            return -1;
        }
        if (matrixMat.depth() != CV_64F)
        {
            matrixMat.convertTo(matrixMat, CV_64F);
        }

        cv::warpAffine(sourceMat, transformed, matrixMat, cv::Size(target_cols, target_rows));
        if (!mat_to_image(transformed, output))
        {
            if (output->error[0] == 0)
            {
                set_error(output, "could not convert affine transform image");
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
        set_error(output, "unknown affine transform failure");
        return -1;
    }
}

extern "C" IPCV_CORE_API int ipcv_perspective_transform_image(const IpcvDecodedImage *source, const IpcvDecodedImage *matrix, int target_rows, int target_cols, IpcvDecodedImage *output)
{
    if (output == NULL)
    {
        return -1;
    }

    std::memset(output, 0, sizeof(*output));
    if (source == NULL || matrix == NULL)
    {
        set_error(output, "missing image or perspective matrix input");
        return -1;
    }
    if (target_rows <= 0 || target_cols <= 0)
    {
        set_error(output, "target image size must be positive");
        return -1;
    }

    try
    {
        cv::setNumThreads(1);
        cv::setUseOptimized(false);

        cv::Mat sourceMat;
        cv::Mat matrixMat;
        cv::Mat transformed;
        char error[256] = {0};
        if (!image_to_mat(*source, sourceMat, error))
        {
            set_error(output, error);
            return -1;
        }
        if (!image_to_mat(*matrix, matrixMat, error))
        {
            set_error(output, error);
            return -1;
        }
        if (matrixMat.channels() != 1 || matrixMat.rows != 3 || matrixMat.cols != 3)
        {
            set_error(output, "perspective matrix must be 3x3");
            return -1;
        }
        matrixMat = matrixMat.t();
        if (matrixMat.depth() != CV_64F)
        {
            matrixMat.convertTo(matrixMat, CV_64F);
        }

        cv::warpPerspective(sourceMat, transformed, matrixMat, cv::Size(target_cols, target_rows));
        if (!mat_to_image(transformed, output))
        {
            if (output->error[0] == 0)
            {
                set_error(output, "could not convert perspective transform image");
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
        set_error(output, "unknown perspective transform failure");
        return -1;
    }
}

extern "C" IPCV_CORE_API int ipcv_rotate_image(const IpcvDecodedImage *source, double angle, int crop, IpcvDecodedImage *output)
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
        cv::Mat rotation;
        cv::Mat rotated;
        char error[256] = {0};
        if (!image_to_mat(*source, sourceMat, error))
        {
            set_error(output, error);
            return -1;
        }

        const cv::Point2f center(sourceMat.cols / 2.0f, sourceMat.rows / 2.0f);
        rotation = cv::getRotationMatrix2D(center, angle, 1.0);
        if (crop == 1)
        {
            cv::warpAffine(sourceMat, rotated, rotation, sourceMat.size());
        }
        else
        {
            const cv::Rect bbox = cv::RotatedRect(center, sourceMat.size(), static_cast<float>(angle)).boundingRect();
            rotation.at<double>(0, 2) += bbox.width / 2.0 - center.x;
            rotation.at<double>(1, 2) += bbox.height / 2.0 - center.y;
            cv::warpAffine(sourceMat, rotated, rotation, bbox.size());
        }

        if (!mat_to_image(rotated, output))
        {
            if (output->error[0] == 0)
            {
                set_error(output, "could not convert rotated image");
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
        set_error(output, "unknown rotate failure");
        return -1;
    }
}

extern "C" IPCV_CORE_API int ipcv_get_affine_transform_matrix(const IpcvDecodedImage *source_points, const IpcvDecodedImage *target_points, IpcvDecodedImage *output)
{
    if (output == NULL)
    {
        return -1;
    }

    std::memset(output, 0, sizeof(*output));
    if (source_points == NULL || target_points == NULL)
    {
        set_error(output, "missing source or target points");
        return -1;
    }

    try
    {
        cv::Mat sourceMat;
        cv::Mat targetMat;
        char error[256] = {0};
        if (!image_to_mat(*source_points, sourceMat, error))
        {
            set_error(output, error);
            return -1;
        }
        if (!image_to_mat(*target_points, targetMat, error))
        {
            set_error(output, error);
            return -1;
        }
        if (sourceMat.channels() != 1 || targetMat.channels() != 1 || sourceMat.rows != 3 || targetMat.rows != 3 || sourceMat.cols != 2 || targetMat.cols != 2)
        {
            set_error(output, "affine transform points must be 3x2 matrices");
            return -1;
        }
        if (sourceMat.depth() != CV_64F)
        {
            sourceMat.convertTo(sourceMat, CV_64F);
        }
        if (targetMat.depth() != CV_64F)
        {
            targetMat.convertTo(targetMat, CV_64F);
        }

        cv::Point2f sourceTri[3];
        cv::Point2f targetTri[3];
        for (int i = 0; i < 3; i++)
        {
            sourceTri[i] = cv::Point2f(static_cast<float>(sourceMat.at<double>(i, 0)), static_cast<float>(sourceMat.at<double>(i, 1)));
            targetTri[i] = cv::Point2f(static_cast<float>(targetMat.at<double>(i, 0)), static_cast<float>(targetMat.at<double>(i, 1)));
        }

        cv::Mat matrix = cv::getAffineTransform(sourceTri, targetTri);
        if (!mat_to_image(matrix, output))
        {
            if (output->error[0] == 0)
            {
                set_error(output, "could not convert affine transform matrix");
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
        set_error(output, "unknown affine matrix failure");
        return -1;
    }
}

extern "C" IPCV_CORE_API int ipcv_get_perspective_transform_matrix(const IpcvDecodedImage *source_points, const IpcvDecodedImage *target_points, IpcvDecodedImage *output)
{
    if (output == NULL)
    {
        return -1;
    }

    std::memset(output, 0, sizeof(*output));
    if (source_points == NULL || target_points == NULL)
    {
        set_error(output, "missing source or target points");
        return -1;
    }

    try
    {
        cv::Mat sourceMat;
        cv::Mat targetMat;
        char error[256] = {0};
        if (!image_to_mat(*source_points, sourceMat, error))
        {
            set_error(output, error);
            return -1;
        }
        if (!image_to_mat(*target_points, targetMat, error))
        {
            set_error(output, error);
            return -1;
        }
        if (sourceMat.channels() != 1 || targetMat.channels() != 1 || sourceMat.rows != 4 || targetMat.rows != 4 || sourceMat.cols != 2 || targetMat.cols != 2)
        {
            set_error(output, "perspective transform points must be 4x2 matrices");
            return -1;
        }
        if (sourceMat.depth() != CV_64F)
        {
            sourceMat.convertTo(sourceMat, CV_64F);
        }
        if (targetMat.depth() != CV_64F)
        {
            targetMat.convertTo(targetMat, CV_64F);
        }

        cv::Point2f sourceQuad[4];
        cv::Point2f targetQuad[4];
        for (int i = 0; i < 4; i++)
        {
            sourceQuad[i] = cv::Point2f(static_cast<float>(sourceMat.at<double>(i, 0)), static_cast<float>(sourceMat.at<double>(i, 1)));
            targetQuad[i] = cv::Point2f(static_cast<float>(targetMat.at<double>(i, 0)), static_cast<float>(targetMat.at<double>(i, 1)));
        }

        cv::Mat matrix = cv::getPerspectiveTransform(sourceQuad, targetQuad);
        if (!mat_to_image(matrix, output))
        {
            if (output->error[0] == 0)
            {
                set_error(output, "could not convert perspective transform matrix");
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
        set_error(output, "unknown perspective matrix failure");
        return -1;
    }
}
