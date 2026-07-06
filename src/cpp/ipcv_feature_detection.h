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

typedef struct IpcvMatchMatrix
{
    int rows;
    int cols;
    double *data;
    char error[1024];
} IpcvMatchMatrix;

IPCV_CORE_API int ipcv_detect_fast(const IpcvDecodedImage *source, double threshold, int nonmax_suppression, int type, IpcvKeypointMatrix *keypoints);
IPCV_CORE_API int ipcv_detect_brisk(const IpcvDecodedImage *source, int threshold, int octaves, double pattern_scale, IpcvKeypointMatrix *keypoints);
IPCV_CORE_API int ipcv_detect_gftt(const IpcvDecodedImage *source, int max_corners, double quality_level, double min_distance, int block_size, double k, IpcvKeypointMatrix *keypoints);
IPCV_CORE_API int ipcv_detect_mser(const IpcvDecodedImage *source, int delta, int min_area, int max_area, double max_variation, double min_diversity, int max_evolution, double area_threshold, double min_margin, int edge_blur_size, IpcvKeypointMatrix *keypoints);
IPCV_CORE_API int ipcv_detect_orb(const IpcvDecodedImage *source, int nfeatures, double scale_factor, int nlevels, int edge_threshold, int first_level, int wta_k, int score_type, int patch_size, IpcvKeypointMatrix *keypoints);
IPCV_CORE_API int ipcv_detect_star(const IpcvDecodedImage *source, int max_size, int response_threshold, int line_threshold_projected, int line_threshold_binarized, int suppress_nonmax_size, IpcvKeypointMatrix *keypoints);
IPCV_CORE_API int ipcv_detect_surf(const IpcvDecodedImage *source, double hessian_threshold, int octaves, int octave_layers, int extended, int upright, IpcvKeypointMatrix *keypoints);
IPCV_CORE_API int ipcv_compute_brisk_descriptors(const IpcvDecodedImage *source, const IpcvKeypointMatrix *keypoints, IpcvDecodedImage *descriptors);
IPCV_CORE_API int ipcv_compute_orb_descriptors(const IpcvDecodedImage *source, const IpcvKeypointMatrix *keypoints, IpcvDecodedImage *descriptors);
IPCV_CORE_API int ipcv_compute_sift_descriptors(const IpcvDecodedImage *source, const IpcvKeypointMatrix *keypoints, IpcvDecodedImage *descriptors);
IPCV_CORE_API int ipcv_compute_surf_descriptors(const IpcvDecodedImage *source, const IpcvKeypointMatrix *keypoints, IpcvDecodedImage *descriptors);
IPCV_CORE_API int ipcv_match_bruteforce(const IpcvDecodedImage *left, const IpcvDecodedImage *right, int norm_type, IpcvMatchMatrix *matches);
IPCV_CORE_API int ipcv_match_flann(const IpcvDecodedImage *left, const IpcvDecodedImage *right, IpcvMatchMatrix *matches);
IPCV_CORE_API int ipcv_draw_matches(const IpcvDecodedImage *left_image, const IpcvDecodedImage *right_image, const IpcvKeypointMatrix *left_keypoints, const IpcvKeypointMatrix *right_keypoints, const IpcvMatchMatrix *matches, IpcvDecodedImage *output);
IPCV_CORE_API void ipcv_free_keypoint_matrix(IpcvKeypointMatrix *keypoints);
IPCV_CORE_API void ipcv_free_match_matrix(IpcvMatchMatrix *matches);

#ifdef __cplusplus
}
#endif

#endif
