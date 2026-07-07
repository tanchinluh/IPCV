#include "ipcv_gateway_common.h"
#include "ipcv_gateway_image.h"

#include <string.h>

int sci_int_imadapthistequal(char *fname, void *pvApiCtx)
{
    SciErr sciErr;
    int *clipAddr = NULL;
    double clipLimit = 3.0;
    IpcvDecodedImage source;
    IpcvDecodedImage output;

    memset(&output, 0, sizeof(output));
    CheckInputArgument(pvApiCtx, 1, 2);
    CheckOutputArgument(pvApiCtx, 1, 1);

    int iRet = ipcv_get_image_argument(pvApiCtx, 1, source);
    if (iRet)
    {
        Scierror(999, "%s: Wrong type for input argument #%d: Single-channel image expected.\n", fname, 1);
        return iRet;
    }

    if (nbInputArgument(pvApiCtx) >= 2)
    {
        sciErr = getVarAddressFromPosition(pvApiCtx, 2, &clipAddr);
        if (sciErr.iErr)
        {
            printError(&sciErr, 0);
            ipcv_release_image_argument(source);
            return sciErr.iErr;
        }
        iRet = getScalarDouble(pvApiCtx, clipAddr, &clipLimit);
        if (iRet)
        {
            ipcv_release_image_argument(source);
            return iRet;
        }
    }

    iRet = ipcv_clahe_image(&source, clipLimit, &output);
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
