#ifndef IPCV_BINARY_ANALYSIS_H
#define IPCV_BINARY_ANALYSIS_H

#include "ipcv_image_io.h"
#include "ipcv_structural_analysis.h"

#ifdef __cplusplus
extern "C" {
#endif

IPCV_CORE_API int ipcv_distance_l1_image(const IpcvDecodedImage *source, IpcvDecodedImage *output);
IPCV_CORE_API int ipcv_distance_transform_image(const IpcvDecodedImage *source, int method, IpcvDecodedImage *output);
IPCV_CORE_API int ipcv_fill_binary_image(const IpcvDecodedImage *source, IpcvDecodedImage *output);
IPCV_CORE_API int ipcv_label_binary_image(const IpcvDecodedImage *source, IpcvDecodedImage *output);
IPCV_CORE_API int ipcv_threshold_image(const IpcvDecodedImage *source, double threshold, double max_value, int mode, IpcvDecodedImage *output, double *used_threshold);
IPCV_CORE_API int ipcv_connected_components(const IpcvDecodedImage *source, int connectivity, IpcvDecodedImage *labels, int *component_count, IpcvDoubleMatrix *stats, IpcvDoubleMatrix *centroids);

#ifdef __cplusplus
}
#endif

#endif
