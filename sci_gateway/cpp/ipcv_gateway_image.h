#ifndef IPCV_GATEWAY_IMAGE_H
#define IPCV_GATEWAY_IMAGE_H

#include "ipcv_arithmetic.h"
#include "ipcv_binary_analysis.h"
#include "ipcv_color.h"
#include "ipcv_edge_filter.h"
#include "ipcv_enhancement.h"
#include "ipcv_filtering.h"
#include "ipcv_image_io.h"
#include "ipcv_image_transform.h"
#include "ipcv_morphology.h"
#include "ipcv_segmentation.h"
#include "ipcv_spatial_transform.h"
#include "ipcv_structural_analysis.h"

int ipcv_get_image_argument(void* pvApiCtx, int nPos, IpcvDecodedImage& image);
void ipcv_release_image_argument(IpcvDecodedImage& image);
int ipcv_set_image_argument(void* pvApiCtx, int nPos, const IpcvDecodedImage& image);
int ipcv_set_image_stack_argument(void* pvApiCtx, int nPos, const IpcvDecodedImageStack& stack);
int ipcv_get_contour_list_argument(void* pvApiCtx, int nPos, IpcvContourList& list);
void ipcv_release_contour_list_argument(IpcvContourList& list);
int ipcv_set_contour_list_argument(void* pvApiCtx, int nPos, const IpcvContourList& list);
int ipcv_run_binary_arithmetic(char *fname, void* pvApiCtx, int operation);
size_t ipcv_depth_size(int depth);

#endif
