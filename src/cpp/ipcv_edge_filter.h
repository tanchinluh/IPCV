#ifndef IPCV_EDGE_FILTER_H
#define IPCV_EDGE_FILTER_H

#include "ipcv_image_io.h"

#ifdef __cplusplus
extern "C" {
#endif

IPCV_CORE_API int ipcv_sobel_image(const IpcvDecodedImage *source, int dx, int dy, IpcvDecodedImage *output);
IPCV_CORE_API int ipcv_canny_image(const IpcvDecodedImage *source, double low_threshold, double high_threshold, int aperture_size, IpcvDecodedImage *output);
IPCV_CORE_API int ipcv_median_image(const IpcvDecodedImage *source, int kernel_size, IpcvDecodedImage *output);

#ifdef __cplusplus
}
#endif

#endif
