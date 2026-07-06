#include "common.h"
#include "ipcv_gateway_image.h"

#include <string.h>

int sci_int_canny(char *fname, void *pvApiCtx)
{
    IpcvDecodedImage source;
    IpcvDecodedImage output;
    double *thresholds = NULL;
    double *aperture = NULL;
    int rows = 0;
    int cols = 0;

    memset(&output, 0, sizeof(output));
    CheckInputArgument(pvApiCtx, 3, 3);
    CheckOutputArgument(pvApiCtx, 1, 1);

    int iRet = ipcv_get_image_argument(pvApiCtx, 1, source);
    if (iRet)
    {
        Scierror(999, "%s: Wrong type for input argument #%d: Single-channel image expected.\n", fname, 1);
        return iRet;
    }

    GetDouble(2, thresholds, rows, cols, pvApiCtx);
    if (rows * cols < 2)
    {
        Scierror(999, "%s: Wrong size for input argument #%d: Two thresholds expected.\n", fname, 2);
        ipcv_release_image_argument(source);
        return -1;
    }
    GetDouble(3, aperture, rows, cols, pvApiCtx);

    iRet = ipcv_canny_image(&source, thresholds[0], thresholds[1], static_cast<int>(*aperture), &output);
    ipcv_release_image_argument(source);
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
