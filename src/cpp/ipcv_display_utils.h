#ifndef IPCV_DISPLAY_UTILS_H
#define IPCV_DISPLAY_UTILS_H

#include "ipcv_image_io.h"

#ifdef __cplusplus
extern "C" {
#endif

typedef struct IpcvByteBuffer
{
    int count;
    unsigned char *data;
    char error[1024];
} IpcvByteBuffer;

IPCV_CORE_API int ipcv_display_image(const IpcvDecodedImage *source, const char *window_name, double *status, char *error, int error_size);
IPCV_CORE_API int ipcv_inspect_image(const IpcvDecodedImage *source, const char *window_name, char *error, int error_size);
IPCV_CORE_API int ipcv_image_to_utf(const IpcvDecodedImage *source, IpcvByteBuffer *output);
IPCV_CORE_API void ipcv_free_byte_buffer(IpcvByteBuffer *buffer);

#ifdef __cplusplus
}
#endif

#endif
