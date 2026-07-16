#ifndef IPCV_SEGMENTATION_H
#define IPCV_SEGMENTATION_H

#include "ipcv_image_io.h"

#ifdef __cplusplus
extern "C" {
#endif

IPCV_CORE_API int ipcv_watershed_image(const IpcvDecodedImage *source, const IpcvDecodedImage *markers, int object_count, IpcvDecodedImage *color_output, IpcvDecodedImage *marker_output);
IPCV_CORE_API int ipcv_kmeans_image(const IpcvDecodedImage *source, int cluster_count, IpcvDecodedImage *labels, IpcvDecodedImage *centers);
IPCV_CORE_API int ipcv_grabcut_image(const IpcvDecodedImage *source, const double rect[4], int iterations, IpcvDecodedImage *mask, IpcvDecodedImage *foreground);
IPCV_CORE_API int ipcv_superpixels_image(const IpcvDecodedImage *source, int region_size, double ruler, int iterations, IpcvDecodedImage *labels, IpcvDecodedImage *contours);

#ifdef __cplusplus
}
#endif

#endif
