#define IPCV_CORE_EXPORTS
#include "ipcv_superres.h"

#include <opencv2/core.hpp>
#include <opencv2/features.hpp>
#include <opencv2/imgproc.hpp>
#include <opencv2/video/tracking.hpp>

#include <algorithm>
#include <cmath>
#include <cstdlib>
#include <cstring>
#include <exception>
#include <vector>

namespace
{
enum
{
    SR_DATA_L1 = 0,
    SR_DATA_L2
};

#define sign_float(a,b) ((a > b) ? 1.0f : ((a < b) ? -1.0f : 0.0f))

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
        set_error(output, "out of memory");
        return false;
    }

    copy_mat_to_scilab_layout(image, output->data);
    return true;
}

bool image_list_to_mats(const IpcvImageList *images, std::vector<cv::Mat>& mats, char *error)
{
    if (images == NULL || images->count <= 0 || images->images == NULL)
    {
        if (error != NULL)
        {
            std::strcpy(error, "missing super-resolution image list");
        }
        return false;
    }

    mats.clear();
    mats.reserve(images->count);
    for (int i = 0; i < images->count; i++)
    {
        cv::Mat image;
        if (!image_to_mat(images->images[i], image, error))
        {
            return false;
        }
        if (image.channels() == 1)
        {
            cv::cvtColor(image, image, cv::COLOR_GRAY2BGR);
        }
        else if (image.channels() == 4)
        {
            cv::cvtColor(image, image, cv::COLOR_BGRA2BGR);
        }
        else if (image.channels() != 3)
        {
            if (error != NULL)
            {
                std::strcpy(error, "super-resolution requires one-, three-, or four-channel images");
            }
            return false;
        }

        if (image.depth() != CV_8U)
        {
            image.convertTo(image, CV_8U);
        }
        mats.push_back(image);
    }

    return true;
}

void mul_sparse_mat_32f(cv::SparseMat& sparse, cv::Mat& source, cv::Mat& destination, bool is_transpose = false)
{
    destination.setTo(0);
    cv::SparseMatIterator it = sparse.begin();
    cv::SparseMatIterator it_end = sparse.end();
    if (!is_transpose)
    {
        for (; it != it_end; ++it)
        {
            const int source_row = it.node()->idx[0];
            const int dest_row = it.node()->idx[1];
            float *dest = destination.ptr<float>(dest_row);
            float *src = source.ptr<float>(source_row);
            for (int ch = 0; ch < 3; ch++)
            {
                dest[ch] += it.value<float>() * src[ch];
            }
        }
    }
    else
    {
        for (; it != it_end; ++it)
        {
            const int source_row = it.node()->idx[1];
            const int dest_row = it.node()->idx[0];
            float *dest = destination.ptr<float>(dest_row);
            float *src = source.ptr<float>(source_row);
            for (int ch = 0; ch < 3; ch++)
            {
                dest[ch] += it.value<float>() * src[ch];
            }
        }
    }
}

void subtract_sign(cv::Mat& left, cv::Mat& right, cv::Mat& destination)
{
    for (int row = 0; row < left.rows; row++)
    {
        float *l = left.ptr<float>(row);
        float *r = right.ptr<float>(row);
        float *d = destination.ptr<float>(row);
        for (int col = 0; col < left.cols; col++)
        {
            d[3 * col] = sign_float(l[3 * col], r[3 * col]);
            d[3 * col + 1] = sign_float(l[3 * col + 1], r[3 * col + 1]);
            d[3 * col + 2] = sign_float(l[3 * col + 2], r[3 * col + 2]);
        }
    }
}

cv::SparseMat create_downsampled_motion_blur_sparse_mat_32f(cv::Mat& source, int scale_factor, cv::Point2d move)
{
    const float div = 1.0f / static_cast<float>(scale_factor * scale_factor);
    const int x1 = static_cast<int>(move.x + 1);
    const int x0 = static_cast<int>(move.x);
    const float a1 = static_cast<float>(move.x - x0);
    const float a0 = 1.0f - a1;

    const int y1 = static_cast<int>(move.y + 1);
    const int y0 = static_cast<int>(move.y);
    const float b1 = static_cast<float>(move.y - y0);
    const float b0 = 1.0f - b1;

    const int mat_size = source.cols * source.rows;
    const int mat_size2 = source.cols * source.rows / (scale_factor * scale_factor);
    int size2[2] = {mat_size, mat_size2};
    cv::SparseMat dhf(2, size2, CV_32FC1);

    const int step = source.cols / scale_factor;
    for (int y = 0; y < source.rows; y += scale_factor)
    {
        for (int x = 0; x < source.cols; x += scale_factor)
        {
            const int source_index = source.cols * y + x;
            const int dest_index = step * y / scale_factor + x / scale_factor;

            if (x >= x1 && x < source.cols - x1 - scale_factor && y >= y1 && y < source.rows - y1 - scale_factor)
            {
                for (int row = 0; row < scale_factor; row++)
                {
                    for (int col = 0; col < scale_factor; col++)
                    {
                        dhf.ref<float>(source_index + source.cols * (y0 + row) + x0 + col, dest_index) += a0 * b0 * div;
                        dhf.ref<float>(source_index + source.cols * (y0 + row) + x1 + col, dest_index) += a1 * b0 * div;
                        dhf.ref<float>(source_index + source.cols * (y1 + row) + x0 + col, dest_index) += a0 * b1 * div;
                        dhf.ref<float>(source_index + source.cols * (y1 + row) + x1 + col, dest_index) += a1 * b1 * div;
                    }
                }
            }
        }
    }

    return dhf;
}

cv::SparseMat create_degraded_image_and_sparse_mat_32f(cv::Mat& source, cv::Mat& destination, cv::Point2d move, int scale_factor)
{
    cv::SparseMat dhf = create_downsampled_motion_blur_sparse_mat_32f(source, scale_factor, move);
    const int mat_size = source.cols * source.rows;
    const int mat_size2 = source.cols * source.rows / (scale_factor * scale_factor);

    cv::Mat source_vec;
    source.reshape(3, mat_size).convertTo(source_vec, CV_32FC3);
    cv::Mat dest_vec(mat_size2, 1, CV_32FC3);
    mul_sparse_mat_32f(dhf, source_vec, dest_vec);
    dest_vec.reshape(3, destination.rows).convertTo(destination, CV_8UC3);
    return dhf;
}

bool calc_move(cv::Mat& image, cv::Mat& previous_image, cv::Point2d& move)
{
    cv::Mat gray;
    cv::Mat previous_gray;
    cv::cvtColor(image, gray, cv::COLOR_BGR2GRAY);
    cv::cvtColor(previous_image, previous_gray, cv::COLOR_BGR2GRAY);

    cv::Mat mask = cv::Mat::zeros(gray.size(), CV_8U);
    const int cols = gray.cols;
    const int rows = gray.rows;
    cv::Rect roi_rect(cvRound(cols * 0.15), cvRound(rows * 0.15), cvRound(cols * 0.7), cvRound(rows * 0.7));
    roi_rect &= cv::Rect(0, 0, cols, rows);
    if (roi_rect.empty())
    {
        move = cv::Point2d(0, 0);
        return true;
    }
    cv::Mat roi(mask, roi_rect);
    roi = cv::Scalar(255);

    std::vector<cv::Point2f> corners;
    cv::goodFeaturesToTrack(previous_gray, corners, 3, 0.01, 10, mask, 3, false, 0.04);
    if (corners.empty())
    {
        move = cv::Point2d(0, 0);
        return true;
    }

    std::vector<cv::Point2f> points;
    std::vector<unsigned char> status;
    std::vector<float> err;
    cv::TermCriteria termcrit(cv::TermCriteria::COUNT | cv::TermCriteria::EPS, 20, 0.03);
    cv::calcOpticalFlowPyrLK(previous_gray, gray, corners, points, status, err, cv::Size(31, 31), 3, termcrit, 0, 0.001);
    if (points.empty() || status.empty() || !status[0])
    {
        move = cv::Point2d(0, 0);
        return true;
    }

    move.x = corners[0].x - points[0].x;
    move.y = corners[0].y - points[0].y;
    return true;
}

void sum_float_views(cv::Mat source[], cv::Mat& destination, int view_count, float beta)
{
    for (int n = 0; n < view_count; n++)
    {
        for (int row = 0; row < destination.rows; row++)
        {
            destination.ptr<float>(row)[0] -= beta * source[n].ptr<float>(row)[0];
            destination.ptr<float>(row)[1] -= beta * source[n].ptr<float>(row)[1];
            destination.ptr<float>(row)[2] -= beta * source[n].ptr<float>(row)[2];
        }
    }
}

void btv_regularization(cv::Mat& source_vec, cv::Size kernel, float alpha, cv::Mat& destination_vec, cv::Size size)
{
    cv::Mat source;
    source_vec.reshape(3, size.height).convertTo(source, CV_32FC3);
    cv::Mat destination = cv::Mat::zeros(size.height, size.width, CV_32FC3);

    const int kw = (kernel.width - 1) / 2;
    const int kh = (kernel.height - 1) / 2;
    std::vector<float> weight(static_cast<size_t>(kernel.width) * kernel.height);
    for (int m = 0, count = 0; m <= kh; m++)
    {
        for (int l = kw; l + m >= 0; l--)
        {
            weight[count] = std::pow(alpha, std::abs(m) + std::abs(l));
            count++;
        }
    }

    for (int row = kh; row < source.rows - kh; row++)
    {
        float *s = source.ptr<float>(row);
        float *d = destination.ptr<float>(row);
        for (int col = kw; col < source.cols - kw; col++)
        {
            float r = 0.0f;
            float g = 0.0f;
            float b = 0.0f;
            const float sr = s[3 * col];
            const float sg = s[3 * col + 1];
            const float sb = s[3 * col + 2];
            for (int m = 0, count = 0; m <= kh; m++)
            {
                float *s2 = source.ptr<float>(row - m);
                float *ss = source.ptr<float>(row + m);
                for (int l = kw; l + m >= 0; l--)
                {
                    r += weight[count] * (sign_float(sr, ss[3 * (col + l)]) - sign_float(s2[3 * (col - l)], sr));
                    g += weight[count] * (sign_float(sg, ss[3 * (col + l) + 1]) - sign_float(s2[3 * (col - l) + 1], sg));
                    b += weight[count] * (sign_float(sb, ss[3 * (col + l) + 2]) - sign_float(s2[3 * (col - l) + 2], sb));
                    count++;
                }
            }
            d[3 * col] = r;
            d[3 * col + 1] = g;
            d[3 * col + 2] = b;
        }
    }

    destination.reshape(3, size.height * size.width).convertTo(destination_vec, CV_32FC3);
}

void superresolution_sparse_mat_32f(cv::Mat source[], cv::Mat& destination, cv::SparseMat dhf[], int view_count, int iterations, float beta, float lambda, float alpha, cv::Size reg_window, int method)
{
    cv::resize(source[0], destination, destination.size());

    cv::Mat dest_vec;
    destination.reshape(3, destination.cols * destination.rows).convertTo(dest_vec, CV_32FC3);

    std::vector<cv::Mat> dest_vec_temp(view_count);
    std::vector<cv::Mat> source_vec(view_count);
    std::vector<cv::Mat> degraded_vec(view_count);
    for (int n = 0; n < view_count; n++)
    {
        source[n].reshape(3, source[0].cols * source[0].rows).convertTo(source_vec[n], CV_32FC3);
        source[n].reshape(3, source[0].cols * source[0].rows).convertTo(degraded_vec[n], CV_32FC3);
        dest_vec_temp[n] = dest_vec.clone();
    }

    cv::Mat reg_vec = cv::Mat::zeros(destination.rows * destination.cols, 1, CV_32FC3);
    for (int iter = 0; iter < iterations; iter++)
    {
        if (lambda > 0.0f)
        {
            btv_regularization(dest_vec, reg_window, alpha, reg_vec, destination.size());
        }

        for (int n = 0; n < view_count; n++)
        {
            mul_sparse_mat_32f(dhf[n], dest_vec, degraded_vec[n]);
            cv::Mat temp(source[0].cols * source[0].rows, 1, CV_32FC3);
            if (method == SR_DATA_L1)
            {
                subtract_sign(degraded_vec[n], source_vec[n], temp);
            }
            else
            {
                cv::subtract(degraded_vec[n], source_vec[n], temp);
            }
            mul_sparse_mat_32f(dhf[n], temp, dest_vec_temp[n], true);
        }

        sum_float_views(dest_vec_temp.data(), dest_vec, view_count, beta);
        if (lambda > 0.0f)
        {
            cv::addWeighted(dest_vec, 1.0, reg_vec, -beta * lambda, 0.0, dest_vec);
        }
    }

    dest_vec.reshape(3, destination.rows).convertTo(destination, CV_8UC3);
}
}

extern "C" IPCV_CORE_API int ipcv_superres_btv(const IpcvImageList *images, int scale_factor, int iterations, float beta, float lambda, float alpha, IpcvDecodedImage *output)
{
    if (output == NULL)
    {
        return -1;
    }

    std::memset(output, 0, sizeof(*output));
    if (scale_factor <= 0 || iterations < 0)
    {
        set_error(output, "super-resolution scale factor must be positive and iterations must be non-negative");
        return -1;
    }

    try
    {
        std::vector<cv::Mat> input;
        char error[256] = {0};
        if (!image_list_to_mats(images, input, error))
        {
            set_error(output, error);
            return -1;
        }

        const int image_count = static_cast<int>(input.size());
        std::vector<cv::Point2d> move(image_count);
        std::vector<cv::SparseMat> matrices(image_count);
        std::vector<cv::Mat> degraded(input.begin(), input.end());

        cv::Mat ideal;
        cv::resize(degraded[0], ideal, cv::Size(), scale_factor, scale_factor, cv::INTER_LINEAR);
        if (ideal.empty())
        {
            set_error(output, "invalid super-resolution image input");
            return -1;
        }

        cv::Mat destination(ideal.size(), CV_8UC3);
        double smallest_x = 0.0;
        double smallest_y = 0.0;
        for (int i = 0; i < image_count; i++)
        {
            if (i == 0)
            {
                move[i] = cv::Point2d(0, 0);
            }
            else
            {
                calc_move(degraded[i], degraded[0], move[i]);
                move[i].x *= scale_factor;
                move[i].y *= scale_factor;
            }
            smallest_x = std::min(smallest_x, move[i].x);
            smallest_y = std::min(smallest_y, move[i].y);
        }

        cv::Mat trans_mat = (cv::Mat_<double>(2, 3) << 1, 0, -smallest_x / scale_factor, 0, 1, -smallest_y / scale_factor);
        cv::warpAffine(degraded[0], degraded[0], trans_mat, degraded[0].size());
        for (int i = 0; i < image_count; i++)
        {
            move[i].x -= smallest_x;
            move[i].y -= smallest_y;
            cv::Mat temp(ideal.rows / scale_factor, ideal.cols / scale_factor, CV_8UC3);
            matrices[i] = create_degraded_image_and_sparse_mat_32f(ideal, temp, move[i], scale_factor);
        }

        superresolution_sparse_mat_32f(degraded.data(), destination, matrices.data(), image_count, iterations, beta, lambda, alpha, cv::Size(7, 7), SR_DATA_L1);
        if (!mat_to_image(destination, output))
        {
            return -1;
        }

        return 0;
    }
    catch (const cv::Exception& e)
    {
        ipcv_free_decoded_image(output);
        set_error(output, e.what());
        return -1;
    }
    catch (const std::exception& e)
    {
        ipcv_free_decoded_image(output);
        set_error(output, e.what());
        return -1;
    }
    catch (...)
    {
        ipcv_free_decoded_image(output);
        set_error(output, "unknown super-resolution failure");
        return -1;
    }
}
