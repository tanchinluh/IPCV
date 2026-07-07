#ifndef IPCV_SUPERRES_H
#define IPCV_SUPERRES_H

#include "ipcv_image_io.h"

#ifdef __cplusplus
extern "C" {
#endif

IPCV_CORE_API int ipcv_superres_btv(const IpcvImageList *images, int scale_factor, int iterations, float beta, float lambda, float alpha, IpcvDecodedImage *output);

#ifdef __cplusplus
}
#endif

#endif
