#ifndef IPCV_GATEWAY_IMAGE_H
#define IPCV_GATEWAY_IMAGE_H

#include "ipcv_arithmetic.h"
#include "ipcv_image_io.h"
#include "ipcv_spatial_transform.h"

int ipcv_get_image_argument(void* pvApiCtx, int nPos, IpcvDecodedImage& image);
int ipcv_set_image_argument(void* pvApiCtx, int nPos, const IpcvDecodedImage& image);
int ipcv_run_binary_arithmetic(char *fname, void* pvApiCtx, int operation);
size_t ipcv_depth_size(int depth);

#endif
