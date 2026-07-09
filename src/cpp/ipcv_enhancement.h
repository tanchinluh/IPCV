#ifndef IPCV_ENHANCEMENT_H
#define IPCV_ENHANCEMENT_H

#include "ipcv_image_io.h"

#ifdef __cplusplus
extern "C" {
#endif

enum
{
    IPCV_DCT_FORWARD = 0,
    IPCV_DCT_INVERSE = 1
};

IPCV_CORE_API int ipcv_dct_image(const IpcvDecodedImage *source, int direction, IpcvDecodedImage *output);
IPCV_CORE_API int ipcv_clahe_image(const IpcvDecodedImage *source, double clip_limit, IpcvDecodedImage *output);
IPCV_CORE_API int ipcv_denoise_image(const IpcvDecodedImage *source, double h, double h_color, int template_window_size, int search_window_size, IpcvDecodedImage *output);
IPCV_CORE_API int ipcv_inpaint_image(const IpcvDecodedImage *source, const IpcvDecodedImage *mask, double radius, int method, IpcvDecodedImage *output);

#ifdef __cplusplus
}
#endif

#endif
