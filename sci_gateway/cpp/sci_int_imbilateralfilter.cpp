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

int sci_int_imbilateralfilter(char *fname, void *pvApiCtx)
{
    IpcvDecodedImage source;
    IpcvDecodedImage output;
    double diameter = 0.0;
    double sigmaColor = 0.0;
    double sigmaSpace = 0.0;

    memset(&output, 0, sizeof(output));
    CheckInputArgument(pvApiCtx, 4, 4);
    CheckOutputArgument(pvApiCtx, 1, 1);

    int iRet = ipcv_get_image_argument(pvApiCtx, 1, source);
    if (iRet)
    {
        Scierror(999, "%s: Wrong type for input argument #%d: Image expected.\n", fname, 1);
        return iRet;
    }

    iRet = get_scalar_double_arg(pvApiCtx, 2, &diameter);
    if (iRet)
    {
        ipcv_release_image_argument(source);
        return iRet;
    }
    iRet = get_scalar_double_arg(pvApiCtx, 3, &sigmaColor);
    if (iRet)
    {
        ipcv_release_image_argument(source);
        return iRet;
    }
    iRet = get_scalar_double_arg(pvApiCtx, 4, &sigmaSpace);
    if (iRet)
    {
        ipcv_release_image_argument(source);
        return iRet;
    }

    iRet = ipcv_bilateral_filter_image(&source, static_cast<int>(floor(diameter + 0.5)), sigmaColor, sigmaSpace, &output);
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
