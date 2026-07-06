#ifndef IPCV_STITCHING_H
#define IPCV_STITCHING_H

#include "ipcv_image_io.h"

#ifdef __cplusplus
extern "C" {
#endif

IPCV_CORE_API int ipcv_stitch_images(const IpcvImageList *images, double registration_resol, double seam_estimation_resol, double compositing_resol, double pano_confidence_thresh, int wave_correction, int blender_bands, IpcvDecodedImage *output);

#ifdef __cplusplus
}
#endif

#endif
