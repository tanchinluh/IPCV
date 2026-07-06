#ifndef IPCV_BINARY_ANALYSIS_H
#define IPCV_BINARY_ANALYSIS_H

#include "ipcv_image_io.h"

#ifdef __cplusplus
extern "C" {
#endif

IPCV_CORE_API int ipcv_distance_l1_image(const IpcvDecodedImage *source, IpcvDecodedImage *output);
IPCV_CORE_API int ipcv_distance_transform_image(const IpcvDecodedImage *source, int method, IpcvDecodedImage *output);
IPCV_CORE_API int ipcv_fill_binary_image(const IpcvDecodedImage *source, IpcvDecodedImage *output);
IPCV_CORE_API int ipcv_label_binary_image(const IpcvDecodedImage *source, IpcvDecodedImage *output);

#ifdef __cplusplus
}
#endif

#endif
