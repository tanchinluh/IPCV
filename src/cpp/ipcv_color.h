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
    IPCV_COLOR_LAB2RGB = 7
};

IPCV_CORE_API int ipcv_convert_color_image(const IpcvDecodedImage *source, int conversion, IpcvDecodedImage *output);

#ifdef __cplusplus
}
#endif

#endif
