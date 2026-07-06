#ifndef IPCV_IMAGE_TRANSFORM_H
#define IPCV_IMAGE_TRANSFORM_H

#include "ipcv_image_io.h"

#ifdef __cplusplus
extern "C" {
#endif

typedef struct IpcvRadonResult
{
    int projection_rows;
    int projection_cols;
    double *projection;
    int radius_count;
    double *radius;
    char error[1024];
} IpcvRadonResult;

IPCV_CORE_API int ipcv_radon_transform(const double *image, int rows, int cols, const double *theta_degrees, int theta_count, IpcvRadonResult *result);
IPCV_CORE_API void ipcv_free_radon_result(IpcvRadonResult *result);

#ifdef __cplusplus
}
#endif

#endif
