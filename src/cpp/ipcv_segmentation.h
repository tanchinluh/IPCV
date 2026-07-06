#ifndef IPCV_SEGMENTATION_H
#define IPCV_SEGMENTATION_H

#include "ipcv_image_io.h"

#ifdef __cplusplus
extern "C" {
#endif

IPCV_CORE_API int ipcv_watershed_image(const IpcvDecodedImage *source, const IpcvDecodedImage *markers, int object_count, IpcvDecodedImage *color_output, IpcvDecodedImage *marker_output);

#ifdef __cplusplus
}
#endif

#endif
