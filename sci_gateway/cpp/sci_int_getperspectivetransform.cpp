#include "ipcv_gateway_common.h"
#include "ipcv_gateway_image.h"

#include <string.h>

int sci_int_getperspectivetransform(char *fname, void *pvApiCtx)
{
    IpcvDecodedImage sourcePoints;
    IpcvDecodedImage targetPoints;
    IpcvDecodedImage output;

    memset(&output, 0, sizeof(output));
    CheckInputArgument(pvApiCtx, 2, 2);
    CheckOutputArgument(pvApiCtx, 0, 1);

    int iRet = ipcv_get_image_argument(pvApiCtx, 1, sourcePoints);
    if (iRet)
    {
        Scierror(999, "%s: Wrong type for input argument #%d: 4x2 source point matrix expected.\n", fname, 1);
        return iRet;
    }

    iRet = ipcv_get_image_argument(pvApiCtx, 2, targetPoints);
    if (iRet)
    {
        Scierror(999, "%s: Wrong type for input argument #%d: 4x2 target point matrix expected.\n", fname, 2);
        ipcv_release_image_argument(sourcePoints);
        return iRet;
    }

    iRet = ipcv_get_perspective_transform_matrix(&sourcePoints, &targetPoints, &output);
    ipcv_release_image_argument(sourcePoints);
    ipcv_release_image_argument(targetPoints);
    if (iRet)
    {
        Scierror(999, "%s: %s\n", fname, output.error);
        ipcv_free_decoded_image(&output);
        return iRet;
    }

    iRet = ipcv_set_image_argument(pvApiCtx, 1, output);
    ipcv_free_decoded_image(&output);
    return iRet;
}
