#ifndef IPCV_FILTERING_H
#define IPCV_FILTERING_H

#include "ipcv_image_io.h"

#ifdef __cplusplus
extern "C" {
#endif

enum
{
    IPCV_FILTER_OUTPUT_SAME_DEPTH = 0,
    IPCV_FILTER_OUTPUT_DOUBLE = 1
};

IPCV_CORE_API int ipcv_filter2d_image(const IpcvDecodedImage *source, const IpcvDecodedImage *kernel, int output_depth_mode, IpcvDecodedImage *output);

#ifdef __cplusplus
}
#endif

#endif
