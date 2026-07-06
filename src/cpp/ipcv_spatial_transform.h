#ifndef IPCV_SPATIAL_TRANSFORM_H
#define IPCV_SPATIAL_TRANSFORM_H

#include "ipcv_image_io.h"

#ifdef __cplusplus
extern "C" {
#endif

enum
{
    IPCV_INTER_NEAREST = 0,
    IPCV_INTER_LINEAR = 1,
    IPCV_INTER_CUBIC = 2,
    IPCV_INTER_AREA = 3,
    IPCV_INTER_LANCZOS = 4
};

enum
{
    IPCV_PYRAMID_REDUCE = 0,
    IPCV_PYRAMID_EXPAND = 1
};

IPCV_CORE_API int ipcv_resize_image(const IpcvDecodedImage *source, int target_rows, int target_cols, int interpolation, IpcvDecodedImage *output);
IPCV_CORE_API int ipcv_pyramid_image(const IpcvDecodedImage *source, int direction, IpcvDecodedImage *output);

#ifdef __cplusplus
}
#endif

#endif
