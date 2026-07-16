#ifndef IPCV_REGISTRATION_H
#define IPCV_REGISTRATION_H

#include "ipcv_image_io.h"

#ifdef __cplusplus
extern "C" {
#endif

IPCV_CORE_API int ipcv_phase_register_image(const IpcvDecodedImage *target,
    const IpcvDecodedImage *source, IpcvDecodedImage *registered_image,
    double translation[2], double *rotation_degrees, double *scale_value);

enum IpcvTemplateMatchMethod
{
    IPCV_TEMPLATE_CCORR = 0,
    IPCV_TEMPLATE_CCORR_NORMED = 1,
    IPCV_TEMPLATE_CCOEFF = 2,
    IPCV_TEMPLATE_CCOEFF_NORMED = 3
};

IPCV_CORE_API int ipcv_template_match_image(const IpcvDecodedImage *source,
    const IpcvDecodedImage *templ, int method, IpcvDecodedImage *score);

#ifdef __cplusplus
}
#endif

#endif
