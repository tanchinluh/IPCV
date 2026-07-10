#include "ipcv_gateway_common.h"
#include "ipcv_gateway_image.h"

#include <math.h>
#include <string.h>

static int get_scalar_double_arg(void *pvApiCtx, int position, double *value)
{
    SciErr sciErr;
    int *address = NULL;

    sciErr = getVarAddressFromPosition(pvApiCtx, position, &address);
    if (sciErr.iErr)
    {
        printError(&sciErr, 0);
        return sciErr.iErr;
    }
    return getScalarDouble(pvApiCtx, address, value);
}

int sci_int_imthreshold(char *fname, void *pvApiCtx)
{
    IpcvDecodedImage source;
    IpcvDecodedImage output;
    double threshold = 0.0;
    double maxValue = 0.0;
    double mode = 0.0;
    double usedThreshold = 0.0;

    memset(&output, 0, sizeof(output));
    CheckInputArgument(pvApiCtx, 4, 4);
    CheckOutputArgument(pvApiCtx, 2, 2);

    int iRet = ipcv_get_image_argument(pvApiCtx, 1, source);
    if (iRet)
    {
        Scierror(999, "%s: Wrong type for input argument #%d: Image expected.\n", fname, 1);
        return iRet;
    }

    iRet = get_scalar_double_arg(pvApiCtx, 2, &threshold);
    if (!iRet) iRet = get_scalar_double_arg(pvApiCtx, 3, &maxValue);
    if (!iRet) iRet = get_scalar_double_arg(pvApiCtx, 4, &mode);
    if (iRet)
    {
        ipcv_release_image_argument(source);
        return iRet;
    }

    iRet = ipcv_threshold_image(&source, threshold, maxValue, static_cast<int>(round(mode)), &output, &usedThreshold);
    ipcv_release_image_argument(source);
    if (iRet)
    {
        Scierror(999, "%s: %s\n", fname, output.error);
        ipcv_free_decoded_image(&output);
        return iRet;
    }

    iRet = ipcv_set_image_argument(pvApiCtx, 1, output);
    if (!iRet)
    {
        iRet = createScalarDouble(pvApiCtx, nbInputArgument(pvApiCtx) + 2, usedThreshold);
    }
    if (!iRet)
    {
        AssignOutputVariable(pvApiCtx, 2) = nbInputArgument(pvApiCtx) + 2;
    }
    ipcv_free_decoded_image(&output);
    return iRet;
}
