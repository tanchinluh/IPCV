#define IPCV_CORE_EXPORTS
#include "ipcv_image_transform.h"

#include <cmath>
#include <opencv2/core.hpp>
#include <opencv2/imgproc.hpp>
#include <cstdlib>
#include <cstring>
#include <exception>

namespace
{
void set_error(IpcvRadonResult *result, const char *message)
{
    if (result == NULL)
    {
        return;
    }

    std::strncpy(result->error, message, sizeof(result->error) - 1);
    result->error[sizeof(result->error) - 1] = 0;
}

void set_image_error(IpcvDecodedImage *image, const char *message)
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

void increment_radon(double *projection, int projection_size, double pixel, double radius)
{
    const int radiusIndex = static_cast<int>(radius);
    const double delta = radius - radiusIndex;

    if (radiusIndex < 0 || radiusIndex + 1 >= projection_size)
    {
        return;
    }

    projection[radiusIndex] += pixel * (1.0 - delta);
    projection[radiusIndex + 1] += pixel * delta;
}

void calculate_radon(double *projection, const double *image, const double *theta_radians, int rows, int cols, int x_origin, int y_origin, int angle_count, int first_radius, int radius_count)
{
    double *x_cos_table = static_cast<double*>(std::calloc(static_cast<size_t>(2 * cols), sizeof(double)));
    double *y_sin_table = static_cast<double*>(std::calloc(static_cast<size_t>(2 * rows), sizeof(double)));
    if (x_cos_table == NULL || y_sin_table == NULL)
    {
        std::free(x_cos_table);
        std::free(y_sin_table);
        return;
    }

    for (int angleIndex = 0; angleIndex < angle_count; angleIndex++)
    {
        const double angle = theta_radians[angleIndex];
        const double cosine = std::cos(angle);
        const double sine = std::sin(angle);
        double *current_projection = projection + static_cast<size_t>(angleIndex) * radius_count;

        for (int col = 0; col < cols; col++)
        {
            const double x = col - x_origin;
            x_cos_table[2 * col] = (x - 0.25) * cosine;
            x_cos_table[2 * col + 1] = (x + 0.25) * cosine;
        }

        for (int row = 0; row < rows; row++)
        {
            const double y = y_origin - row;
            y_sin_table[2 * row] = (y - 0.25) * sine;
            y_sin_table[2 * row + 1] = (y + 0.25) * sine;
        }

        const double *pixel_ptr = image;
        for (int col = 0; col < cols; col++)
        {
            for (int row = 0; row < rows; row++)
            {
                double pixel = *(pixel_ptr++);
                if (pixel == 0.0)
                {
                    continue;
                }

                pixel *= 0.25;
                increment_radon(current_projection, radius_count, pixel, x_cos_table[2 * col] + y_sin_table[2 * row] - first_radius);
                increment_radon(current_projection, radius_count, pixel, x_cos_table[2 * col + 1] + y_sin_table[2 * row] - first_radius);
                increment_radon(current_projection, radius_count, pixel, x_cos_table[2 * col] + y_sin_table[2 * row + 1] - first_radius);
                increment_radon(current_projection, radius_count, pixel, x_cos_table[2 * col + 1] + y_sin_table[2 * row + 1] - first_radius);
            }
        }
    }

    std::free(x_cos_table);
    std::free(y_sin_table);
}
}

extern "C" IPCV_CORE_API int ipcv_radon_transform(const double *image, int rows, int cols, const double *theta_degrees, int theta_count, IpcvRadonResult *result)
{
    if (result == NULL)
    {
        return -1;
    }

    std::memset(result, 0, sizeof(*result));
    if (image == NULL || theta_degrees == NULL)
    {
        set_error(result, "missing Radon transform input");
        return -1;
    }
    if (rows <= 0 || cols <= 0 || theta_count <= 0)
    {
        set_error(result, "Radon transform dimensions must be positive");
        return -1;
    }

    try
    {
        const double deg_to_rad = 3.14159265358979 / 180.0;
        double *theta_radians = static_cast<double*>(std::calloc(static_cast<size_t>(theta_count), sizeof(double)));
        if (theta_radians == NULL)
        {
            set_error(result, "out of memory");
            return -1;
        }

        for (int i = 0; i < theta_count; i++)
        {
            theta_radians[i] = theta_degrees[i] * deg_to_rad;
        }

        const int x_origin = (cols - 1) / 2;
        const int y_origin = (rows - 1) / 2;
        const int row_limit = rows - 1 - y_origin;
        const int col_limit = cols - 1 - x_origin;
        const int last_radius = static_cast<int>(std::ceil(std::sqrt(static_cast<double>(row_limit * row_limit + col_limit * col_limit)))) + 1;
        const int first_radius = -last_radius;
        const int radius_count = last_radius - first_radius + 1;

        result->projection = static_cast<double*>(std::calloc(static_cast<size_t>(radius_count) * theta_count, sizeof(double)));
        result->radius = static_cast<double*>(std::calloc(static_cast<size_t>(radius_count), sizeof(double)));
        if (result->projection == NULL || result->radius == NULL)
        {
            std::free(theta_radians);
            ipcv_free_radon_result(result);
            set_error(result, "out of memory");
            return -1;
        }

        calculate_radon(result->projection, image, theta_radians, rows, cols, x_origin, y_origin, theta_count, first_radius, radius_count);
        for (int radius = first_radius; radius <= last_radius; radius++)
        {
            result->radius[radius - first_radius] = static_cast<double>(radius);
        }

        result->projection_rows = radius_count;
        result->projection_cols = theta_count;
        result->radius_count = radius_count;
        std::free(theta_radians);
        return 0;
    }
    catch (const std::exception& e)
    {
        ipcv_free_radon_result(result);
        set_error(result, e.what());
        return -1;
    }
    catch (...)
    {
        ipcv_free_radon_result(result);
        set_error(result, "unknown Radon transform failure");
        return -1;
    }
}

extern "C" IPCV_CORE_API int ipcv_log_polar(const IpcvDecodedImage *source, double magnitude_scale, IpcvDecodedImage *output)
{
    if (output == NULL)
    {
        return -1;
    }

    std::memset(output, 0, sizeof(*output));
    if (source == NULL)
    {
        set_image_error(output, "missing log-polar image input");
        return -1;
    }
    if (magnitude_scale <= 0)
    {
        set_image_error(output, "log-polar magnitude scale must be positive");
        return -1;
    }

    try
    {
        cv::Mat source_mat;
        char error[256] = {0};
        if (!image_to_mat(*source, source_mat, error))
        {
            set_image_error(output, error);
            return -1;
        }

        cv::Mat result;
        cv::Point2f center(source_mat.cols / 2.0f, source_mat.rows / 2.0f);
        const double max_radius = std::exp(static_cast<double>(source_mat.cols) / magnitude_scale);
        cv::warpPolar(source_mat, result, source_mat.size(), center, max_radius, cv::INTER_LINEAR | cv::WARP_POLAR_LOG);
        if (!mat_to_image(result, output))
        {
            return -1;
        }

        return 0;
    }
    catch (const cv::Exception& e)
    {
        ipcv_free_decoded_image(output);
        set_image_error(output, e.what());
        return -1;
    }
    catch (const std::exception& e)
    {
        ipcv_free_decoded_image(output);
        set_image_error(output, e.what());
        return -1;
    }
    catch (...)
    {
        ipcv_free_decoded_image(output);
        set_image_error(output, "unknown log-polar transform failure");
        return -1;
    }
}

extern "C" IPCV_CORE_API void ipcv_free_radon_result(IpcvRadonResult *result)
{
    if (result == NULL)
    {
        return;
    }

    std::free(result->projection);
    std::free(result->radius);
    result->projection = NULL;
    result->radius = NULL;
    result->projection_rows = 0;
    result->projection_cols = 0;
    result->radius_count = 0;
}
