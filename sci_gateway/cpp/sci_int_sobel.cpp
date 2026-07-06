#include "common.h"
#include "ipcv_gateway_image.h"

#include <string.h>

int sci_int_sobel(char *fname, void *pvApiCtx)
{
    IpcvDecodedImage source;
    IpcvDecodedImage output;
    double *dxValue = NULL;
    double *dyValue = NULL;
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

    GetDouble(2, dxValue, rows, cols, pvApiCtx);
    GetDouble(3, dyValue, rows, cols, pvApiCtx);

    iRet = ipcv_sobel_image(&source, static_cast<int>(*dxValue), static_cast<int>(*dyValue), &output);
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
