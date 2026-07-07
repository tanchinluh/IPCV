#ifndef IPCV_DNN_H
#define IPCV_DNN_H

#include "ipcv_image_io.h"

#ifdef __cplusplus
extern "C" {
#endif

#define IPCV_DNN_MAX_DIMS 8

typedef struct IpcvDnnTensor
{
    int ndims;
    int dims[IPCV_DNN_MAX_DIMS];
    int count;
    double *data;
    char error[1024];
} IpcvDnnTensor;

typedef struct IpcvStringList
{
    int count;
    char **items;
    char error[1024];
} IpcvStringList;

IPCV_CORE_API int ipcv_dnn_load(const char *model, const char *config, int model_type, int *handle, char *error, int error_size);
IPCV_CORE_API int ipcv_dnn_forward(int handle, const IpcvDecodedImage *source, int width, int height, const char *layer_name, double scale_factor, const double mean[3], int swap_rb, int crop, IpcvDnnTensor *output);
IPCV_CORE_API int ipcv_dnn_get_layer_names(int handle, IpcvStringList *names);
IPCV_CORE_API int ipcv_dnn_get_layer_count(int handle, int *count, char *error, int error_size);
IPCV_CORE_API int ipcv_dnn_get_param(int handle, const char *layer_name, int param_index, IpcvDnnTensor *output);
IPCV_CORE_API int ipcv_dnn_list(double *handles, int max_handles, int *count);
IPCV_CORE_API int ipcv_dnn_unload(int handle, char *error, int error_size);
IPCV_CORE_API void ipcv_dnn_unload_all(void);

IPCV_CORE_API int ipcv_dnn_superres_load(const char *model, int scale, int algorithm_type, int *handle, char *error, int error_size);
IPCV_CORE_API int ipcv_dnn_superres_upsample(int handle, const IpcvDecodedImage *source, IpcvDecodedImage *output);
IPCV_CORE_API void ipcv_dnn_free_tensor(IpcvDnnTensor *tensor);
IPCV_CORE_API void ipcv_free_string_list(IpcvStringList *list);

#ifdef __cplusplus
}
#endif

#endif
