#include "ipcv_gateway_common.h"
#include "ipcv_gateway_image.h"

#include <math.h>
#include <string.h>

int sci_int_imconvexHull(char *fname, void *pvApiCtx)
{
    SciErr sciErr;
    int *clockwiseAddr = NULL;
    int *indicesAddr = NULL;
    double clockwiseValue = 0.0;
    double indicesValue = 0.0;
    IpcvContourList contours;
    IpcvContourList hulls;

    memset(&contours, 0, sizeof(contours));
    memset(&hulls, 0, sizeof(hulls));
    CheckInputArgument(pvApiCtx, 3, 3);
    CheckOutputArgument(pvApiCtx, 0, 1);

    int iRet = ipcv_get_contour_list_argument(pvApiCtx, 1, contours);
    if (iRet)
    {
        Scierror(999, "%s: Wrong type for input argument #%d: Contour list expected.\n", fname, 1);
        return iRet;
    }

    sciErr = getVarAddressFromPosition(pvApiCtx, 2, &clockwiseAddr);
    if (sciErr.iErr)
    {
        printError(&sciErr, 0);
        ipcv_release_contour_list_argument(contours);
        return sciErr.iErr;
    }
    iRet = getScalarDouble(pvApiCtx, clockwiseAddr, &clockwiseValue);
    if (iRet)
    {
        ipcv_release_contour_list_argument(contours);
        return iRet;
    }

    sciErr = getVarAddressFromPosition(pvApiCtx, 3, &indicesAddr);
    if (sciErr.iErr)
    {
        printError(&sciErr, 0);
        ipcv_release_contour_list_argument(contours);
        return sciErr.iErr;
    }
    iRet = getScalarDouble(pvApiCtx, indicesAddr, &indicesValue);
    if (iRet)
    {
        ipcv_release_contour_list_argument(contours);
        return iRet;
    }

    iRet = ipcv_convex_hull(&contours, static_cast<int>(round(clockwiseValue)), static_cast<int>(round(indicesValue)), &hulls);
    ipcv_release_contour_list_argument(contours);
    if (iRet)
    {
        Scierror(999, "%s: %s\n", fname, hulls.error);
        ipcv_free_contour_list(&hulls);
        return iRet;
    }

    iRet = ipcv_set_contour_list_argument(pvApiCtx, 1, hulls);
    ipcv_free_contour_list(&hulls);
    return iRet;
}
