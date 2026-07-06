/***********************************************************************
 * IPCV - Scilab Image Processing and Computer Vision toolbox
 * Copyright (C) 2017  Tan Chin Luh
 ***********************************************************************/

#include "common.h"
#include "ipcv_gateway_image.h"

#include <string.h>

int sci_int_imcreatese(char *fname, void *pvApiCtx)
{
    SciErr sciErr;
    int *piAddr = NULL;
    char shape = 0;
    char rows = 0;
    char cols = 0;
    IpcvDecodedImage output;

    memset(&output, 0, sizeof(output));
    CheckInputArgument(pvApiCtx, 3, 3);
    CheckOutputArgument(pvApiCtx, 0, 1);

    sciErr = getVarAddressFromPosition(pvApiCtx, 1, &piAddr);
    if (sciErr.iErr)
    {
        printError(&sciErr, 0);
        return sciErr.iErr;
    }
    getScalarInteger8(pvApiCtx, piAddr, &shape);

    sciErr = getVarAddressFromPosition(pvApiCtx, 2, &piAddr);
    if (sciErr.iErr)
    {
        printError(&sciErr, 0);
        return sciErr.iErr;
    }
    getScalarInteger8(pvApiCtx, piAddr, &rows);

    sciErr = getVarAddressFromPosition(pvApiCtx, 3, &piAddr);
    if (sciErr.iErr)
    {
        printError(&sciErr, 0);
        return sciErr.iErr;
    }
    getScalarInteger8(pvApiCtx, piAddr, &cols);

    int iRet = ipcv_create_structuring_element(shape, rows, cols, &output);
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
