#define IPCV_CORE_EXPORTS
#include "ipcv_feature_detection.h"

#include <opencv2/core.hpp>
#include <opencv2/features2d.hpp>
#include <opencv2/imgproc.hpp>
#include <opencv2/xfeatures2d.hpp>
#include <opencv2/xfeatures2d/nonfree.hpp>

#include <algorithm>
#include <cstdlib>
#include <cstring>
#include <exception>
#include <vector>

namespace
{
void set_error(IpcvKeypointMatrix *keypoints, const char *message)
{
    if (keypoints == NULL)
    {
        return;
    }

    std::strncpy(keypoints->error, message, sizeof(keypoints->error) - 1);
    keypoints->error[sizeof(keypoints->error) - 1] = 0;
}

void set_match_error(IpcvMatchMatrix *matches, const char *message)
{
    if (matches == NULL)
    {
        return;
    }

    std::strncpy(matches->error, message, sizeof(matches->error) - 1);
    matches->error[sizeof(matches->error) - 1] = 0;
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
    cv::Mat mat;
    if (!image_to_mat(source, mat, error))
    {
        return false;
    }

    if (mat.channels() == 3)
    {
        cv::cvtColor(mat, gray, cv::COLOR_BGR2GRAY);
    }
    else if (mat.channels() == 4)
    {
        cv::cvtColor(mat, gray, cv::COLOR_BGRA2GRAY);
    }
    else if (mat.channels() == 1)
    {
        gray = mat;
    }
    else
    {
        std::strcpy(error, "feature detection requires a one-, three-, or four-channel image");
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

bool descriptor_to_mat(const IpcvDecodedImage& image, cv::Mat& mat, char *error)
{
    if (!image_to_mat(image, mat, error))
    {
        return false;
    }

    if (mat.channels() != 1)
    {
        std::strcpy(error, "descriptor matrix must be single-channel");
        return false;
    }

    return true;
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

bool image_to_mser_8u(const IpcvDecodedImage& source, cv::Mat& image, char *error)
{
    cv::Mat mat;
    if (!image_to_mat(source, mat, error))
    {
        return false;
    }

    if (mat.channels() == 1 || mat.channels() == 3)
    {
        image = mat;
    }
    else if (mat.channels() == 4)
    {
        cv::cvtColor(mat, image, cv::COLOR_BGRA2BGR);
    }
    else
    {
        std::strcpy(error, "MSER detection requires a one-, three-, or four-channel image");
        return false;
    }

    if (image.depth() != CV_8U)
    {
        cv::Mat converted;
        image.convertTo(converted, CV_8U);
        image = converted;
    }

    return true;
}

bool set_keypoints(IpcvKeypointMatrix *output, const std::vector<cv::KeyPoint>& keypoints)
{
    if (output == NULL)
    {
        return false;
    }

    output->rows = 7;
    output->cols = static_cast<int>(keypoints.size());
    const size_t count = static_cast<size_t>(output->rows) * output->cols;
    output->data = static_cast<double*>(std::calloc(count == 0 ? 1 : count, sizeof(double)));
    if (output->data == NULL)
    {
        set_error(output, "out of memory");
        return false;
    }

    for (int col = 0; col < output->cols; col++)
    {
        const cv::KeyPoint& point = keypoints[col];
        output->data[output->rows * col] = point.pt.x;
        output->data[output->rows * col + 1] = point.pt.y;
        output->data[output->rows * col + 2] = point.size;
        output->data[output->rows * col + 3] = point.angle;
        output->data[output->rows * col + 4] = point.response;
        output->data[output->rows * col + 5] = point.octave;
        output->data[output->rows * col + 6] = point.class_id;
    }

    return true;
}

bool set_mser_regions(IpcvKeypointMatrix *output, const std::vector<cv::Rect>& boxes)
{
    if (output == NULL)
    {
        return false;
    }

    output->rows = 7;
    output->cols = static_cast<int>(boxes.size());
    const size_t count = static_cast<size_t>(output->rows) * output->cols;
    output->data = static_cast<double*>(std::calloc(count == 0 ? 1 : count, sizeof(double)));
    if (output->data == NULL)
    {
        set_error(output, "out of memory");
        return false;
    }

    for (int col = 0; col < output->cols; col++)
    {
        const cv::Rect& box = boxes[col];
        output->data[output->rows * col] = box.x + box.width / 2.0;
        output->data[output->rows * col + 1] = box.y + box.height / 2.0;
        output->data[output->rows * col + 2] = std::max(box.width, box.height);
        output->data[output->rows * col + 3] = -1.0;
        output->data[output->rows * col + 4] = 0.0;
        output->data[output->rows * col + 5] = 0.0;
        output->data[output->rows * col + 6] = col;
    }

    return true;
}

std::vector<cv::KeyPoint> keypoint_matrix_to_vector(const IpcvKeypointMatrix *keypoints)
{
    std::vector<cv::KeyPoint> points;
    if (keypoints == NULL || keypoints->rows != 7 || keypoints->cols <= 0 || keypoints->data == NULL)
    {
        return points;
    }

    points.reserve(keypoints->cols);
    for (int col = 0; col < keypoints->cols; col++)
    {
        const double *item = keypoints->data + static_cast<size_t>(keypoints->rows) * col;
        points.push_back(cv::KeyPoint(
            static_cast<float>(item[0]),
            static_cast<float>(item[1]),
            static_cast<float>(item[2]),
            static_cast<float>(item[3]),
            static_cast<float>(item[4]),
            static_cast<int>(item[5]),
            static_cast<int>(item[6])));
    }

    return points;
}

bool set_descriptor_image(IpcvDecodedImage *output, const cv::Mat& descriptors)
{
    if (output == NULL)
    {
        return false;
    }

    std::memset(output, 0, sizeof(*output));
    if (descriptors.empty())
    {
        output->rows = 1;
        output->cols = 0;
        output->channels = 1;
        output->depth = IPCV_DEPTH_8U;
        output->byte_count = 1;
        output->data = static_cast<unsigned char*>(std::calloc(1, 1));
        if (output->data == NULL)
        {
            set_image_error(output, "out of memory");
            return false;
        }
        return true;
    }

    if (descriptors.channels() != 1)
    {
        set_image_error(output, "descriptor matrix must be single-channel");
        return false;
    }

    output->rows = descriptors.rows;
    output->cols = descriptors.cols;
    output->channels = 1;

    if (descriptors.depth() == CV_8U)
    {
        output->depth = IPCV_DEPTH_8U;
        output->byte_count = static_cast<size_t>(output->rows) * output->cols;
        output->data = static_cast<unsigned char*>(std::malloc(output->byte_count));
        if (output->data == NULL)
        {
            set_image_error(output, "out of memory");
            return false;
        }

        for (int col = 0; col < output->cols; col++)
        {
            for (int row = 0; row < output->rows; row++)
            {
                output->data[static_cast<size_t>(col) * output->rows + row] = descriptors.at<unsigned char>(row, col);
            }
        }
        return true;
    }

    cv::Mat as_float;
    if (descriptors.depth() == CV_32F)
    {
        as_float = descriptors;
    }
    else
    {
        descriptors.convertTo(as_float, CV_32F);
    }

    output->depth = IPCV_DEPTH_64F;
    output->byte_count = static_cast<size_t>(output->rows) * output->cols * sizeof(double);
    output->data = static_cast<unsigned char*>(std::malloc(output->byte_count));
    if (output->data == NULL)
    {
        set_image_error(output, "out of memory");
        return false;
    }

    double *target = reinterpret_cast<double*>(output->data);
    for (int col = 0; col < output->cols; col++)
    {
        for (int row = 0; row < output->rows; row++)
        {
            target[static_cast<size_t>(col) * output->rows + row] = static_cast<double>(as_float.at<float>(row, col));
        }
    }

    return true;
}

bool set_mat_image(IpcvDecodedImage *output, const cv::Mat& image)
{
    if (output == NULL)
    {
        return false;
    }

    std::memset(output, 0, sizeof(*output));
    if (image.empty() || image.depth() != CV_8U || image.channels() <= 0)
    {
        set_image_error(output, "output image must be non-empty uint8 data");
        return false;
    }

    output->rows = image.rows;
    output->cols = image.cols;
    output->channels = image.channels();
    output->depth = IPCV_DEPTH_8U;
    output->byte_count = image.total() * image.elemSize();
    output->data = static_cast<unsigned char*>(std::malloc(output->byte_count));
    if (output->data == NULL)
    {
        set_image_error(output, "out of memory");
        return false;
    }

    copy_mat_to_scilab_layout(image, output->data);
    return true;
}

std::vector<cv::Rect> nonzero_component_boxes(const cv::Mat& image, int min_area, int max_area)
{
    std::vector<cv::Rect> boxes;
    if (image.channels() != 1)
    {
        return boxes;
    }

    cv::Mat mask;
    cv::compare(image, cv::Scalar(0), mask, cv::CMP_NE);

    cv::Mat labels;
    cv::Mat stats;
    cv::Mat centroids;
    const int count = cv::connectedComponentsWithStats(mask, labels, stats, centroids, 4, CV_32S);
    for (int label = 1; label < count; label++)
    {
        const int area = stats.at<int>(label, cv::CC_STAT_AREA);
        if (area < min_area || area > max_area)
        {
            continue;
        }

        boxes.push_back(cv::Rect(
            stats.at<int>(label, cv::CC_STAT_LEFT),
            stats.at<int>(label, cv::CC_STAT_TOP),
            stats.at<int>(label, cv::CC_STAT_WIDTH),
            stats.at<int>(label, cv::CC_STAT_HEIGHT)));
    }

    return boxes;
}

int run_detector(const IpcvDecodedImage *source, const cv::Ptr<cv::Feature2D>& detector, IpcvKeypointMatrix *keypoints, const char *missing_message)
{
    if (keypoints == NULL)
    {
        return -1;
    }

    std::memset(keypoints, 0, sizeof(*keypoints));
    if (source == NULL)
    {
        set_error(keypoints, missing_message);
        return -1;
    }

    try
    {
        cv::setNumThreads(1);
        cv::setUseOptimized(false);

        cv::Mat gray;
        char error[256] = {0};
        if (!image_to_gray_8u(*source, gray, error))
        {
            set_error(keypoints, error);
            return -1;
        }

        std::vector<cv::KeyPoint> detected;
        detector->detect(gray, detected);
        return set_keypoints(keypoints, detected) ? 0 : -1;
    }
    catch (const cv::Exception& e)
    {
        ipcv_free_keypoint_matrix(keypoints);
        set_error(keypoints, e.what());
        return -1;
    }
    catch (const std::exception& e)
    {
        ipcv_free_keypoint_matrix(keypoints);
        set_error(keypoints, e.what());
        return -1;
    }
    catch (...)
    {
        ipcv_free_keypoint_matrix(keypoints);
        set_error(keypoints, "unknown feature detection failure");
        return -1;
    }
}

int run_mser_detector(const IpcvDecodedImage *source, const cv::Ptr<cv::MSER>& detector, IpcvKeypointMatrix *keypoints)
{
    if (keypoints == NULL)
    {
        return -1;
    }

    std::memset(keypoints, 0, sizeof(*keypoints));
    if (source == NULL)
    {
        set_error(keypoints, "missing MSER image input");
        return -1;
    }

    try
    {
        cv::setNumThreads(1);
        cv::setUseOptimized(false);

        cv::Mat image;
        char error[256] = {0};
        if (!image_to_mser_8u(*source, image, error))
        {
            set_error(keypoints, error);
            return -1;
        }

        std::vector<std::vector<cv::Point>> regions;
        std::vector<cv::Rect> boxes;
        detector->detectRegions(image, regions, boxes);
        if (boxes.empty())
        {
            boxes = nonzero_component_boxes(image, detector->getMinArea(), detector->getMaxArea());
        }
        return set_mser_regions(keypoints, boxes) ? 0 : -1;
    }
    catch (const cv::Exception& e)
    {
        ipcv_free_keypoint_matrix(keypoints);
        set_error(keypoints, e.what());
        return -1;
    }
    catch (const std::exception& e)
    {
        ipcv_free_keypoint_matrix(keypoints);
        set_error(keypoints, e.what());
        return -1;
    }
    catch (...)
    {
        ipcv_free_keypoint_matrix(keypoints);
        set_error(keypoints, "unknown MSER detection failure");
        return -1;
    }
}

int run_descriptor_extractor(const IpcvDecodedImage *source, const IpcvKeypointMatrix *keypoints, const cv::Ptr<cv::Feature2D>& extractor, IpcvDecodedImage *descriptors, const char *missing_message)
{
    if (descriptors == NULL)
    {
        return -1;
    }

    std::memset(descriptors, 0, sizeof(*descriptors));
    if (source == NULL || keypoints == NULL)
    {
        set_image_error(descriptors, missing_message);
        return -1;
    }

    try
    {
        cv::setNumThreads(1);
        cv::setUseOptimized(false);

        cv::Mat gray;
        char error[256] = {0};
        if (!image_to_gray_8u(*source, gray, error))
        {
            set_image_error(descriptors, error);
            return -1;
        }

        std::vector<cv::KeyPoint> points = keypoint_matrix_to_vector(keypoints);
        cv::Mat descriptor_mat;
        extractor->compute(gray, points, descriptor_mat);
        return set_descriptor_image(descriptors, descriptor_mat) ? 0 : -1;
    }
    catch (const cv::Exception& e)
    {
        ipcv_free_decoded_image(descriptors);
        set_image_error(descriptors, e.what());
        return -1;
    }
    catch (const std::exception& e)
    {
        ipcv_free_decoded_image(descriptors);
        set_image_error(descriptors, e.what());
        return -1;
    }
    catch (...)
    {
        ipcv_free_decoded_image(descriptors);
        set_image_error(descriptors, "unknown descriptor extraction failure");
        return -1;
    }
}

bool prepare_match_descriptors(const cv::Mat& source, cv::Mat& target, int norm_type, char *error)
{
    if (source.empty())
    {
        target = source;
        return true;
    }

    if (norm_type == 1 || norm_type == 2)
    {
        if (source.depth() == CV_8U)
        {
            source.convertTo(target, CV_32F, 1.0 / 255.0);
            return true;
        }
        if (source.depth() == CV_64F || source.depth() == CV_32F)
        {
            source.convertTo(target, CV_32F);
            return true;
        }
    }
    else if (norm_type == 3 || norm_type == 4)
    {
        if (source.depth() == CV_8U)
        {
            target = source;
            return true;
        }
        if (source.depth() == CV_64F || source.depth() == CV_32F)
        {
            source.convertTo(target, CV_8U, 255.0);
            return true;
        }
    }

    std::strcpy(error, "unsupported descriptor depth for requested brute-force norm");
    return false;
}

bool set_matches(IpcvMatchMatrix *output, const std::vector<cv::DMatch>& matches)
{
    if (output == NULL)
    {
        return false;
    }

    output->rows = 4;
    output->cols = static_cast<int>(matches.size());
    const size_t count = static_cast<size_t>(output->rows) * output->cols;
    output->data = static_cast<double*>(std::calloc(count == 0 ? 1 : count, sizeof(double)));
    if (output->data == NULL)
    {
        set_match_error(output, "out of memory");
        return false;
    }

    for (int col = 0; col < output->cols; col++)
    {
        output->data[output->rows * col] = matches[col].queryIdx;
        output->data[output->rows * col + 1] = matches[col].trainIdx;
        output->data[output->rows * col + 2] = matches[col].imgIdx;
        output->data[output->rows * col + 3] = matches[col].distance;
    }

    return true;
}

std::vector<cv::DMatch> match_matrix_to_vector(const IpcvMatchMatrix *matches)
{
    std::vector<cv::DMatch> result;
    if (matches == NULL || matches->rows != 4 || matches->cols <= 0 || matches->data == NULL)
    {
        return result;
    }

    result.reserve(matches->cols);
    for (int col = 0; col < matches->cols; col++)
    {
        const double *item = matches->data + static_cast<size_t>(matches->rows) * col;
        result.push_back(cv::DMatch(
            static_cast<int>(item[0]) - 1,
            static_cast<int>(item[1]) - 1,
            static_cast<int>(item[2]),
            static_cast<float>(item[3])));
    }

    return result;
}
}

extern "C" IPCV_CORE_API int ipcv_detect_fast(const IpcvDecodedImage *source, double threshold, int nonmax_suppression, int type, IpcvKeypointMatrix *keypoints)
{
    cv::Ptr<cv::FastFeatureDetector> detector = cv::FastFeatureDetector::create(static_cast<int>(threshold), nonmax_suppression != 0, cv::FastFeatureDetector::DetectorType(type));
    return run_detector(source, detector, keypoints, "missing FAST image input");
}

extern "C" IPCV_CORE_API int ipcv_detect_brisk(const IpcvDecodedImage *source, int threshold, int octaves, double pattern_scale, IpcvKeypointMatrix *keypoints)
{
    cv::Ptr<cv::xfeatures2d::BRISK> detector = cv::xfeatures2d::BRISK::create(threshold, octaves, static_cast<float>(pattern_scale));
    return run_detector(source, detector, keypoints, "missing BRISK image input");
}

extern "C" IPCV_CORE_API int ipcv_detect_gftt(const IpcvDecodedImage *source, int max_corners, double quality_level, double min_distance, int block_size, double k, IpcvKeypointMatrix *keypoints)
{
    cv::Ptr<cv::GFTTDetector> detector = cv::GFTTDetector::create(max_corners, quality_level, min_distance, block_size, false, k);
    return run_detector(source, detector, keypoints, "missing GFTT image input");
}

extern "C" IPCV_CORE_API int ipcv_detect_mser(const IpcvDecodedImage *source, int delta, int min_area, int max_area, double max_variation, double min_diversity, int max_evolution, double area_threshold, double min_margin, int edge_blur_size, IpcvKeypointMatrix *keypoints)
{
    cv::Ptr<cv::MSER> detector = cv::MSER::create(delta, min_area, max_area, max_variation, min_diversity, max_evolution, area_threshold, min_margin, edge_blur_size);
    return run_mser_detector(source, detector, keypoints);
}

extern "C" IPCV_CORE_API int ipcv_detect_orb(const IpcvDecodedImage *source, int nfeatures, double scale_factor, int nlevels, int edge_threshold, int first_level, int wta_k, int score_type, int patch_size, IpcvKeypointMatrix *keypoints)
{
    cv::Ptr<cv::ORB> detector = cv::ORB::create(nfeatures, static_cast<float>(scale_factor), nlevels, edge_threshold, first_level, wta_k, cv::ORB::ScoreType(score_type), patch_size);
    return run_detector(source, detector, keypoints, "missing ORB image input");
}

extern "C" IPCV_CORE_API int ipcv_detect_sift(const IpcvDecodedImage *source, int nfeatures, int octave_layers, double contrast_threshold, double edge_threshold, double sigma, IpcvKeypointMatrix *keypoints)
{
    cv::Ptr<cv::SIFT> detector = cv::SIFT::create(nfeatures, octave_layers, contrast_threshold, edge_threshold, sigma);
    return run_detector(source, detector, keypoints, "missing SIFT image input");
}

extern "C" IPCV_CORE_API int ipcv_detect_star(const IpcvDecodedImage *source, int max_size, int response_threshold, int line_threshold_projected, int line_threshold_binarized, int suppress_nonmax_size, IpcvKeypointMatrix *keypoints)
{
    cv::Ptr<cv::xfeatures2d::StarDetector> detector = cv::xfeatures2d::StarDetector::create(max_size, response_threshold, line_threshold_projected, line_threshold_binarized, suppress_nonmax_size);
    return run_detector(source, detector, keypoints, "missing STAR image input");
}

extern "C" IPCV_CORE_API int ipcv_detect_surf(const IpcvDecodedImage *source, double hessian_threshold, int octaves, int octave_layers, int extended, int upright, IpcvKeypointMatrix *keypoints)
{
    if (keypoints == NULL)
    {
        return -1;
    }

    std::memset(keypoints, 0, sizeof(*keypoints));
    try
    {
        cv::Ptr<cv::xfeatures2d::SURF> detector = cv::xfeatures2d::SURF::create(hessian_threshold, octaves, octave_layers, extended != 0, upright != 0);
        return run_detector(source, detector, keypoints, "missing SURF image input");
    }
    catch (const cv::Exception& e)
    {
        set_error(keypoints, e.what());
        return -1;
    }
    catch (const std::exception& e)
    {
        set_error(keypoints, e.what());
        return -1;
    }
    catch (...)
    {
        set_error(keypoints, "unknown SURF detector failure");
        return -1;
    }
}

extern "C" IPCV_CORE_API int ipcv_compute_brisk_descriptors(const IpcvDecodedImage *source, const IpcvKeypointMatrix *keypoints, IpcvDecodedImage *descriptors)
{
    cv::Ptr<cv::xfeatures2d::BRISK> extractor = cv::xfeatures2d::BRISK::create();
    return run_descriptor_extractor(source, keypoints, extractor, descriptors, "missing BRISK descriptor input");
}

extern "C" IPCV_CORE_API int ipcv_compute_orb_descriptors(const IpcvDecodedImage *source, const IpcvKeypointMatrix *keypoints, IpcvDecodedImage *descriptors)
{
    cv::Ptr<cv::ORB> extractor = cv::ORB::create();
    return run_descriptor_extractor(source, keypoints, extractor, descriptors, "missing ORB descriptor input");
}

extern "C" IPCV_CORE_API int ipcv_compute_sift_descriptors(const IpcvDecodedImage *source, const IpcvKeypointMatrix *keypoints, IpcvDecodedImage *descriptors)
{
    cv::Ptr<cv::SIFT> extractor = cv::SIFT::create();
    return run_descriptor_extractor(source, keypoints, extractor, descriptors, "missing SIFT descriptor input");
}

extern "C" IPCV_CORE_API int ipcv_compute_surf_descriptors(const IpcvDecodedImage *source, const IpcvKeypointMatrix *keypoints, IpcvDecodedImage *descriptors)
{
    if (descriptors == NULL)
    {
        return -1;
    }

    std::memset(descriptors, 0, sizeof(*descriptors));
    try
    {
        cv::Ptr<cv::xfeatures2d::SURF> extractor = cv::xfeatures2d::SURF::create();
        return run_descriptor_extractor(source, keypoints, extractor, descriptors, "missing SURF descriptor input");
    }
    catch (const cv::Exception& e)
    {
        set_image_error(descriptors, e.what());
        return -1;
    }
    catch (const std::exception& e)
    {
        set_image_error(descriptors, e.what());
        return -1;
    }
    catch (...)
    {
        set_image_error(descriptors, "unknown SURF descriptor extraction failure");
        return -1;
    }
}

extern "C" IPCV_CORE_API int ipcv_match_bruteforce(const IpcvDecodedImage *left, const IpcvDecodedImage *right, int norm_type, IpcvMatchMatrix *matches)
{
    if (matches == NULL)
    {
        return -1;
    }

    std::memset(matches, 0, sizeof(*matches));
    if (left == NULL || right == NULL)
    {
        set_match_error(matches, "missing descriptor input");
        return -1;
    }

    try
    {
        cv::setNumThreads(1);
        cv::setUseOptimized(false);

        cv::Mat left_mat;
        cv::Mat right_mat;
        char error[256] = {0};
        if (!descriptor_to_mat(*left, left_mat, error) || !descriptor_to_mat(*right, right_mat, error))
        {
            set_match_error(matches, error);
            return -1;
        }
        if (left_mat.cols != right_mat.cols)
        {
            set_match_error(matches, "descriptor matrices must have the same number of columns");
            return -1;
        }

        cv::Mat prepared_left;
        cv::Mat prepared_right;
        if (!prepare_match_descriptors(left_mat, prepared_left, norm_type, error) || !prepare_match_descriptors(right_mat, prepared_right, norm_type, error))
        {
            set_match_error(matches, error);
            return -1;
        }

        int cv_norm = cv::NORM_L2;
        if (norm_type == 1)
        {
            cv_norm = cv::NORM_L1;
        }
        else if (norm_type == 2)
        {
            cv_norm = cv::NORM_L2;
        }
        else if (norm_type == 3)
        {
            cv_norm = cv::NORM_HAMMING;
        }
        else if (norm_type == 4)
        {
            cv_norm = cv::NORM_HAMMING2;
        }
        else
        {
            set_match_error(matches, "unsupported brute-force norm type");
            return -1;
        }

        std::vector<cv::DMatch> found;
        if (!prepared_left.empty() && !prepared_right.empty())
        {
            cv::BFMatcher matcher(cv_norm);
            matcher.match(prepared_left, prepared_right, found);
        }
        return set_matches(matches, found) ? 0 : -1;
    }
    catch (const cv::Exception& e)
    {
        ipcv_free_match_matrix(matches);
        set_match_error(matches, e.what());
        return -1;
    }
    catch (const std::exception& e)
    {
        ipcv_free_match_matrix(matches);
        set_match_error(matches, e.what());
        return -1;
    }
    catch (...)
    {
        ipcv_free_match_matrix(matches);
        set_match_error(matches, "unknown brute-force matching failure");
        return -1;
    }
}

extern "C" IPCV_CORE_API int ipcv_match_flann(const IpcvDecodedImage *left, const IpcvDecodedImage *right, IpcvMatchMatrix *matches)
{
    if (matches == NULL)
    {
        return -1;
    }

    std::memset(matches, 0, sizeof(*matches));
    if (left == NULL || right == NULL)
    {
        set_match_error(matches, "missing descriptor input");
        return -1;
    }

    try
    {
        cv::setNumThreads(1);
        cv::setUseOptimized(false);

        cv::Mat left_mat;
        cv::Mat right_mat;
        char error[256] = {0};
        if (!descriptor_to_mat(*left, left_mat, error) || !descriptor_to_mat(*right, right_mat, error))
        {
            set_match_error(matches, error);
            return -1;
        }
        if (left_mat.cols != right_mat.cols)
        {
            set_match_error(matches, "descriptor matrices must have the same number of columns");
            return -1;
        }

        cv::Mat prepared_left;
        cv::Mat prepared_right;
        left_mat.convertTo(prepared_left, CV_32F);
        right_mat.convertTo(prepared_right, CV_32F);

        std::vector<cv::DMatch> found;
        if (!prepared_left.empty() && !prepared_right.empty())
        {
            cv::FlannBasedMatcher matcher;
            matcher.match(prepared_left, prepared_right, found);
        }

        return set_matches(matches, found) ? 0 : -1;
    }
    catch (const cv::Exception& e)
    {
        ipcv_free_match_matrix(matches);
        set_match_error(matches, e.what());
        return -1;
    }
    catch (const std::exception& e)
    {
        ipcv_free_match_matrix(matches);
        set_match_error(matches, e.what());
        return -1;
    }
    catch (...)
    {
        ipcv_free_match_matrix(matches);
        set_match_error(matches, "unknown FLANN matching failure");
        return -1;
    }
}

extern "C" IPCV_CORE_API int ipcv_draw_matches(const IpcvDecodedImage *left_image, const IpcvDecodedImage *right_image, const IpcvKeypointMatrix *left_keypoints, const IpcvKeypointMatrix *right_keypoints, const IpcvMatchMatrix *matches, IpcvDecodedImage *output)
{
    if (output == NULL)
    {
        return -1;
    }

    std::memset(output, 0, sizeof(*output));
    if (left_image == NULL || right_image == NULL || left_keypoints == NULL || right_keypoints == NULL || matches == NULL)
    {
        set_image_error(output, "missing draw-matches input");
        return -1;
    }

    try
    {
        cv::setNumThreads(1);
        cv::setUseOptimized(false);

        cv::Mat left_mat;
        cv::Mat right_mat;
        char error[256] = {0};
        if (!image_to_mat(*left_image, left_mat, error) || !image_to_mat(*right_image, right_mat, error))
        {
            set_image_error(output, error);
            return -1;
        }

        std::vector<cv::KeyPoint> left_points = keypoint_matrix_to_vector(left_keypoints);
        std::vector<cv::KeyPoint> right_points = keypoint_matrix_to_vector(right_keypoints);
        std::vector<cv::DMatch> match_values = match_matrix_to_vector(matches);

        cv::Mat drawn;
        cv::drawMatches(left_mat, left_points, right_mat, right_points, match_values, drawn);
        return set_mat_image(output, drawn) ? 0 : -1;
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
        set_image_error(output, "unknown draw-matches failure");
        return -1;
    }
}

extern "C" IPCV_CORE_API void ipcv_free_keypoint_matrix(IpcvKeypointMatrix *keypoints)
{
    if (keypoints == NULL)
    {
        return;
    }

    std::free(keypoints->data);
    keypoints->data = NULL;
    keypoints->rows = 0;
    keypoints->cols = 0;
}

extern "C" IPCV_CORE_API void ipcv_free_match_matrix(IpcvMatchMatrix *matches)
{
    if (matches == NULL)
    {
        return;
    }

    std::free(matches->data);
    matches->data = NULL;
    matches->rows = 0;
    matches->cols = 0;
}
