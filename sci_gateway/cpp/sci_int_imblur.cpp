#include "ipcv_gateway_common.h"
#include "ipcv_gateway_image.h"

#include <math.h>
#include <string.h>

static int get_scalar_double_arg(void *pvApiCtx, int position, double *value)
{
    SciErr sciErr;
    int *piAddr = NULL;

    sciErr = getVarAddressFromPosition(pvApiCtx, position, &piAddr);
    if (sciErr.iErr)
    {
        printError(&sciErr, 0);
        return sciErr.iErr;
    }

    return getScalarDouble(pvApiCtx, piAddr, value);
}

int sci_int_imblur(char *fname, void *pvApiCtx)
{
    IpcvDecodedImage source;
    IpcvDecodedImage output;
    double kernelRows = 0.0;
    double kernelCols = 0.0;

    memset(&output, 0, sizeof(output));
    CheckInputArgument(pvApiCtx, 3, 3);
    CheckOutputArgument(pvApiCtx, 1, 1);

    int iRet = ipcv_get_image_argument(pvApiCtx, 1, source);
    if (iRet)
    {
        Scierror(999, "%s: Wrong type for input argument #%d: Image expected.\n", fname, 1);
        return iRet;
    }

    iRet = get_scalar_double_arg(pvApiCtx, 2, &kernelRows);
    if (iRet)
    {
        ipcv_release_image_argument(source);
        return iRet;
    }
    iRet = get_scalar_double_arg(pvApiCtx, 3, &kernelCols);
    if (iRet)
    {
        ipcv_release_image_argument(source);
        return iRet;
    }

    iRet = ipcv_blur_image(&source, static_cast<int>(floor(kernelRows + 0.5)), static_cast<int>(floor(kernelCols + 0.5)), &output);
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
