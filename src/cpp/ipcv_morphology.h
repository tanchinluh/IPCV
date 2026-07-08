#ifndef IPCV_MORPHOLOGY_H
#define IPCV_MORPHOLOGY_H

#include "ipcv_image_io.h"

#ifdef __cplusplus
extern "C" {
#endif

IPCV_CORE_API int ipcv_create_structuring_element(int shape, int rows, int cols, IpcvDecodedImage *output);
IPCV_CORE_API int ipcv_morphology_image(const IpcvDecodedImage *source,
                                        const IpcvDecodedImage *element,
                                        int operation,
                                        int iterations,
                                        int anchor_row,
                                        int anchor_col,
                                        int border_type,
                                        int use_default_border_value,
                                        double border_value,
                                        IpcvDecodedImage *output);
IPCV_CORE_API int ipcv_thin_image(const IpcvDecodedImage *source, int thinning_type, IpcvDecodedImage *output);

#ifdef __cplusplus
}
#endif

#endif
