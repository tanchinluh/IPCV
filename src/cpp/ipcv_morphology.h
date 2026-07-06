#ifndef IPCV_MORPHOLOGY_H
#define IPCV_MORPHOLOGY_H

#include "ipcv_image_io.h"

#ifdef __cplusplus
extern "C" {
#endif

IPCV_CORE_API int ipcv_create_structuring_element(int shape, int rows, int cols, IpcvDecodedImage *output);
IPCV_CORE_API int ipcv_morphology_image(const IpcvDecodedImage *source, const IpcvDecodedImage *element, int operation, IpcvDecodedImage *output);

#ifdef __cplusplus
}
#endif

#endif
