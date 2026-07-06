#include "common.h"
#include "ipcv_gateway_image.h"

#include <string.h>

int sci_int_imradon(char *fname, void *pvApiCtx)
{
    SciErr sciErr;
    int *imageAddr = NULL;
    int *thetaAddr = NULL;
    int imageRows = 0;
    int imageCols = 0;
    int thetaRows = 0;
    int thetaCols = 0;
    double *image = NULL;
    double *theta = NULL;
    IpcvRadonResult result;

    memset(&result, 0, sizeof(result));
    CheckInputArgument(pvApiCtx, 2, 2);
    CheckOutputArgument(pvApiCtx, 2, 2);

    sciErr = getVarAddressFromPosition(pvApiCtx, 1, &imageAddr);
    if (sciErr.iErr)
    {
        printError(&sciErr, 0);
        return sciErr.iErr;
    }
    sciErr = getMatrixOfDouble(pvApiCtx, imageAddr, &imageRows, &imageCols, &image);
    if (sciErr.iErr)
    {
        printError(&sciErr, 0);
        return sciErr.iErr;
    }

    sciErr = getVarAddressFromPosition(pvApiCtx, 2, &thetaAddr);
    if (sciErr.iErr)
    {
        printError(&sciErr, 0);
        return sciErr.iErr;
    }
    sciErr = getMatrixOfDouble(pvApiCtx, thetaAddr, &thetaRows, &thetaCols, &theta);
    if (sciErr.iErr)
    {
        printError(&sciErr, 0);
        return sciErr.iErr;
    }

    int iRet = ipcv_radon_transform(image, imageRows, imageCols, theta, thetaRows * thetaCols, &result);
    if (iRet)
    {
        Scierror(999, "%s: %s\n", fname, result.error);
        ipcv_free_radon_result(&result);
        return iRet;
    }

    sciErr = createMatrixOfDouble(pvApiCtx, nbInputArgument(pvApiCtx) + 1, result.projection_rows, result.projection_cols, result.projection);
    if (sciErr.iErr)
    {
        printError(&sciErr, 0);
        ipcv_free_radon_result(&result);
        return sciErr.iErr;
    }

    sciErr = createMatrixOfDouble(pvApiCtx, nbInputArgument(pvApiCtx) + 2, 1, result.radius_count, result.radius);
    if (sciErr.iErr)
    {
        printError(&sciErr, 0);
        ipcv_free_radon_result(&result);
        return sciErr.iErr;
    }

    AssignOutputVariable(pvApiCtx, 1) = nbInputArgument(pvApiCtx) + 1;
    AssignOutputVariable(pvApiCtx, 2) = nbInputArgument(pvApiCtx) + 2;

    ipcv_free_radon_result(&result);
    return 0;
}
