#ifndef IPCV_FEATURE_DETECTION_H
#define IPCV_FEATURE_DETECTION_H

#include "ipcv_image_io.h"

#ifdef __cplusplus
extern "C" {
#endif

typedef struct IpcvKeypointMatrix
{
    int rows;
    int cols;
    double *data;
    char error[1024];
} IpcvKeypointMatrix;

IPCV_CORE_API int ipcv_detect_fast(const IpcvDecodedImage *source, double threshold, int nonmax_suppression, int type, IpcvKeypointMatrix *keypoints);
IPCV_CORE_API int ipcv_detect_gftt(const IpcvDecodedImage *source, int max_corners, double quality_level, double min_distance, int block_size, double k, IpcvKeypointMatrix *keypoints);
IPCV_CORE_API int ipcv_detect_mser(const IpcvDecodedImage *source, int delta, int min_area, int max_area, double max_variation, double min_diversity, int max_evolution, double area_threshold, double min_margin, int edge_blur_size, IpcvKeypointMatrix *keypoints);
IPCV_CORE_API int ipcv_detect_orb(const IpcvDecodedImage *source, int nfeatures, double scale_factor, int nlevels, int edge_threshold, int first_level, int wta_k, int score_type, int patch_size, IpcvKeypointMatrix *keypoints);
IPCV_CORE_API void ipcv_free_keypoint_matrix(IpcvKeypointMatrix *keypoints);

#ifdef __cplusplus
}
#endif

#endif
