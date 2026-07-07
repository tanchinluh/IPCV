#ifndef IPCV_HOUGH_H
#define IPCV_HOUGH_H

#include "ipcv_image_io.h"

#ifdef __cplusplus
extern "C" {
#endif

typedef struct IpcvCircleMatrix
{
    int rows;
    int cols;
    double *data;
    char error[1024];
} IpcvCircleMatrix;

IPCV_CORE_API int ipcv_hough_lines_overlay(const IpcvDecodedImage *source, IpcvDecodedImage *output);
IPCV_CORE_API int ipcv_hough_circles(const IpcvDecodedImage *source, IpcvCircleMatrix *circles);
IPCV_CORE_API void ipcv_free_circle_matrix(IpcvCircleMatrix *circles);

#ifdef __cplusplus
}
#endif

#endif
