#ifndef IPCV_STRUCTURAL_ANALYSIS_H
#define IPCV_STRUCTURAL_ANALYSIS_H

#include "ipcv_image_io.h"

#ifdef __cplusplus
extern "C" {
#endif

typedef struct IpcvContourList
{
    int count;
    int columns;
    int *rows;
    double *data;
    char error[1024];
} IpcvContourList;

typedef struct IpcvDoubleMatrix
{
    int rows;
    int cols;
    double *data;
    char error[1024];
} IpcvDoubleMatrix;

IPCV_CORE_API int ipcv_find_contours(const IpcvDecodedImage *source, int mode, int method, IpcvContourList *contours);
IPCV_CORE_API int ipcv_convex_hull(const IpcvContourList *contours, int clockwise, int return_indices, IpcvContourList *hulls);
IPCV_CORE_API int ipcv_convexity_defects(const IpcvContourList *contours, const IpcvContourList *hull_indices, IpcvContourList *defects);
IPCV_CORE_API int ipcv_contour_area(const IpcvContourList *contours, int oriented, IpcvDoubleMatrix *areas);
IPCV_CORE_API int ipcv_arc_length(const IpcvContourList *contours, int closed, IpcvDoubleMatrix *lengths);
IPCV_CORE_API int ipcv_bounding_rect(const IpcvDecodedImage *source, double rect[4], char *error, int error_size);
IPCV_CORE_API void ipcv_free_contour_list(IpcvContourList *contours);
IPCV_CORE_API void ipcv_free_double_matrix(IpcvDoubleMatrix *matrix);

#ifdef __cplusplus
}
#endif

#endif
