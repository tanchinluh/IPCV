#define IPCV_CORE_EXPORTS
#include "ipcv_feature_detection.h"

#include <opencv2/core.hpp>
#include <opencv2/features2d.hpp>
#include <opencv2/imgproc.hpp>

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
}

extern "C" IPCV_CORE_API int ipcv_detect_fast(const IpcvDecodedImage *source, double threshold, int nonmax_suppression, int type, IpcvKeypointMatrix *keypoints)
{
    cv::Ptr<cv::FastFeatureDetector> detector = cv::FastFeatureDetector::create(static_cast<int>(threshold), nonmax_suppression != 0, cv::FastFeatureDetector::DetectorType(type));
    return run_detector(source, detector, keypoints, "missing FAST image input");
}

extern "C" IPCV_CORE_API int ipcv_detect_gftt(const IpcvDecodedImage *source, int max_corners, double quality_level, double min_distance, int block_size, double k, IpcvKeypointMatrix *keypoints)
{
    cv::Ptr<cv::GFTTDetector> detector = cv::GFTTDetector::create(max_corners, quality_level, min_distance, block_size, false, k);
    return run_detector(source, detector, keypoints, "missing GFTT image input");
}

extern "C" IPCV_CORE_API int ipcv_detect_mser(const IpcvDecodedImage *source, int delta, int min_area, int max_area, double max_variation, double min_diversity, int max_evolution, double area_threshold, double min_margin, int edge_blur_size, IpcvKeypointMatrix *keypoints)
{
    cv::Ptr<cv::MSER> detector = cv::MSER::create(delta, min_area, max_area, max_variation, min_diversity, max_evolution, area_threshold, min_margin, edge_blur_size);
    return run_detector(source, detector, keypoints, "missing MSER image input");
}

extern "C" IPCV_CORE_API int ipcv_detect_orb(const IpcvDecodedImage *source, int nfeatures, double scale_factor, int nlevels, int edge_threshold, int first_level, int wta_k, int score_type, int patch_size, IpcvKeypointMatrix *keypoints)
{
    cv::Ptr<cv::ORB> detector = cv::ORB::create(nfeatures, static_cast<float>(scale_factor), nlevels, edge_threshold, first_level, wta_k, cv::ORB::ScoreType(score_type), patch_size);
    return run_detector(source, detector, keypoints, "missing ORB image input");
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
