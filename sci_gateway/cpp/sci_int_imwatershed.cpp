#include "ipcv_gateway_common.h"
#include "ipcv_gateway_image.h"

#include <math.h>
#include <string.h>

int sci_int_imwatershed(char *fname, void *pvApiCtx)
{
    SciErr sciErr;
    int *objectCountAddr = NULL;
    double objectCountValue = 0.0;
    IpcvDecodedImage source;
    IpcvDecodedImage markers;
    IpcvDecodedImage colorOutput;
    IpcvDecodedImage markerOutput;

    memset(&colorOutput, 0, sizeof(colorOutput));
    memset(&markerOutput, 0, sizeof(markerOutput));
    CheckInputArgument(pvApiCtx, 3, 3);
    CheckOutputArgument(pvApiCtx, 0, 2);

    int iRet = ipcv_get_image_argument(pvApiCtx, 1, source);
    if (iRet)
    {
        Scierror(999, "%s: Wrong type for input argument #%d: RGB image expected.\n", fname, 1);
        return iRet;
    }

    iRet = ipcv_get_image_argument(pvApiCtx, 2, markers);
    if (iRet)
    {
        Scierror(999, "%s: Wrong type for input argument #%d: marker image expected.\n", fname, 2);
        ipcv_release_image_argument(source);
        return iRet;
    }

    sciErr = getVarAddressFromPosition(pvApiCtx, 3, &objectCountAddr);
    if (sciErr.iErr)
    {
        printError(&sciErr, 0);
        ipcv_release_image_argument(source);
        ipcv_release_image_argument(markers);
        return sciErr.iErr;
    }
    iRet = getScalarDouble(pvApiCtx, objectCountAddr, &objectCountValue);
    if (iRet)
    {
        ipcv_release_image_argument(source);
        ipcv_release_image_argument(markers);
        return iRet;
    }

    iRet = ipcv_watershed_image(&source, &markers, static_cast<int>(round(objectCountValue)), &colorOutput, &markerOutput);
    ipcv_release_image_argument(source);
    ipcv_release_image_argument(markers);
    if (iRet)
    {
        Scierror(999, "%s: %s\n", fname, colorOutput.error);
        ipcv_free_decoded_image(&colorOutput);
        ipcv_free_decoded_image(&markerOutput);
        return iRet;
    }

    iRet = ipcv_set_image_argument(pvApiCtx, 1, colorOutput);
    if (iRet == 0)
    {
        iRet = ipcv_set_image_argument(pvApiCtx, 2, markerOutput);
    }

    ipcv_free_decoded_image(&colorOutput);
    ipcv_free_decoded_image(&markerOutput);
    return iRet;
}
