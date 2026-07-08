#ifndef IPCV_COLOR_H
#define IPCV_COLOR_H

#include "ipcv_image_io.h"

#ifdef __cplusplus
extern "C" {
#endif

enum
{
    IPCV_COLOR_RGB2GRAY = 0,
    IPCV_COLOR_RGB2LAB = 1,
    IPCV_COLOR_BGR2LAB = 2,
    IPCV_COLOR_RGB2HSV = 3,
    IPCV_COLOR_HSV2RGB = 4,
    IPCV_COLOR_RGB2YCRCB = 5,
    IPCV_COLOR_YCRCB2RGB = 6,
    IPCV_COLOR_LAB2RGB = 7,
    IPCV_COLOR_GRAY2RGB = 8,
    IPCV_COLOR_RGB2HLS = 9,
    IPCV_COLOR_HLS2RGB = 10,
    IPCV_COLOR_RGB2XYZ = 11,
    IPCV_COLOR_XYZ2RGB = 12,
    IPCV_COLOR_RGB2LUV = 13,
    IPCV_COLOR_LUV2RGB = 14,
    IPCV_COLOR_RGB2YUV = 15,
    IPCV_COLOR_YUV2RGB = 16
};

IPCV_CORE_API int ipcv_convert_color_image(const IpcvDecodedImage *source, int conversion, IpcvDecodedImage *output);

#ifdef __cplusplus
}
#endif

#endif
