#define IPCV_CORE_EXPORTS
#include "ipcv_registration.h"

#include <opencv2/core.hpp>
#include <opencv2/features2d.hpp>
#include <opencv2/geometry.hpp>
#include <opencv2/imgproc.hpp>
#include <opencv2/video/tracking.hpp>

#include <cmath>
#include <cstdlib>
#include <cstring>
#include <exception>
#include <vector>

namespace
{
void set_error(IpcvDecodedImage *image, const char *message)
{
    if (image == NULL) return;
    std::strncpy(image->error, message, sizeof(image->error) - 1);
    image->error[sizeof(image->error) - 1] = 0;
}

size_t depth_size(int depth)
{
    switch (depth)
    {
    case IPCV_DEPTH_8U:
    case IPCV_DEPTH_8S: return 1;
    case IPCV_DEPTH_16U:
    case IPCV_DEPTH_16S: return 2;
    case IPCV_DEPTH_32S:
    case IPCV_DEPTH_32F: return 4;
    case IPCV_DEPTH_64F: return 8;
    default: return 0;
    }
}

void copy_scilab_layout_to_mat(const unsigned char *source, cv::Mat& destination)
{
    const int rows = destination.rows, cols = destination.cols, channels = destination.channels();
    const size_t elem_bytes = destination.elemSize1();
    for (int ch = 0; ch < channels; ch++)
    {
        int dst_ch = ((channels == 3 || channels == 4) && ch < 3) ? 2 - ch : ch;
        for (int col = 0; col < cols; col++)
            for (int row = 0; row < rows; row++)
            {
                const size_t src_offset = (static_cast<size_t>(ch) * rows * cols + static_cast<size_t>(col) * rows + row) * elem_bytes;
                unsigned char *dst = destination.ptr<unsigned char>(row) + ((col * channels + dst_ch) * elem_bytes);
                std::memcpy(dst, source + src_offset, elem_bytes);
            }
    }
}

void copy_to_scilab_layout(const cv::Mat& source, unsigned char *destination)
{
    const int rows = source.rows, cols = source.cols, channels = source.channels();
    const size_t elem_bytes = source.elemSize1();
    for (int ch = 0; ch < channels; ch++)
    {
        int src_ch = ((channels == 3 || channels == 4) && ch < 3) ? 2 - ch : ch;
        for (int col = 0; col < cols; col++)
            for (int row = 0; row < rows; row++)
            {
                const unsigned char *src = source.ptr<unsigned char>(row) + ((col * channels + src_ch) * elem_bytes);
                const size_t dst_offset = (static_cast<size_t>(ch) * rows * cols + static_cast<size_t>(col) * rows + row) * elem_bytes;
                std::memcpy(destination + dst_offset, src, elem_bytes);
            }
    }
}

bool image_to_mat(const IpcvDecodedImage& image, cv::Mat& mat, char *error)
{
    const size_t elem_bytes = depth_size(image.depth);
    const size_t expected = static_cast<size_t>(image.rows) * image.cols * image.channels * elem_bytes;
    if (image.data == NULL || image.rows <= 0 || image.cols <= 0 || image.channels <= 0 || elem_bytes == 0 || image.byte_count != expected)
    {
        if (error != NULL) std::strcpy(error, "invalid image input");
        return false;
    }
    mat.create(image.rows, image.cols, CV_MAKETYPE(image.depth, image.channels));
    copy_scilab_layout_to_mat(image.data, mat);
    return true;
}

bool mat_to_image(const cv::Mat& mat, IpcvDecodedImage *image)
{
    if (image == NULL || mat.empty()) return false;
    std::memset(image, 0, sizeof(*image));
    image->rows = mat.rows;
    image->cols = mat.cols;
    image->channels = mat.channels();
    image->depth = mat.depth();
    image->byte_count = mat.total() * mat.elemSize();
    image->data = static_cast<unsigned char*>(std::malloc(image->byte_count));
    if (image->data == NULL)
    {
        set_error(image, "out of memory");
        return false;
    }
    copy_to_scilab_layout(mat, image->data);
    return true;
}

cv::Mat to_gray_float(const cv::Mat& image)
{
    cv::Mat gray;
    if (image.channels() == 3) cv::cvtColor(image, gray, cv::COLOR_BGR2GRAY);
    else if (image.channels() == 4) cv::cvtColor(image, gray, cv::COLOR_BGRA2GRAY);
    else gray = image;
    cv::Mat float_image;
    gray.convertTo(float_image, CV_32F, gray.depth() == CV_8U ? 1.0 / 255.0 : 1.0);
    return float_image;
}

cv::Mat to_gray_u8(const cv::Mat& image)
{
    cv::Mat gray;
    if (image.channels() == 3) cv::cvtColor(image, gray, cv::COLOR_BGR2GRAY);
    else if (image.channels() == 4) cv::cvtColor(image, gray, cv::COLOR_BGRA2GRAY);
    else gray = image;

    if (gray.depth() == CV_8U) return gray;

    double minimum = 0.0, maximum = 0.0;
    cv::minMaxLoc(gray, &minimum, &maximum);
    cv::Mat converted;
    if (maximum > minimum)
        gray.convertTo(converted, CV_8U, 255.0 / (maximum - minimum), -minimum * 255.0 / (maximum - minimum));
    else
        converted = cv::Mat::zeros(gray.size(), CV_8U);
    return converted;
}

bool feature_similarity_register(const cv::Mat& target, const cv::Mat& source,
    cv::Mat& registered, double translation[2], double& rotation_degrees, double& scale_value)
{
    const cv::Mat target_gray = to_gray_u8(target);
    const cv::Mat source_gray = to_gray_u8(source);
    cv::Ptr<cv::SIFT> sift = cv::SIFT::create(1200);
    std::vector<cv::KeyPoint> target_keypoints, source_keypoints;
    cv::Mat target_descriptors, source_descriptors;
    sift->detectAndCompute(target_gray, cv::noArray(), target_keypoints, target_descriptors);
    sift->detectAndCompute(source_gray, cv::noArray(), source_keypoints, source_descriptors);
    if (target_descriptors.empty() || source_descriptors.empty()) return false;

    std::vector<std::vector<cv::DMatch> > neighbours;
    cv::BFMatcher(cv::NORM_L2).knnMatch(source_descriptors, target_descriptors, neighbours, 2);
    std::vector<cv::Point2f> source_points, target_points;
    for (size_t i = 0; i < neighbours.size(); i++)
    {
        if (neighbours[i].size() < 2 || neighbours[i][0].distance >= 0.75f * neighbours[i][1].distance) continue;
        source_points.push_back(source_keypoints[neighbours[i][0].queryIdx].pt);
        target_points.push_back(target_keypoints[neighbours[i][0].trainIdx].pt);
    }
    if (source_points.size() < 6) return false;

    cv::Mat inliers;
    cv::Mat transform = cv::estimateAffinePartial2D(source_points, target_points, inliers,
        cv::RANSAC, 3.0, 3000, 0.995, 20);
    if (transform.empty()) return false;

    const int inlier_count = cv::countNonZero(inliers);
    if (inlier_count < 6 || inlier_count * 4 < static_cast<int>(source_points.size())) return false;

    transform.convertTo(transform, CV_64F);
    const double a = transform.at<double>(0, 0);
    const double b = transform.at<double>(1, 0);
    const double estimated_scale = std::sqrt(a * a + b * b);
    if (!std::isfinite(estimated_scale) || estimated_scale < 0.05 || estimated_scale > 20.0) return false;

    cv::warpAffine(source, registered, transform, target.size(), cv::INTER_LINEAR, cv::BORDER_CONSTANT);
    translation[0] = transform.at<double>(0, 2);
    translation[1] = transform.at<double>(1, 2);
    rotation_degrees = std::atan2(b, a) * 180.0 / CV_PI;
    scale_value = estimated_scale;
    if (std::abs(translation[0]) < 1e-3) translation[0] = 0.0;
    if (std::abs(translation[1]) < 1e-3) translation[1] = 0.0;
    if (std::abs(rotation_degrees) < 1e-3) rotation_degrees = 0.0;
    if (std::abs(scale_value - 1.0) < 1e-3) scale_value = 1.0;
    return true;
}

double estimate_canvas_rotation(const cv::Mat& image)
{
    cv::Mat gray = to_gray_float(image);
    double min_value = 0.0, max_value = 0.0;
    cv::minMaxLoc(gray, &min_value, &max_value);
    if (max_value - min_value <= 1e-9) return 0.0;

    cv::Mat mask;
    cv::threshold(gray, mask, min_value + 0.02 * (max_value - min_value), 255.0, cv::THRESH_BINARY);
    mask.convertTo(mask, CV_8U);
    const double mask_fraction = static_cast<double>(cv::countNonZero(mask)) / mask.total();
    if (mask_fraction < 0.05 || mask_fraction > 0.9) return 0.0;

    std::vector<cv::Point> points;
    cv::findNonZero(mask, points);
    if (points.size() < 16) return 0.0;

    cv::Mat data(static_cast<int>(points.size()), 2, CV_64F);
    for (int i = 0; i < static_cast<int>(points.size()); i++)
    {
        data.at<double>(i, 0) = points[i].x;
        data.at<double>(i, 1) = points[i].y;
    }

    cv::PCA pca(data, cv::Mat(), cv::PCA::DATA_AS_ROW);
    const cv::Vec2d axis(pca.eigenvectors.at<double>(0, 0), pca.eigenvectors.at<double>(0, 1));
    double angle = std::atan2(axis[1], axis[0]) * 180.0 / CV_PI;
    while (angle > 90.0) angle -= 180.0;
    while (angle < -90.0) angle += 180.0;
    return -angle;
}

cv::Mat rotate_expand(const cv::Mat& source, double angle)
{
    if (std::abs(angle) < 1e-6) return source.clone();
    const cv::Point2f center(source.cols / 2.0f, source.rows / 2.0f);
    cv::Mat matrix = cv::getRotationMatrix2D(center, angle, 1.0);
    const cv::Rect2f bbox = cv::RotatedRect(cv::Point2f(), source.size(), static_cast<float>(angle)).boundingRect2f();
    const cv::Size output_size(static_cast<int>(std::ceil(bbox.width)), static_cast<int>(std::ceil(bbox.height)));
    matrix.at<double>(0, 2) += output_size.width / 2.0 - center.x;
    matrix.at<double>(1, 2) += output_size.height / 2.0 - center.y;
    cv::Mat rotated;
    cv::warpAffine(source, rotated, matrix, output_size, cv::INTER_LINEAR, cv::BORDER_CONSTANT);
    return rotated;
}

cv::Mat fit_to_canvas(const cv::Mat& image, const cv::Size& size)
{
    cv::Mat canvas(size, image.type(), cv::Scalar::all(0));
    const int rows = std::min(size.height, image.rows);
    const int cols = std::min(size.width, image.cols);
    if (rows > 0 && cols > 0)
    {
        image(cv::Rect(0, 0, cols, rows)).copyTo(canvas(cv::Rect(0, 0, cols, rows)));
    }
    return canvas;
}

void phase_translate(const cv::Mat& target_gray, const cv::Mat& source_gray, cv::Mat& source_image, cv::Mat& output, double translation[2])
{
    cv::Point2d shift = cv::phaseCorrelate(target_gray, source_gray);
    translation[0] = shift.x;
    translation[1] = shift.y;
    cv::Mat matrix = cv::Mat::zeros(2, 3, CV_64F);
    matrix.at<double>(0, 0) = 1.0;
    matrix.at<double>(1, 1) = 1.0;
    matrix.at<double>(0, 2) = -shift.x;
    matrix.at<double>(1, 2) = -shift.y;
    cv::warpAffine(source_image, output, matrix, target_gray.size(), cv::INTER_LINEAR, cv::BORDER_CONSTANT);
}
}

extern "C" IPCV_CORE_API int ipcv_phase_register_image(const IpcvDecodedImage *target,
    const IpcvDecodedImage *source, IpcvDecodedImage *registered_image,
    double translation[2], double *rotation_degrees, double *scale_value)
{
    if (registered_image == NULL) return -1;
    std::memset(registered_image, 0, sizeof(*registered_image));
    if (target == NULL || source == NULL || translation == NULL || rotation_degrees == NULL || scale_value == NULL)
    {
        set_error(registered_image, "missing registration input");
        return -1;
    }

    try
    {
        cv::setNumThreads(1);
        cv::setUseOptimized(false);

        cv::Mat target_mat, source_mat;
        char error[256] = {0};
        if (!image_to_mat(*target, target_mat, error) || !image_to_mat(*source, source_mat, error))
        {
            set_error(registered_image, error);
            return -1;
        }

        cv::Mat feature_registered;
        double feature_rotation = 0.0;
        double feature_scale = 1.0;
        if (feature_similarity_register(target_mat, source_mat, feature_registered,
            translation, feature_rotation, feature_scale))
        {
            *rotation_degrees = feature_rotation;
            *scale_value = feature_scale;
            if (!mat_to_image(feature_registered, registered_image))
            {
                if (registered_image->error[0] == 0) set_error(registered_image, "could not convert registered image");
                return -1;
            }
            return 0;
        }

        const cv::Size target_size(target_mat.cols, target_mat.rows);
        double pre_scale = 1.0;
        double pre_rotation = 0.0;
        cv::Mat prepared = source_mat;
        if (source_mat.size() != target_size)
        {
            pre_scale = std::min(static_cast<double>(target_mat.rows) / source_mat.rows, static_cast<double>(target_mat.cols) / source_mat.cols);
            cv::resize(prepared, prepared, cv::Size(), pre_scale, pre_scale, cv::INTER_LINEAR);
            pre_rotation = estimate_canvas_rotation(source_mat);
            prepared = rotate_expand(prepared, pre_rotation);
        }
        prepared = fit_to_canvas(prepared, target_size);

        cv::Mat target_gray = to_gray_float(target_mat);
        cv::Mat prepared_gray = to_gray_float(prepared);
        cv::Mat aligned;
        cv::Mat phase_aligned;
        double phase_translation[2] = {0.0, 0.0};
        double affine_rotation = 0.0;
        double affine_scale = 1.0;
        translation[0] = 0.0;
        translation[1] = 0.0;

        phase_translate(target_gray, prepared_gray, prepared, phase_aligned, phase_translation);
        translation[0] = phase_translation[0];
        translation[1] = phase_translation[1];

        try
        {
            cv::Mat warp = cv::Mat::eye(2, 3, CV_32F);
            cv::TermCriteria criteria(cv::TermCriteria::COUNT | cv::TermCriteria::EPS, 80, 1e-6);
            cv::Mat phase_aligned_gray = to_gray_float(phase_aligned);
            cv::findTransformECC(target_gray, phase_aligned_gray, warp, cv::MOTION_AFFINE, criteria);
            cv::warpAffine(phase_aligned, aligned, warp, target_size, cv::INTER_LINEAR | cv::WARP_INVERSE_MAP, cv::BORDER_CONSTANT);

            const double a = warp.at<float>(0, 0);
            const double b = warp.at<float>(1, 0);
            affine_scale = std::sqrt(a * a + b * b);
            affine_rotation = std::atan2(b, a) * 180.0 / CV_PI;
            translation[0] += warp.at<float>(0, 2);
            translation[1] += warp.at<float>(1, 2);
        }
        catch (const cv::Exception&)
        {
            aligned = phase_aligned;
        }

        cv::Mat residual_aligned;
        cv::Mat aligned_gray = to_gray_float(aligned);
        double residual_translation[2] = {0.0, 0.0};
        phase_translate(target_gray, aligned_gray, aligned, residual_aligned, residual_translation);
        aligned = residual_aligned;
        translation[0] += residual_translation[0];
        translation[1] += residual_translation[1];

        *rotation_degrees = pre_rotation + affine_rotation;
        *scale_value = pre_scale * affine_scale;
        if (std::abs(translation[0]) < 1e-3) translation[0] = 0.0;
        if (std::abs(translation[1]) < 1e-3) translation[1] = 0.0;
        if (std::abs(*rotation_degrees) < 1e-3) *rotation_degrees = 0.0;
        if (std::abs(*scale_value - 1.0) < 1e-3) *scale_value = 1.0;
        if (!mat_to_image(aligned, registered_image))
        {
            if (registered_image->error[0] == 0) set_error(registered_image, "could not convert registered image");
            return -1;
        }
        return 0;
    }
    catch (const cv::Exception& e)
    {
        set_error(registered_image, e.what());
        return -1;
    }
    catch (const std::exception& e)
    {
        set_error(registered_image, e.what());
        return -1;
    }
    catch (...)
    {
        set_error(registered_image, "unknown registration failure");
        return -1;
    }
}

extern "C" IPCV_CORE_API int ipcv_template_match_image(const IpcvDecodedImage *source,
    const IpcvDecodedImage *templ, int method, IpcvDecodedImage *score)
{
    if (score == NULL) return -1;
    std::memset(score, 0, sizeof(*score));
    if (source == NULL || templ == NULL)
    {
        set_error(score, "missing source image or template");
        return -1;
    }

    try
    {
        cv::Mat source_mat, template_mat;
        char error[256] = {0};
        if (!image_to_mat(*source, source_mat, error) || !image_to_mat(*templ, template_mat, error))
        {
            set_error(score, error);
            return -1;
        }
        if (source_mat.channels() != template_mat.channels())
        {
            set_error(score, "source image and template must have the same channel count");
            return -1;
        }
        if (template_mat.rows > source_mat.rows || template_mat.cols > source_mat.cols)
        {
            set_error(score, "template must fit inside the source image");
            return -1;
        }

        int cv_method = cv::TM_CCORR_NORMED;
        switch (method)
        {
        case IPCV_TEMPLATE_CCORR: cv_method = cv::TM_CCORR; break;
        case IPCV_TEMPLATE_CCORR_NORMED: cv_method = cv::TM_CCORR_NORMED; break;
        case IPCV_TEMPLATE_CCOEFF: cv_method = cv::TM_CCOEFF; break;
        case IPCV_TEMPLATE_CCOEFF_NORMED: cv_method = cv::TM_CCOEFF_NORMED; break;
        default:
            set_error(score, "unsupported template matching method");
            return -1;
        }

        cv::Mat source_float, template_float, result;
        source_mat.convertTo(source_float, CV_MAKETYPE(CV_32F, source_mat.channels()));
        template_mat.convertTo(template_float, CV_MAKETYPE(CV_32F, template_mat.channels()));
        cv::matchTemplate(source_float, template_float, result, cv_method);
        if (!mat_to_image(result, score))
        {
            if (score->error[0] == 0) set_error(score, "could not convert template matching score");
            return -1;
        }
        return 0;
    }
    catch (const cv::Exception& e)
    {
        set_error(score, e.what());
        return -1;
    }
    catch (const std::exception& e)
    {
        set_error(score, e.what());
        return -1;
    }
    catch (...)
    {
        set_error(score, "unknown template matching failure");
        return -1;
    }
}
