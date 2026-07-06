#include "common.h"
#include "ipcv_gateway_image.h"

#include <string.h>

int sci_int_imrotate(char *fname, void *pvApiCtx)
{
    SciErr sciErr;
    int *angleAddr = NULL;
    int *cropAddr = NULL;
    double angle = 0.0;
    double crop = 0.0;
    IpcvDecodedImage source;
    IpcvDecodedImage output;

    memset(&output, 0, sizeof(output));
    CheckInputArgument(pvApiCtx, 3, 3);
    CheckOutputArgument(pvApiCtx, 0, 1);

    int iRet = ipcv_get_image_argument(pvApiCtx, 1, source);
    if (iRet)
    {
        Scierror(999, "%s: Wrong type for input argument #%d: Image expected.\n", fname, 1);
        return iRet;
    }

    sciErr = getVarAddressFromPosition(pvApiCtx, 2, &angleAddr);
    if (sciErr.iErr)
    {
        printError(&sciErr, 0);
        ipcv_release_image_argument(source);
        return sciErr.iErr;
    }
    iRet = getScalarDouble(pvApiCtx, angleAddr, &angle);
    if (iRet)
    {
        ipcv_release_image_argument(source);
        return iRet;
    }

    sciErr = getVarAddressFromPosition(pvApiCtx, 3, &cropAddr);
    if (sciErr.iErr)
    {
        printError(&sciErr, 0);
        ipcv_release_image_argument(source);
        return sciErr.iErr;
    }
    iRet = getScalarDouble(pvApiCtx, cropAddr, &crop);
    if (iRet)
    {
        ipcv_release_image_argument(source);
        return iRet;
    }

    iRet = ipcv_rotate_image(&source, angle, static_cast<int>(crop), &output);
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
