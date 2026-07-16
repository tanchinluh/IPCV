#define IPCV_CORE_EXPORTS
#include "ipcv_video_camera.h"

#include <opencv2/core.hpp>
#include <opencv2/imgcodecs.hpp>
#include <opencv2/imgproc.hpp>
#include <opencv2/videoio.hpp>

#include <algorithm>
#include <cstdlib>
#include <cstring>
#include <exception>

namespace
{
struct VideoSlot
{
    cv::VideoCapture cap;
    cv::VideoWriter writer;
    int is_writer;
    int width;
    int height;
    char filename[2048];
};

VideoSlot avi_slots[IPCV_MAX_VIDEO_HANDLES];
VideoSlot cam_slots[IPCV_MAX_VIDEO_HANDLES];

void copy_error(char *destination, int destination_size, const char *message)
{
    if (destination == NULL || destination_size <= 0)
    {
        return;
    }

    std::strncpy(destination, message, static_cast<size_t>(destination_size) - 1);
    destination[destination_size - 1] = 0;
}

void set_image_error(IpcvDecodedImage *image, const char *message)
{
    if (image == NULL)
    {
        return;
    }

    copy_error(image->error, static_cast<int>(sizeof(image->error)), message);
}

void set_info_error(IpcvVideoInfo *info, const char *message)
{
    if (info == NULL)
    {
        return;
    }

    copy_error(info->error, static_cast<int>(sizeof(info->error)), message);
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
    image->depth = mat.depth();
    const size_t elem_bytes = mat.elemSize1();
    image->byte_count = static_cast<size_t>(image->rows) * image->cols * image->channels * elem_bytes;
    image->data = static_cast<unsigned char*>(std::calloc(image->byte_count == 0 ? 1 : image->byte_count, 1));
    if (image->data == NULL)
    {
        set_image_error(image, "out of memory");
        return false;
    }

    copy_mat_to_scilab_layout(mat, image->data);
    return true;
}

int find_free_slot(VideoSlot *slots)
{
    for (int i = 0; i < IPCV_MAX_VIDEO_HANDLES; i++)
    {
        if (!slots[i].cap.isOpened() && !slots[i].writer.isOpened())
        {
            return i;
        }
    }
    return -1;
}

bool valid_handle(int handle)
{
    return handle >= 1 && handle <= IPCV_MAX_VIDEO_HANDLES;
}

void reset_slot(VideoSlot& slot)
{
    if (slot.cap.isOpened())
    {
        slot.cap.release();
    }
    if (slot.writer.isOpened())
    {
        slot.writer.release();
    }
    slot.is_writer = 0;
    slot.width = 0;
    slot.height = 0;
    slot.filename[0] = 0;
}

void set_filename(VideoSlot& slot, const char *filename)
{
    std::strncpy(slot.filename, filename == NULL ? "" : filename, sizeof(slot.filename) - 1);
    slot.filename[sizeof(slot.filename) - 1] = 0;
}

bool prepare_writer_frame(const IpcvDecodedImage *frame, int width, int height, cv::Mat& output, char *error, int error_size)
{
    if (frame == NULL)
    {
        copy_error(error, error_size, "missing video frame input");
        return false;
    }

    cv::Mat image;
    if (!image_to_mat(*frame, image, error, error_size))
    {
        return false;
    }

    if (image.depth() != CV_8U)
    {
        copy_error(error, error_size, "the input image must be UINT8");
        return false;
    }

    if (image.channels() == 1)
    {
        cv::cvtColor(image, output, cv::COLOR_GRAY2BGR);
    }
    else if (image.channels() == 3)
    {
        output = image;
    }
    else if (image.channels() == 4)
    {
        cv::cvtColor(image, output, cv::COLOR_BGRA2BGR);
    }
    else
    {
        copy_error(error, error_size, "video frame must be one-, three-, or four-channel");
        return false;
    }

    if (output.cols != width || output.rows != height)
    {
        cv::resize(output, output, cv::Size(width, height), 0, 0, cv::INTER_LINEAR);
    }

    return true;
}
}

extern "C" IPCV_CORE_API int ipcv_avi_open(const char *filename, int *handle, char *error, int error_size)
{
    if (handle != NULL)
    {
        *handle = -1;
    }
    if (filename == NULL || handle == NULL)
    {
        copy_error(error, error_size, "missing video filename");
        return -1;
    }

    const int slot = find_free_slot(avi_slots);
    if (slot < 0)
    {
        copy_error(error, error_size, "too many video files opened");
        return -1;
    }

    avi_slots[slot].cap = cv::VideoCapture(filename);
    if (!avi_slots[slot].cap.isOpened())
    {
        reset_slot(avi_slots[slot]);
        copy_error(error, error_size, "cannot open video file");
        return -1;
    }

    avi_slots[slot].is_writer = 0;
    set_filename(avi_slots[slot], filename);
    *handle = slot + 1;
    return 0;
}

extern "C" IPCV_CORE_API int ipcv_avi_create(const char *filename, int width, int height, int fps, int codec, int *handle, char *error, int error_size)
{
    if (handle != NULL)
    {
        *handle = -1;
    }
    if (filename == NULL || handle == NULL || width <= 0 || height <= 0 || fps <= 0)
    {
        copy_error(error, error_size, "invalid video writer input");
        return -1;
    }

    const int slot = find_free_slot(avi_slots);
    if (slot < 0)
    {
        copy_error(error, error_size, "too many video files opened");
        return -1;
    }

    avi_slots[slot].writer = cv::VideoWriter(filename, codec, static_cast<double>(fps), cv::Size(width, height), true);
    if (!avi_slots[slot].writer.isOpened())
    {
        reset_slot(avi_slots[slot]);
        copy_error(error, error_size, "cannot create video file or codec is not supported");
        return -1;
    }

    avi_slots[slot].is_writer = 1;
    avi_slots[slot].width = width;
    avi_slots[slot].height = height;
    set_filename(avi_slots[slot], filename);
    *handle = slot + 1;
    return 0;
}

extern "C" IPCV_CORE_API int ipcv_avi_create_fourcc(const char *filename, int width, int height, int fps, const char *fourcc, int *handle, char *error, int error_size)
{
    if (fourcc == NULL || std::strlen(fourcc) < 4)
    {
        copy_error(error, error_size, "fourcc must contain at least four characters");
        return -1;
    }

    const int codec = cv::VideoWriter::fourcc(fourcc[0], fourcc[1], fourcc[2], fourcc[3]);
    return ipcv_avi_create(filename, width, height, fps, codec, handle, error, error_size);
}

extern "C" IPCV_CORE_API int ipcv_avi_add_frame(int handle, const IpcvDecodedImage *frame, char *error, int error_size)
{
    if (!valid_handle(handle))
    {
        copy_error(error, error_size, "video handle is out of range");
        return -1;
    }

    VideoSlot& slot = avi_slots[handle - 1];
    if (!slot.is_writer || !slot.writer.isOpened())
    {
        copy_error(error, error_size, "the opened file is not for writing");
        return -1;
    }

    cv::Mat image;
    if (!prepare_writer_frame(frame, slot.width, slot.height, image, error, error_size))
    {
        return -1;
    }

    slot.writer.write(image);
    return 0;
}

extern "C" IPCV_CORE_API int ipcv_avi_read_frame(int handle, int frame_index, int has_frame_index, IpcvDecodedImage *frame)
{
    if (frame == NULL)
    {
        return -1;
    }

    std::memset(frame, 0, sizeof(*frame));
    if (!valid_handle(handle))
    {
        set_image_error(frame, "video handle is out of range");
        return -1;
    }

    VideoSlot& slot = avi_slots[handle - 1];
    if (slot.is_writer)
    {
        set_image_error(frame, "the opened file is for writing");
        return -1;
    }
    if (!slot.cap.isOpened())
    {
        set_image_error(frame, "the video file is not opened");
        return -1;
    }
    if (has_frame_index && frame_index <= 0)
    {
        set_image_error(frame, "the frame index should be >= 1");
        return -1;
    }
    if (has_frame_index)
    {
        const double frame_count = slot.cap.get(cv::CAP_PROP_FRAME_COUNT);
        if (frame_count > 0 && frame_index > frame_count)
        {
            set_image_error(frame, "the frame index is greater than the frame count");
            return -1;
        }
        slot.cap.set(cv::CAP_PROP_POS_FRAMES, frame_index - 1);
    }

    cv::Mat image;
    slot.cap >> image;
    if (image.empty())
    {
        set_image_error(frame, "cannot read frame");
        return -1;
    }

    if (!mat_to_image(image, frame))
    {
        return -1;
    }

    return 0;
}

extern "C" IPCV_CORE_API int ipcv_avi_close(int handle, char *error, int error_size)
{
    if (!valid_handle(handle))
    {
        copy_error(error, error_size, "video handle is out of range");
        return -1;
    }

    VideoSlot& slot = avi_slots[handle - 1];
    if (!slot.cap.isOpened() && !slot.writer.isOpened())
    {
        copy_error(error, error_size, "the video file is not opened");
        return -1;
    }

    reset_slot(slot);
    return 0;
}

extern "C" IPCV_CORE_API int ipcv_avi_get_property(int handle, int property_id, double *value, char *error, int error_size)
{
    if (value != NULL)
    {
        *value = 0;
    }
    if (!valid_handle(handle))
    {
        copy_error(error, error_size, "video handle is out of range");
        return -1;
    }
    if (value == NULL)
    {
        copy_error(error, error_size, "missing property output");
        return -1;
    }

    VideoSlot& slot = avi_slots[handle - 1];
    if (slot.is_writer || !slot.cap.isOpened())
    {
        copy_error(error, error_size, "the opened file is not a readable video capture");
        return -1;
    }

    *value = slot.cap.get(property_id);
    return 0;
}

extern "C" IPCV_CORE_API int ipcv_avi_export_frame(int handle, int frame_index, const char *filename, char *error, int error_size)
{
    if (!valid_handle(handle))
    {
        copy_error(error, error_size, "video handle is out of range");
        return -1;
    }
    if (filename == NULL || filename[0] == 0)
    {
        copy_error(error, error_size, "missing output filename");
        return -1;
    }
    if (frame_index <= 0)
    {
        copy_error(error, error_size, "the frame index should be >= 1");
        return -1;
    }

    VideoSlot& slot = avi_slots[handle - 1];
    if (slot.is_writer || !slot.cap.isOpened())
    {
        copy_error(error, error_size, "the video file is not opened for reading");
        return -1;
    }

    const double frame_count = slot.cap.get(cv::CAP_PROP_FRAME_COUNT);
    if (frame_count > 0 && frame_index > frame_count)
    {
        copy_error(error, error_size, "the frame index is greater than the frame count");
        return -1;
    }

    slot.cap.set(cv::CAP_PROP_POS_FRAMES, frame_index - 1);
    cv::Mat image;
    slot.cap >> image;
    if (image.empty())
    {
        copy_error(error, error_size, "cannot read frame");
        return -1;
    }

    try
    {
        if (!cv::imwrite(filename, image))
        {
            copy_error(error, error_size, "cannot write decoded frame");
            return -1;
        }
    }
    catch (const cv::Exception& exception)
    {
        copy_error(error, error_size, exception.what());
        return -1;
    }

    return 0;
}

extern "C" IPCV_CORE_API int ipcv_avi_set_property(int handle, int property_id, double value, char *error, int error_size)
{
    if (!valid_handle(handle))
    {
        copy_error(error, error_size, "video handle is out of range");
        return -1;
    }

    VideoSlot& slot = avi_slots[handle - 1];
    if (slot.is_writer || !slot.cap.isOpened())
    {
        copy_error(error, error_size, "the opened file is not a readable video capture");
        return -1;
    }
    if (!slot.cap.set(property_id, value))
    {
        copy_error(error, error_size, "the video property is not supported by this backend");
        return -1;
    }

    return 0;
}

extern "C" IPCV_CORE_API void ipcv_avi_close_all(void)
{
    for (int i = 0; i < IPCV_MAX_VIDEO_HANDLES; i++)
    {
        reset_slot(avi_slots[i]);
    }
}

extern "C" IPCV_CORE_API void ipcv_avi_list_opened(IpcvVideoIndexList *list)
{
    if (list == NULL)
    {
        return;
    }

    std::memset(list, 0, sizeof(*list));
    for (int i = 0; i < IPCV_MAX_VIDEO_HANDLES; i++)
    {
        if (avi_slots[i].cap.isOpened() || avi_slots[i].writer.isOpened())
        {
            list->indices[list->count] = i + 1;
            list->count++;
        }
    }
}

extern "C" IPCV_CORE_API int ipcv_avi_info(const char *filename, IpcvVideoInfo *info)
{
    if (info == NULL)
    {
        return -1;
    }

    std::memset(info, 0, sizeof(*info));
    if (filename == NULL)
    {
        set_info_error(info, "missing video filename");
        return -1;
    }

    cv::VideoCapture cap(filename);
    if (!cap.isOpened())
    {
        set_info_error(info, "cannot open video file");
        return -1;
    }

    info->frames = cap.get(cv::CAP_PROP_FRAME_COUNT);
    info->width = cap.get(cv::CAP_PROP_FRAME_WIDTH);
    info->height = cap.get(cv::CAP_PROP_FRAME_HEIGHT);
    info->fps = cap.get(cv::CAP_PROP_FPS);
    return 0;
}

extern "C" IPCV_CORE_API int ipcv_cam_open(int camera_index, const int *size, int has_size, int *handle, double *width, double *height, char *error, int error_size)
{
    if (handle != NULL)
    {
        *handle = -1;
    }
    if (handle == NULL)
    {
        copy_error(error, error_size, "missing camera handle output");
        return -1;
    }

    const int slot = find_free_slot(cam_slots);
    if (slot < 0)
    {
        copy_error(error, error_size, "too many cameras opened");
        return -1;
    }

    cam_slots[slot].cap = cv::VideoCapture(camera_index);
    if (!cam_slots[slot].cap.isOpened())
    {
        reset_slot(cam_slots[slot]);
        copy_error(error, error_size, "cannot open camera");
        return -1;
    }

    if (has_size && size != NULL)
    {
        cam_slots[slot].cap.set(cv::CAP_PROP_FRAME_WIDTH, size[0]);
        cam_slots[slot].cap.set(cv::CAP_PROP_FRAME_HEIGHT, size[1]);
    }

    cam_slots[slot].is_writer = 0;
    set_filename(cam_slots[slot], "camera");
    *handle = slot + 1;
    if (width != NULL)
    {
        *width = cam_slots[slot].cap.get(cv::CAP_PROP_FRAME_WIDTH);
    }
    if (height != NULL)
    {
        *height = cam_slots[slot].cap.get(cv::CAP_PROP_FRAME_HEIGHT);
    }
    return 0;
}

extern "C" IPCV_CORE_API int ipcv_cam_read(int handle, IpcvDecodedImage *frame)
{
    if (frame == NULL)
    {
        return -1;
    }

    std::memset(frame, 0, sizeof(*frame));
    if (!valid_handle(handle))
    {
        set_image_error(frame, "camera handle is out of range");
        return -1;
    }

    VideoSlot& slot = cam_slots[handle - 1];
    if (!slot.cap.isOpened())
    {
        set_image_error(frame, "camera is not opened");
        return -1;
    }

    cv::Mat image;
    slot.cap >> image;
    if (image.empty())
    {
        set_image_error(frame, "cannot read camera frame");
        return -1;
    }

    if (!mat_to_image(image, frame))
    {
        return -1;
    }

    return 0;
}

extern "C" IPCV_CORE_API int ipcv_cam_close(int handle, char *error, int error_size)
{
    if (!valid_handle(handle))
    {
        copy_error(error, error_size, "camera handle is out of range");
        return -1;
    }

    VideoSlot& slot = cam_slots[handle - 1];
    if (!slot.cap.isOpened())
    {
        copy_error(error, error_size, "camera is not opened");
        return -1;
    }

    reset_slot(slot);
    return 0;
}

extern "C" IPCV_CORE_API int ipcv_cam_get_property(int handle, int property_id, double *value, char *error, int error_size)
{
    if (value != NULL)
    {
        *value = 0;
    }
    if (!valid_handle(handle))
    {
        copy_error(error, error_size, "camera handle is out of range");
        return -1;
    }
    if (value == NULL)
    {
        copy_error(error, error_size, "missing property output");
        return -1;
    }

    VideoSlot& slot = cam_slots[handle - 1];
    if (!slot.cap.isOpened())
    {
        copy_error(error, error_size, "camera is not opened");
        return -1;
    }

    *value = slot.cap.get(property_id);
    return 0;
}

extern "C" IPCV_CORE_API int ipcv_cam_set_property(int handle, int property_id, double value, char *error, int error_size)
{
    if (!valid_handle(handle))
    {
        copy_error(error, error_size, "camera handle is out of range");
        return -1;
    }

    VideoSlot& slot = cam_slots[handle - 1];
    if (!slot.cap.isOpened())
    {
        copy_error(error, error_size, "camera is not opened");
        return -1;
    }
    if (!slot.cap.set(property_id, value))
    {
        copy_error(error, error_size, "the camera property is not supported by this backend");
        return -1;
    }

    return 0;
}

extern "C" IPCV_CORE_API void ipcv_cam_close_all(void)
{
    for (int i = 0; i < IPCV_MAX_VIDEO_HANDLES; i++)
    {
        reset_slot(cam_slots[i]);
    }
}

extern "C" IPCV_CORE_API void ipcv_cam_list_opened(IpcvVideoIndexList *list)
{
    if (list == NULL)
    {
        return;
    }

    std::memset(list, 0, sizeof(*list));
    for (int i = 0; i < IPCV_MAX_VIDEO_HANDLES; i++)
    {
        if (cam_slots[i].cap.isOpened())
        {
            list->indices[list->count] = i + 1;
            list->count++;
        }
    }
}
