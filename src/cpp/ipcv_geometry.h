#ifndef IPCV_GEOMETRY_H
#define IPCV_GEOMETRY_H

#include "ipcv_structural_analysis.h"

#ifdef __cplusplus
extern "C" {
#endif

IPCV_CORE_API int ipcv_solve_pnp(const double *object_points, int object_rows, int object_cols,
    const double *image_points, int image_rows, int image_cols,
    const double *camera_matrix, int camera_rows, int camera_cols,
    const double *distortion, int distortion_rows, int distortion_cols,
    IpcvDoubleMatrix *rvec, IpcvDoubleMatrix *tvec);
IPCV_CORE_API int ipcv_estimate_fundamental(const double *points1, int points1_rows, int points1_cols,
    const double *points2, int points2_rows, int points2_cols, IpcvDoubleMatrix *fundamental);
IPCV_CORE_API int ipcv_triangulate(const double *points1, int points1_rows, int points1_cols,
    const double *points2, int points2_rows, int points2_cols,
    const double *projection1, int projection1_rows, int projection1_cols,
    const double *projection2, int projection2_rows, int projection2_cols,
    IpcvDoubleMatrix *points3d);

#ifdef __cplusplus
}
#endif

#endif
