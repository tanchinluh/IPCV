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

int sci_int_imdenoise(char *fname, void *pvApiCtx)
{
    IpcvDecodedImage source;
    IpcvDecodedImage output;
    double h = 3.0;
    double hColor = 3.0;
    double templateWindowSize = 7.0;
    double searchWindowSize = 21.0;

    memset(&output, 0, sizeof(output));
    CheckInputArgument(pvApiCtx, 5, 5);
    CheckOutputArgument(pvApiCtx, 1, 1);

    int iRet = ipcv_get_image_argument(pvApiCtx, 1, source);
    if (iRet)
    {
        Scierror(999, "%s: Wrong type for input argument #%d: Image expected.\n", fname, 1);
        return iRet;
    }

    iRet = get_scalar_double_arg(pvApiCtx, 2, &h);
    if (iRet)
    {
        ipcv_release_image_argument(source);
        return iRet;
    }
    iRet = get_scalar_double_arg(pvApiCtx, 3, &hColor);
    if (iRet)
    {
        ipcv_release_image_argument(source);
        return iRet;
    }
    iRet = get_scalar_double_arg(pvApiCtx, 4, &templateWindowSize);
    if (iRet)
    {
        ipcv_release_image_argument(source);
        return iRet;
    }
    iRet = get_scalar_double_arg(pvApiCtx, 5, &searchWindowSize);
    if (iRet)
    {
        ipcv_release_image_argument(source);
        return iRet;
    }

    iRet = ipcv_denoise_image(&source, h, hColor, static_cast<int>(floor(templateWindowSize + 0.5)), static_cast<int>(floor(searchWindowSize + 0.5)), &output);
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
