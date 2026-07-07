#include "ipcv_gateway_common.h"
#include "ipcv_gateway_image.h"

#include <math.h>
#include <string.h>

int sci_int_imdistransf(char *fname, void *pvApiCtx)
{
    SciErr sciErr;
    int *methodAddr = NULL;
    double methodValue = 0.0;
    IpcvDecodedImage source;
    IpcvDecodedImage output;

    memset(&output, 0, sizeof(output));
    CheckInputArgument(pvApiCtx, 2, 2);
    CheckOutputArgument(pvApiCtx, 0, 1);

    int iRet = ipcv_get_image_argument(pvApiCtx, 1, source);
    if (iRet)
    {
        Scierror(999, "%s: Wrong type for input argument #%d: Binary image expected.\n", fname, 1);
        return iRet;
    }

    sciErr = getVarAddressFromPosition(pvApiCtx, 2, &methodAddr);
    if (sciErr.iErr)
    {
        printError(&sciErr, 0);
        ipcv_release_image_argument(source);
        return sciErr.iErr;
    }
    iRet = getScalarDouble(pvApiCtx, methodAddr, &methodValue);
    if (iRet)
    {
        ipcv_release_image_argument(source);
        return iRet;
    }

    iRet = ipcv_distance_transform_image(&source, static_cast<int>(round(methodValue)), &output);
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
