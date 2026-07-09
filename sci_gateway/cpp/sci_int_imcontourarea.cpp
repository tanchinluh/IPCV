#include "ipcv_gateway_common.h"
#include "ipcv_gateway_image.h"

#include <math.h>
#include <string.h>

int sci_int_imcontourarea(char *fname, void *pvApiCtx)
{
    SciErr sciErr;
    int *orientedAddr = NULL;
    double orientedValue = 0.0;
    IpcvContourList contours;
    IpcvDoubleMatrix areas;

    memset(&contours, 0, sizeof(contours));
    memset(&areas, 0, sizeof(areas));
    CheckInputArgument(pvApiCtx, 2, 2);
    CheckOutputArgument(pvApiCtx, 1, 1);

    int iRet = ipcv_get_contour_list_argument(pvApiCtx, 1, contours);
    if (iRet)
    {
        Scierror(999, "%s: Wrong type for input argument #%d: Contour list expected.\n", fname, 1);
        return iRet;
    }

    sciErr = getVarAddressFromPosition(pvApiCtx, 2, &orientedAddr);
    if (sciErr.iErr)
    {
        printError(&sciErr, 0);
        ipcv_release_contour_list_argument(contours);
        return sciErr.iErr;
    }
    iRet = getScalarDouble(pvApiCtx, orientedAddr, &orientedValue);
    if (iRet)
    {
        ipcv_release_contour_list_argument(contours);
        return iRet;
    }

    iRet = ipcv_contour_area(&contours, static_cast<int>(round(orientedValue)), &areas);
    ipcv_release_contour_list_argument(contours);
    if (iRet)
    {
        Scierror(999, "%s: %s\n", fname, areas.error);
        ipcv_free_double_matrix(&areas);
        return iRet;
    }

    sciErr = createMatrixOfDouble(pvApiCtx, nbInputArgument(pvApiCtx) + 1, areas.rows, areas.cols, areas.data);
    ipcv_free_double_matrix(&areas);
    if (sciErr.iErr)
    {
        printError(&sciErr, 0);
        return sciErr.iErr;
    }

    AssignOutputVariable(pvApiCtx, 1) = nbInputArgument(pvApiCtx) + 1;
    ReturnArguments(pvApiCtx);
    return 0;
}
