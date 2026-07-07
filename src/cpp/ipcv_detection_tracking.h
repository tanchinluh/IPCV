#ifndef IPCV_DETECTION_TRACKING_H
#define IPCV_DETECTION_TRACKING_H

#include "ipcv_image_io.h"

#ifdef __cplusplus
extern "C" {
#endif

typedef struct IpcvRectMatrix
{
    int rows;
    int cols;
    double *data;
    char error[1024];
} IpcvRectMatrix;

IPCV_CORE_API int ipcv_detect_objects(const IpcvDecodedImage *source, const char *cascade_filename, double scale_factor, int min_neighbors, const double *min_size, const double *max_size, IpcvRectMatrix *objects);
IPCV_CORE_API int ipcv_tracker_init(const IpcvDecodedImage *source, const double *bbox, int tracker_type, int *tracker_id, char *error, int error_size);
IPCV_CORE_API int ipcv_tracker_update(int tracker_id, const IpcvDecodedImage *source, IpcvRectMatrix *bbox);
IPCV_CORE_API void ipcv_tracker_unload_all(void);
IPCV_CORE_API void ipcv_free_rect_matrix(IpcvRectMatrix *rects);

#ifdef __cplusplus
}
#endif

#endif
