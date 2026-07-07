#define IPCV_CORE_EXPORTS
#include "ipcv_hough.h"

#include <opencv2/core.hpp>
#include <opencv2/imgproc.hpp>

#include <cmath>
#include <cstdlib>
#include <cstring>
#include <exception>
#include <vector>

namespace
{
void set_image_error(IpcvDecodedImage *image, const char *message)
{
    if (image == NULL)
    {
        return;
    }
    std::strncpy(image->error, message, sizeof(image->error) - 1);
    image->error[sizeof(image->error) - 1] = 0;
}

void set_circle_error(IpcvCircleMatrix *circles, const char *message)
{
    if (circles == NULL)
    {
        return;
    }
    std::strncpy(circles->error, message, sizeof(circles->error) - 1);
    circles->error[sizeof(circles->error) - 1] = 0;
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

void copy_mat_to_scilab_layout(const cv::Mat& source, unsigned char *destination)
{
    const int rows = source.rows;
    const int cols = source.cols;
    const int channels = source.channels();
    const size_t elem_bytes = source.elemSize1();

    for (int ch = 0; ch < channels; ch++)
    {
        int src_ch = ch;
        if ((channels == 3 || channels == 4) && ch < 3)
        {
            src_ch = 2 - ch;
        }

        for (int col = 0; col < cols; col++)
        {
            for (int row = 0; row < rows; row++)
            {
                const unsigned char *src = source.ptr<unsigned char>(row) + ((col * channels + src_ch) * elem_bytes);
                const size_t dst_offset = (static_cast<size_t>(ch) * rows * cols + static_cast<size_t>(col) * rows + row) * elem_bytes;
                std::memcpy(destination + dst_offset, src, elem_bytes);
            }
        }
    }
}

bool image_to_mat(const IpcvDecodedImage& image, cv::Mat& mat, char *error)
{
    const size_t elem_bytes = depth_size(image.depth);
    const size_t expected_bytes = static_cast<size_t>(image.rows) * image.cols * image.channels * elem_bytes;
    if (image.data == NULL || image.rows <= 0 || image.cols <= 0 || image.channels <= 0 || elem_bytes == 0 || image.byte_count != expected_bytes)
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

bool image_to_gray_8u(const IpcvDecodedImage& source, cv::Mat& gray, char *error)
{
    cv::Mat image;
    if (!image_to_mat(source, image, error))
    {
        return false;
    }

    if (image.channels() == 1)
    {
        gray = image;
    }
    else if (image.channels() == 3)
    {
        cv::cvtColor(image, gray, cv::COLOR_BGR2GRAY);
    }
    else if (image.channels() == 4)
    {
        cv::cvtColor(image, gray, cv::COLOR_BGRA2GRAY);
    }
    else
    {
        std::strcpy(error, "Hough transform requires a one-, three-, or four-channel image");
        return false;
    }

    if (gray.depth() != CV_8U)
    {
        cv::Mat converted;
        gray.convertTo(converted, CV_8U);
        gray = converted;
    }

    return true;
}

bool mat_to_image(const cv::Mat& image, IpcvDecodedImage *output)
{
    if (output == NULL || image.empty())
    {
        return false;
    }

    std::memset(output, 0, sizeof(*output));
    output->rows = image.rows;
    output->cols = image.cols;
    output->channels = image.channels();
    output->depth = image.depth();
    const size_t elem_bytes = image.elemSize1();
    output->byte_count = static_cast<size_t>(output->rows) * output->cols * output->channels * elem_bytes;
    output->data = static_cast<unsigned char*>(std::calloc(output->byte_count == 0 ? 1 : output->byte_count, 1));
    if (output->data == NULL)
    {
        set_image_error(output, "out of memory");
        return false;
    }

    copy_mat_to_scilab_layout(image, output->data);
    return true;
}
}

extern "C" IPCV_CORE_API int ipcv_hough_lines_overlay(const IpcvDecodedImage *source, IpcvDecodedImage *output)
{
    if (output == NULL)
    {
        return -1;
    }

    std::memset(output, 0, sizeof(*output));
    if (source == NULL)
    {
        set_image_error(output, "missing Hough image input");
        return -1;
    }

    try
    {
        cv::Mat gray;
        char error[256] = {0};
        if (!image_to_gray_8u(*source, gray, error))
        {
            set_image_error(output, error);
            return -1;
        }

        cv::Mat overlay;
        cv::cvtColor(gray, overlay, cv::COLOR_GRAY2BGR);

        std::vector<cv::Vec2f> lines;
        cv::HoughLines(gray, lines, 1, CV_PI / 180, 10, 0, 0);
        for (size_t i = 0; i < lines.size(); i++)
        {
            const float rho = lines[i][0];
            const float theta = lines[i][1];
            const double a = std::cos(theta);
            const double b = std::sin(theta);
            const double x0 = a * rho;
            const double y0 = b * rho;
            cv::Point pt1;
            cv::Point pt2;
            pt1.x = cvRound(x0 + 1000 * (-b));
            pt1.y = cvRound(y0 + 1000 * a);
            pt2.x = cvRound(x0 - 1000 * (-b));
            pt2.y = cvRound(y0 - 1000 * a);
            cv::line(overlay, pt1, pt2, cv::Scalar(0, 0, 255), 3, cv::LINE_AA);
        }

        if (!mat_to_image(overlay, output))
        {
            return -1;
        }
        return 0;
    }
    catch (const cv::Exception& e)
    {
        set_image_error(output, e.what());
        return -1;
    }
    catch (const std::exception& e)
    {
        set_image_error(output, e.what());
        return -1;
    }
    catch (...)
    {
        set_image_error(output, "unknown Hough line failure");
        return -1;
    }
}

extern "C" IPCV_CORE_API int ipcv_hough_circles(const IpcvDecodedImage *source, IpcvCircleMatrix *circles)
{
    if (circles == NULL)
    {
        return -1;
    }

    std::memset(circles, 0, sizeof(*circles));
    if (source == NULL)
    {
        set_circle_error(circles, "missing Hough circle image input");
        return -1;
    }

    try
    {
        cv::Mat gray;
        char error[256] = {0};
        if (!image_to_gray_8u(*source, gray, error))
        {
            set_circle_error(circles, error);
            return -1;
        }

        cv::GaussianBlur(gray, gray, cv::Size(9, 9), 2, 2);
        std::vector<cv::Vec3f> found;
        cv::HoughCircles(gray, found, cv::HOUGH_GRADIENT, 1.2, 100);

        circles->rows = 3;
        circles->cols = static_cast<int>(found.size());
        const size_t count = static_cast<size_t>(circles->rows) * circles->cols;
        circles->data = static_cast<double*>(std::calloc(count == 0 ? 1 : count, sizeof(double)));
        if (circles->data == NULL)
        {
            set_circle_error(circles, "out of memory");
            return -1;
        }

        for (int col = 0; col < circles->cols; col++)
        {
            circles->data[circles->rows * col] = found[col][0];
            circles->data[circles->rows * col + 1] = found[col][1];
            circles->data[circles->rows * col + 2] = found[col][2];
        }

        return 0;
    }
    catch (const cv::Exception& e)
    {
        set_circle_error(circles, e.what());
        return -1;
    }
    catch (const std::exception& e)
    {
        set_circle_error(circles, e.what());
        return -1;
    }
    catch (...)
    {
        set_circle_error(circles, "unknown Hough circle failure");
        return -1;
    }
}

extern "C" IPCV_CORE_API void ipcv_free_circle_matrix(IpcvCircleMatrix *circles)
{
    if (circles == NULL)
    {
        return;
    }

    std::free(circles->data);
    std::memset(circles, 0, sizeof(*circles));
}
