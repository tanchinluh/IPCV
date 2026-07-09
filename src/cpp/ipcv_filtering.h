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
IPCV_CORE_API int ipcv_blur_image(const IpcvDecodedImage *source, int kernel_rows, int kernel_cols, IpcvDecodedImage *output);
IPCV_CORE_API int ipcv_gaussian_blur_image(const IpcvDecodedImage *source, int kernel_rows, int kernel_cols, double sigma_x, double sigma_y, IpcvDecodedImage *output);
IPCV_CORE_API int ipcv_bilateral_filter_image(const IpcvDecodedImage *source, int diameter, double sigma_color, double sigma_space, IpcvDecodedImage *output);

#ifdef __cplusplus
}
#endif

#endif
