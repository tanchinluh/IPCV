#include "ipcv_gateway_common.h"
#include "ipcv_gateway_image.h"

#include <math.h>
#include <string.h>

int sci_int_imfindContours(char *fname, void *pvApiCtx)
{
    SciErr sciErr;
    int *modeAddr = NULL;
    int *methodAddr = NULL;
    double modeValue = 0.0;
    double methodValue = 0.0;
    IpcvDecodedImage source;
    IpcvContourList contours;

    memset(&contours, 0, sizeof(contours));
    CheckInputArgument(pvApiCtx, 3, 3);
    CheckOutputArgument(pvApiCtx, 0, 1);

    int iRet = ipcv_get_image_argument(pvApiCtx, 1, source);
    if (iRet)
    {
        Scierror(999, "%s: Wrong type for input argument #%d: Binary image expected.\n", fname, 1);
        return iRet;
    }

    sciErr = getVarAddressFromPosition(pvApiCtx, 2, &modeAddr);
    if (sciErr.iErr)
    {
        printError(&sciErr, 0);
        ipcv_release_image_argument(source);
        return sciErr.iErr;
    }
    iRet = getScalarDouble(pvApiCtx, modeAddr, &modeValue);
    if (iRet)
    {
        ipcv_release_image_argument(source);
        return iRet;
    }

    sciErr = getVarAddressFromPosition(pvApiCtx, 3, &methodAddr);
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

    iRet = ipcv_find_contours(&source, static_cast<int>(round(modeValue)), static_cast<int>(round(methodValue)), &contours);
    ipcv_release_image_argument(source);
    if (iRet)
    {
        Scierror(999, "%s: %s\n", fname, contours.error);
        ipcv_free_contour_list(&contours);
        return iRet;
    }

    iRet = ipcv_set_contour_list_argument(pvApiCtx, 1, contours);
    ipcv_free_contour_list(&contours);
    return iRet;
}
