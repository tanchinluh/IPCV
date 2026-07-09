#include "ipcv_gateway_common.h"
#include "ipcv_gateway_image.h"

#include <math.h>
#include <string.h>

int sci_int_imarclength(char *fname, void *pvApiCtx)
{
    SciErr sciErr;
    int *closedAddr = NULL;
    double closedValue = 1.0;
    IpcvContourList contours;
    IpcvDoubleMatrix lengths;

    memset(&contours, 0, sizeof(contours));
    memset(&lengths, 0, sizeof(lengths));
    CheckInputArgument(pvApiCtx, 2, 2);
    CheckOutputArgument(pvApiCtx, 1, 1);

    int iRet = ipcv_get_contour_list_argument(pvApiCtx, 1, contours);
    if (iRet)
    {
        Scierror(999, "%s: Wrong type for input argument #%d: Contour list expected.\n", fname, 1);
        return iRet;
    }

    sciErr = getVarAddressFromPosition(pvApiCtx, 2, &closedAddr);
    if (sciErr.iErr)
    {
        printError(&sciErr, 0);
        ipcv_release_contour_list_argument(contours);
        return sciErr.iErr;
    }
    iRet = getScalarDouble(pvApiCtx, closedAddr, &closedValue);
    if (iRet)
    {
        ipcv_release_contour_list_argument(contours);
        return iRet;
    }

    iRet = ipcv_arc_length(&contours, static_cast<int>(round(closedValue)), &lengths);
    ipcv_release_contour_list_argument(contours);
    if (iRet)
    {
        Scierror(999, "%s: %s\n", fname, lengths.error);
        ipcv_free_double_matrix(&lengths);
        return iRet;
    }

    sciErr = createMatrixOfDouble(pvApiCtx, nbInputArgument(pvApiCtx) + 1, lengths.rows, lengths.cols, lengths.data);
    ipcv_free_double_matrix(&lengths);
    if (sciErr.iErr)
    {
        printError(&sciErr, 0);
        return sciErr.iErr;
    }

    AssignOutputVariable(pvApiCtx, 1) = nbInputArgument(pvApiCtx) + 1;
    ReturnArguments(pvApiCtx);
    return 0;
}
