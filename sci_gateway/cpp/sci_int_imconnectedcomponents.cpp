#include "ipcv_gateway_common.h"
#include "ipcv_gateway_image.h"

#include <math.h>
#include <string.h>

int sci_int_imconnectedcomponents(char *fname, void *pvApiCtx)
{
    SciErr sciErr;
    int *connectivityAddress = NULL;
    double connectivityValue = 0.0;
    IpcvDecodedImage source;
    IpcvDecodedImage labels;
    IpcvDoubleMatrix stats;
    IpcvDoubleMatrix centroids;
    int componentCount = 0;

    memset(&labels, 0, sizeof(labels));
    memset(&stats, 0, sizeof(stats));
    memset(&centroids, 0, sizeof(centroids));
    CheckInputArgument(pvApiCtx, 2, 2);
    CheckOutputArgument(pvApiCtx, 4, 4);

    int iRet = ipcv_get_image_argument(pvApiCtx, 1, source);
    if (iRet)
    {
        Scierror(999, "%s: Wrong type for input argument #%d: Binary image expected.\n", fname, 1);
        return iRet;
    }

    sciErr = getVarAddressFromPosition(pvApiCtx, 2, &connectivityAddress);
    if (sciErr.iErr)
    {
        printError(&sciErr, 0);
        ipcv_release_image_argument(source);
        return sciErr.iErr;
    }
    iRet = getScalarDouble(pvApiCtx, connectivityAddress, &connectivityValue);
    if (iRet)
    {
        ipcv_release_image_argument(source);
        return iRet;
    }

    iRet = ipcv_connected_components(&source, static_cast<int>(round(connectivityValue)), &labels, &componentCount, &stats, &centroids);
    ipcv_release_image_argument(source);
    if (iRet)
    {
        Scierror(999, "%s: %s\n", fname, labels.error);
        ipcv_free_decoded_image(&labels);
        ipcv_free_double_matrix(&stats);
        ipcv_free_double_matrix(&centroids);
        return iRet;
    }

    iRet = ipcv_set_image_argument(pvApiCtx, 1, labels);
    if (!iRet)
    {
        iRet = createScalarDouble(pvApiCtx, nbInputArgument(pvApiCtx) + 2, static_cast<double>(componentCount));
    }
    if (!iRet)
    {
        sciErr = createMatrixOfDouble(pvApiCtx, nbInputArgument(pvApiCtx) + 3, stats.rows, stats.cols, stats.data);
        iRet = sciErr.iErr;
        if (iRet) printError(&sciErr, 0);
    }
    if (!iRet)
    {
        sciErr = createMatrixOfDouble(pvApiCtx, nbInputArgument(pvApiCtx) + 4, centroids.rows, centroids.cols, centroids.data);
        iRet = sciErr.iErr;
        if (iRet) printError(&sciErr, 0);
    }
    if (!iRet)
    {
        AssignOutputVariable(pvApiCtx, 2) = nbInputArgument(pvApiCtx) + 2;
        AssignOutputVariable(pvApiCtx, 3) = nbInputArgument(pvApiCtx) + 3;
        AssignOutputVariable(pvApiCtx, 4) = nbInputArgument(pvApiCtx) + 4;
    }

    ipcv_free_decoded_image(&labels);
    ipcv_free_double_matrix(&stats);
    ipcv_free_double_matrix(&centroids);
    return iRet;
}
