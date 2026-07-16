#include "ipcv_gateway_common.h"
#include "ipcv_gateway_image.h"

int sci_int_imdetect_KAZE(char *fname, void *pvApiCtx)
{
    CheckInputArgument(pvApiCtx, 1, 1); CheckOutputArgument(pvApiCtx, 0, 1);
    IpcvDecodedImage image; IpcvKeypointMatrix keypoints; memset(&keypoints, 0, sizeof(keypoints));
    int ret = ipcv_get_image_argument(pvApiCtx, 1, image);
    if (ret) { Scierror(999, "%s: image expected.\n", fname); return ret; }
    ret = ipcv_detect_kaze(&image, &keypoints); ipcv_release_image_argument(image);
    if (ret) { Scierror(999, "%s: %s\n", fname, keypoints.error); ipcv_free_keypoint_matrix(&keypoints); return ret; }
    ret = ipcv_set_keypoint_matrix_argument(pvApiCtx, 1, keypoints); ipcv_free_keypoint_matrix(&keypoints); return ret;
}
