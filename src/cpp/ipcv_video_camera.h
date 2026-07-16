#ifndef IPCV_VIDEO_CAMERA_H
#define IPCV_VIDEO_CAMERA_H

#include "ipcv_image_io.h"

#ifdef __cplusplus
extern "C" {
#endif

#define IPCV_MAX_VIDEO_HANDLES 32

typedef struct IpcvVideoInfo
{
    double frames;
    double width;
    double height;
    double fps;
    char error[1024];
} IpcvVideoInfo;

typedef struct IpcvVideoIndexList
{
    int count;
    double indices[IPCV_MAX_VIDEO_HANDLES];
    char error[1024];
} IpcvVideoIndexList;

IPCV_CORE_API int ipcv_avi_open(const char *filename, int *handle, char *error, int error_size);
IPCV_CORE_API int ipcv_avi_create(const char *filename, int width, int height, int fps, int codec, int *handle, char *error, int error_size);
IPCV_CORE_API int ipcv_avi_create_fourcc(const char *filename, int width, int height, int fps, const char *fourcc, int *handle, char *error, int error_size);
IPCV_CORE_API int ipcv_avi_add_frame(int handle, const IpcvDecodedImage *frame, char *error, int error_size);
IPCV_CORE_API int ipcv_avi_read_frame(int handle, int frame_index, int has_frame_index, IpcvDecodedImage *frame);
IPCV_CORE_API int ipcv_avi_export_frame(int handle, int frame_index, const char *filename, char *error, int error_size);
IPCV_CORE_API int ipcv_avi_get_property(int handle, int property_id, double *value, char *error, int error_size);
IPCV_CORE_API int ipcv_avi_set_property(int handle, int property_id, double value, char *error, int error_size);
IPCV_CORE_API int ipcv_avi_close(int handle, char *error, int error_size);
IPCV_CORE_API void ipcv_avi_close_all(void);
IPCV_CORE_API void ipcv_avi_list_opened(IpcvVideoIndexList *list);
IPCV_CORE_API int ipcv_avi_info(const char *filename, IpcvVideoInfo *info);

IPCV_CORE_API int ipcv_cam_open(int camera_index, const int *size, int has_size, int *handle, double *width, double *height, char *error, int error_size);
IPCV_CORE_API int ipcv_cam_read(int handle, IpcvDecodedImage *frame);
IPCV_CORE_API int ipcv_cam_get_property(int handle, int property_id, double *value, char *error, int error_size);
IPCV_CORE_API int ipcv_cam_set_property(int handle, int property_id, double value, char *error, int error_size);
IPCV_CORE_API int ipcv_cam_close(int handle, char *error, int error_size);
IPCV_CORE_API void ipcv_cam_close_all(void);
IPCV_CORE_API void ipcv_cam_list_opened(IpcvVideoIndexList *list);

#ifdef __cplusplus
}
#endif

#endif
