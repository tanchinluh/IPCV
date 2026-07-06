#ifndef IPCV_IMAGE_IO_H
#define IPCV_IMAGE_IO_H

#include <stddef.h>

#ifdef _WIN32
#ifdef IPCV_CORE_EXPORTS
#define IPCV_CORE_API __declspec(dllexport)
#else
#define IPCV_CORE_API __declspec(dllimport)
#endif
#else
#define IPCV_CORE_API
#endif

#ifdef __cplusplus
extern "C" {
#endif

typedef struct IpcvDecodedImage
{
    int rows;
    int cols;
    int channels;
    int depth;
    size_t byte_count;
    unsigned char *data;
    char error[1024];
} IpcvDecodedImage;

typedef struct IpcvDecodedImageStack
{
    int rows;
    int cols;
    int channels;
    int pages;
    int depth;
    size_t byte_count;
    unsigned char *data;
    char error[1024];
} IpcvDecodedImageStack;

typedef struct IpcvImageList
{
    int count;
    IpcvDecodedImage *images;
    char error[1024];
} IpcvImageList;

typedef struct IpcvImageInfo
{
    int width;
    int height;
    int depth;
    int channels;
    char error[1024];
} IpcvImageInfo;

enum
{
    IPCV_DEPTH_8U = 0,
    IPCV_DEPTH_8S = 1,
    IPCV_DEPTH_16U = 2,
    IPCV_DEPTH_16S = 3,
    IPCV_DEPTH_32S = 4,
    IPCV_DEPTH_32F = 5,
    IPCV_DEPTH_64F = 6
};

IPCV_CORE_API int ipcv_decode_image(const char *filename, int flags, IpcvDecodedImage *image);
IPCV_CORE_API int ipcv_decode_image_stack(const char *filename, int flags, IpcvDecodedImageStack *stack);
IPCV_CORE_API int ipcv_image_info(const char *filename, int flags, IpcvImageInfo *info);
IPCV_CORE_API int ipcv_write_image(const char *filename, const unsigned char *data, int rows, int cols, int channels, int depth, int jpeg_quality, char *error, size_t error_size);
IPCV_CORE_API void ipcv_free_decoded_image(IpcvDecodedImage *image);
IPCV_CORE_API void ipcv_free_decoded_image_stack(IpcvDecodedImageStack *stack);

#ifdef __cplusplus
}
#endif

#endif
