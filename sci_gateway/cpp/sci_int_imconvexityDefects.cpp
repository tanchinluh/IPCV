#include "ipcv_gateway_common.h"
#include "ipcv_gateway_image.h"

#include <string.h>

int sci_int_imconvexityDefects(char *fname, void *pvApiCtx)
{
    IpcvContourList contours;
    IpcvContourList hullIndices;
    IpcvContourList defects;

    memset(&contours, 0, sizeof(contours));
    memset(&hullIndices, 0, sizeof(hullIndices));
    memset(&defects, 0, sizeof(defects));
    CheckInputArgument(pvApiCtx, 2, 2);
    CheckOutputArgument(pvApiCtx, 0, 1);

    int iRet = ipcv_get_contour_list_argument(pvApiCtx, 1, contours);
    if (iRet)
    {
        Scierror(999, "%s: Wrong type for input argument #%d: Contour list expected.\n", fname, 1);
        return iRet;
    }

    iRet = ipcv_get_contour_list_argument(pvApiCtx, 2, hullIndices);
    if (iRet)
    {
        Scierror(999, "%s: Wrong type for input argument #%d: Convex hull index list expected.\n", fname, 2);
        ipcv_release_contour_list_argument(contours);
        return iRet;
    }

    iRet = ipcv_convexity_defects(&contours, &hullIndices, &defects);
    ipcv_release_contour_list_argument(contours);
    ipcv_release_contour_list_argument(hullIndices);
    if (iRet)
    {
        Scierror(999, "%s: %s\n", fname, defects.error);
        ipcv_free_contour_list(&defects);
        return iRet;
    }

    iRet = ipcv_set_contour_list_argument(pvApiCtx, 1, defects);
    ipcv_free_contour_list(&defects);
    return iRet;
}
