#include "ipcv_gateway_common.h"
#include "ipcv_gateway_image.h"

int sci_int_imdetect_HARRIS(char *fname, void *pvApiCtx)
{
    CheckInputArgument(pvApiCtx, 6, 6);
    CheckOutputArgument(pvApiCtx, 0, 1);
    IpcvDecodedImage image; IpcvKeypointMatrix keypoints; memset(&keypoints, 0, sizeof(keypoints));
    double *value = NULL; int rows = 0; int cols = 0;
    int ret = ipcv_get_image_argument(pvApiCtx, 1, image);
    if (ret) { Scierror(999, "%s: image expected.\n", fname); return ret; }
    GetDouble(2, value, rows, cols, pvApiCtx); int maxCorners = int(*value);
    GetDouble(3, value, rows, cols, pvApiCtx); double qualityLevel = *value;
    GetDouble(4, value, rows, cols, pvApiCtx); double minDistance = *value;
    GetDouble(5, value, rows, cols, pvApiCtx); int blockSize = int(*value);
    GetDouble(6, value, rows, cols, pvApiCtx); double k = *value;
    ret = ipcv_detect_harris(&image, maxCorners, qualityLevel, minDistance, blockSize, k, &keypoints);
    ipcv_release_image_argument(image);
    if (ret) { Scierror(999, "%s: %s\n", fname, keypoints.error); ipcv_free_keypoint_matrix(&keypoints); return ret; }
    ret = ipcv_set_keypoint_matrix_argument(pvApiCtx, 1, keypoints);
    ipcv_free_keypoint_matrix(&keypoints);
    return ret;
}
