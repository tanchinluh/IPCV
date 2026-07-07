#define IPCV_CORE_EXPORTS
#include "ipcv_detection_tracking.h"

#include <opencv2/core.hpp>
#include <opencv2/imgproc.hpp>
#include <opencv2/tracking.hpp>
#include <opencv2/tracking/tracking_legacy.hpp>
#include <opencv2/xobjdetect.hpp>

#include <algorithm>
#include <cmath>
#include <cstdlib>
#include <cstring>
#include <exception>
#include <vector>

namespace
{
const int kMaxTrackers = 3;
cv::Ptr<cv::Tracker> trackers[kMaxTrackers];

void copy_error(char *destination, int destination_size, const char *message)
{
    if (destination == NULL || destination_size <= 0)
    {
        return;
    }

    std::strncpy(destination, message, static_cast<size_t>(destination_size) - 1);
    destination[destination_size - 1] = 0;
}

void set_rect_error(IpcvRectMatrix *rects, const char *message)
{
    if (rects == NULL)
    {
        return;
    }

    copy_error(rects->error, static_cast<int>(sizeof(rects->error)), message);
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

bool image_to_mat(const IpcvDecodedImage& image, cv::Mat& mat, char *error, int error_size)
{
    const size_t elem_bytes = depth_size(image.depth);
    const size_t expected_bytes = static_cast<size_t>(image.rows) * image.cols * image.channels * elem_bytes;
    if (image.data == NULL || image.rows <= 0 || image.cols <= 0 || image.channels <= 0 || elem_bytes == 0 || image.byte_count != expected_bytes)
    {
        copy_error(error, error_size, "invalid image input");
        return false;
    }

    mat.create(image.rows, image.cols, CV_MAKETYPE(image.depth, image.channels));
    copy_scilab_layout_to_mat(image.data, mat);
    return true;
}

bool image_to_gray_8u(const IpcvDecodedImage& source, cv::Mat& gray, char *error, int error_size)
{
    cv::Mat image;
    if (!image_to_mat(source, image, error, error_size))
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
        copy_error(error, error_size, "object detection requires a one-, three-, or four-channel image");
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

bool image_to_tracker_mat(const IpcvDecodedImage& source, cv::Mat& image, char *error, int error_size)
{
    if (!image_to_mat(source, image, error, error_size))
    {
        return false;
    }

    if (image.depth() != CV_8U)
    {
        cv::Mat converted;
        image.convertTo(converted, CV_8U);
        image = converted;
    }

    if (image.channels() == 4)
    {
        cv::Mat bgr;
        cv::cvtColor(image, bgr, cv::COLOR_BGRA2BGR);
        image = bgr;
    }
    else if (image.channels() != 1 && image.channels() != 3)
    {
        copy_error(error, error_size, "tracker requires a one-, three-, or four-channel image");
        return false;
    }

    return true;
}

bool allocate_rect_matrix(IpcvRectMatrix *rects, int cols)
{
    if (rects == NULL)
    {
        return false;
    }

    rects->rows = 4;
    rects->cols = cols;
    const size_t count = static_cast<size_t>(rects->rows) * std::max(cols, 0);
    if (count == 0)
    {
        rects->data = NULL;
        return true;
    }

    rects->data = static_cast<double*>(std::calloc(count, sizeof(double)));
    if (rects->data == NULL)
    {
        set_rect_error(rects, "out of memory");
        return false;
    }

    return true;
}

cv::Ptr<cv::Tracker> create_tracker(int tracker_type)
{
    switch (tracker_type)
    {
    case 1:
        return cv::TrackerCSRT::create();
    case 2:
        return cv::TrackerKCF::create();
    case 3:
        return cv::legacy::upgradeTrackingAPI(cv::legacy::TrackerBoosting::create());
    case 4:
        return cv::TrackerMIL::create();
    case 5:
        return cv::legacy::upgradeTrackingAPI(cv::legacy::TrackerTLD::create());
    case 6:
        return cv::legacy::upgradeTrackingAPI(cv::legacy::TrackerMedianFlow::create());
    case 7:
        return cv::legacy::upgradeTrackingAPI(cv::legacy::TrackerMOSSE::create());
    default:
        return cv::Ptr<cv::Tracker>();
    }
}
}

extern "C" IPCV_CORE_API int ipcv_detect_objects(const IpcvDecodedImage *source, const char *cascade_filename, double scale_factor, int min_neighbors, const double *min_size, const double *max_size, IpcvRectMatrix *objects)
{
    if (objects == NULL)
    {
        return -1;
    }

    std::memset(objects, 0, sizeof(*objects));
    if (source == NULL || cascade_filename == NULL || min_size == NULL || max_size == NULL)
    {
        set_rect_error(objects, "missing object detection input");
        return -1;
    }

    try
    {
        cv::Mat gray;
        char error[256] = {0};
        if (!image_to_gray_8u(*source, gray, error, static_cast<int>(sizeof(error))))
        {
            set_rect_error(objects, error);
            return -1;
        }

        cv::CascadeClassifier classifier;
        if (!classifier.load(cascade_filename))
        {
            set_rect_error(objects, "could not load cascade classifier");
            return -1;
        }

        std::vector<cv::Rect> detections;
        const cv::Size min_sz(std::max(0, static_cast<int>(std::round(min_size[0]))), std::max(0, static_cast<int>(std::round(min_size[1]))));
        const cv::Size max_sz(std::max(0, static_cast<int>(std::round(max_size[0]))), std::max(0, static_cast<int>(std::round(max_size[1]))));
        classifier.detectMultiScale(gray, detections, scale_factor, min_neighbors, 0, min_sz, max_sz);

        if (!allocate_rect_matrix(objects, static_cast<int>(detections.size())))
        {
            return -1;
        }

        for (size_t i = 0; i < detections.size(); i++)
        {
            objects->data[i * 4 + 0] = detections[i].x;
            objects->data[i * 4 + 1] = detections[i].y;
            objects->data[i * 4 + 2] = detections[i].width;
            objects->data[i * 4 + 3] = detections[i].height;
        }

        return 0;
    }
    catch (const cv::Exception& e)
    {
        set_rect_error(objects, e.what());
        return -1;
    }
    catch (const std::exception& e)
    {
        set_rect_error(objects, e.what());
        return -1;
    }
}

extern "C" IPCV_CORE_API int ipcv_tracker_init(const IpcvDecodedImage *source, const double *bbox, int tracker_type, int *tracker_id, char *error, int error_size)
{
    if (tracker_id != NULL)
    {
        *tracker_id = -1;
    }
    if (source == NULL || bbox == NULL || tracker_id == NULL)
    {
        copy_error(error, error_size, "missing tracker initialization input");
        return -1;
    }

    try
    {
        cv::Mat image;
        if (!image_to_tracker_mat(*source, image, error, error_size))
        {
            return -1;
        }

        int slot = -1;
        for (int i = 0; i < kMaxTrackers; i++)
        {
            if (trackers[i].empty())
            {
                slot = i;
                break;
            }
        }
        if (slot < 0)
        {
            copy_error(error, error_size, "too many trackers loaded");
            return -1;
        }

        cv::Ptr<cv::Tracker> tracker = create_tracker(tracker_type);
        if (tracker.empty())
        {
            copy_error(error, error_size, "unsupported tracker type");
            return -1;
        }

        cv::Rect initial_box(
            static_cast<int>(std::round(bbox[0])),
            static_cast<int>(std::round(bbox[1])),
            static_cast<int>(std::round(bbox[2])),
            static_cast<int>(std::round(bbox[3])));
        if (initial_box.width <= 0 || initial_box.height <= 0)
        {
            copy_error(error, error_size, "tracker bounding box must have positive width and height");
            return -1;
        }

        tracker->init(image, initial_box);
        trackers[slot] = tracker;
        *tracker_id = slot + 1;
        return 0;
    }
    catch (const cv::Exception& e)
    {
        copy_error(error, error_size, e.what());
        return -1;
    }
    catch (const std::exception& e)
    {
        copy_error(error, error_size, e.what());
        return -1;
    }
}

extern "C" IPCV_CORE_API int ipcv_tracker_update(int tracker_id, const IpcvDecodedImage *source, IpcvRectMatrix *bbox)
{
    if (bbox == NULL)
    {
        return -1;
    }

    std::memset(bbox, 0, sizeof(*bbox));
    if (source == NULL)
    {
        set_rect_error(bbox, "missing tracker update image input");
        return -1;
    }

    const int slot = tracker_id - 1;
    if (slot < 0 || slot >= kMaxTrackers || trackers[slot].empty())
    {
        set_rect_error(bbox, "could not load tracker");
        return -1;
    }

    try
    {
        cv::Mat image;
        char error[256] = {0};
        if (!image_to_tracker_mat(*source, image, error, static_cast<int>(sizeof(error))))
        {
            set_rect_error(bbox, error);
            return -1;
        }

        cv::Rect updated_box;
        trackers[slot]->update(image, updated_box);
        if (!allocate_rect_matrix(bbox, 1))
        {
            return -1;
        }

        bbox->data[0] = updated_box.x;
        bbox->data[1] = updated_box.y;
        bbox->data[2] = updated_box.width;
        bbox->data[3] = updated_box.height;
        return 0;
    }
    catch (const cv::Exception& e)
    {
        set_rect_error(bbox, e.what());
        return -1;
    }
    catch (const std::exception& e)
    {
        set_rect_error(bbox, e.what());
        return -1;
    }
}

extern "C" IPCV_CORE_API void ipcv_tracker_unload_all(void)
{
    for (int i = 0; i < kMaxTrackers; i++)
    {
        trackers[i].release();
    }
}

extern "C" IPCV_CORE_API void ipcv_free_rect_matrix(IpcvRectMatrix *rects)
{
    if (rects == NULL)
    {
        return;
    }

    std::free(rects->data);
    rects->data = NULL;
    rects->rows = 0;
    rects->cols = 0;
    rects->error[0] = 0;
}
