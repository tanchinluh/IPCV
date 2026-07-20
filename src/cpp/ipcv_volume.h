#ifndef IPCV_VOLUME_H
#define IPCV_VOLUME_H

#include "ipcv_image_io.h"

#ifdef __cplusplus
extern "C" {
#endif

typedef struct IpcvVolume
{
    int rows;
    int cols;
    int slices;
    int depth;
    size_t byte_count;
    unsigned char *data;
    int owns_data;
    char error[1024];
} IpcvVolume;

enum
{
    IPCV_VOLUME_ERODE = 0,
    IPCV_VOLUME_DILATE = 1,
    IPCV_VOLUME_OPEN = 2,
    IPCV_VOLUME_CLOSE = 3
};

IPCV_CORE_API int ipcv_label_volume(const IpcvVolume *source, int connectivity,
    IpcvVolume *labels, int *component_count);
IPCV_CORE_API int ipcv_regional_max_volume(const IpcvVolume *source,
    int connectivity, IpcvVolume *output);
IPCV_CORE_API int ipcv_box_filter_volume(const IpcvVolume *source,
    const int window[3], IpcvVolume *output);
IPCV_CORE_API int ipcv_gaussian_filter_volume(const IpcvVolume *source,
    double sigma, IpcvVolume *output);
IPCV_CORE_API int ipcv_median_filter_volume(const IpcvVolume *source,
    const int window[3], IpcvVolume *output);
IPCV_CORE_API int ipcv_binary_morphology_volume(const IpcvVolume *source,
    int operation, int iterations, int connectivity, IpcvVolume *output);
IPCV_CORE_API int ipcv_area_open_volume(const IpcvVolume *source,
    int minimum_size, int connectivity, IpcvVolume *output);
IPCV_CORE_API int ipcv_perimeter_volume(const IpcvVolume *source,
    int connectivity, IpcvVolume *output);
IPCV_CORE_API int ipcv_fill_volume(const IpcvVolume *source,
    int connectivity, IpcvVolume *output);
IPCV_CORE_API void ipcv_free_volume(IpcvVolume *volume);

#ifdef __cplusplus
}
#endif

#endif
