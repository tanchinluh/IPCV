#include "ipcv_gateway_common.h"
#include "ipcv_gateway_image.h"

int sci_int_imextract_DescriptorKAZE(char *fname, void *pvApiCtx)
{
    CheckInputArgument(pvApiCtx, 2, 2); CheckOutputArgument(pvApiCtx, 0, 1);
    IpcvDecodedImage image; IpcvKeypointMatrix keypoints; IpcvDecodedImage descriptors; memset(&descriptors, 0, sizeof(descriptors));
    int ret = ipcv_get_image_argument(pvApiCtx, 1, image);
    if (ret) { Scierror(999, "%s: image expected.\n", fname); return ret; }
    ret = ipcv_get_keypoint_matrix_argument(pvApiCtx, 2, keypoints);
    if (ret) { ipcv_release_image_argument(image); Scierror(999, "%s: 7-row keypoint matrix expected.\n", fname); return ret; }
    ret = ipcv_compute_kaze_descriptors(&image, &keypoints, &descriptors); ipcv_release_image_argument(image);
    if (ret) { Scierror(999, "%s: %s\n", fname, descriptors.error); ipcv_free_decoded_image(&descriptors); return ret; }
    ret = ipcv_set_image_argument(pvApiCtx, 1, descriptors); ipcv_free_decoded_image(&descriptors); return ret;
}
