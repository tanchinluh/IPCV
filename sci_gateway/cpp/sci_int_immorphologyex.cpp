/***********************************************************************
 * IPCV - Scilab Image Processing and Computer Vision toolbox
 * Copyright (C) 2017  Tan Chin Luh
 ***********************************************************************/

#include "ipcv_gateway_common.h"
#include "ipcv_gateway_image.h"

#include <math.h>
#include <string.h>

static int get_optional_double_arg(void *pvApiCtx, int position, double *value)
{
    SciErr sciErr;
    int *piAddr = NULL;

    sciErr = getVarAddressFromPosition(pvApiCtx, position, &piAddr);
    if (sciErr.iErr)
    {
        printError(&sciErr, 0);
        return sciErr.iErr;
    }

    int iRet = getScalarDouble(pvApiCtx, piAddr, value);
    if (iRet)
    {
        return iRet;
    }
    return 0;
}

int sci_int_immorphologyex(char *fname, void *pvApiCtx)
{
    SciErr sciErr;
    int *piAddr = NULL;
    char operation = 0;
    IpcvDecodedImage source;
    IpcvDecodedImage element;
    IpcvDecodedImage output;
    int iterations = 1;
    int anchorRow = -1;
    int anchorCol = -1;
    int borderType = 0;
    int useDefaultBorderValue = 1;
    double borderValue = 0.0;

    memset(&output, 0, sizeof(output));
    CheckInputArgument(pvApiCtx, 3, 9);
    CheckOutputArgument(pvApiCtx, 0, 1);

    int iRet = ipcv_get_image_argument(pvApiCtx, 1, source);
    if (iRet)
    {
        Scierror(999, "%s: Wrong type for input argument #%d: Image expected.\n", fname, 1);
        return iRet;
    }

    iRet = ipcv_get_image_argument(pvApiCtx, 2, element);
    if (iRet)
    {
        Scierror(999, "%s: Wrong type for input argument #%d: Structuring element expected.\n", fname, 2);
        ipcv_release_image_argument(source);
        return iRet;
    }

    sciErr = getVarAddressFromPosition(pvApiCtx, 3, &piAddr);
    if (sciErr.iErr)
    {
        printError(&sciErr, 0);
        ipcv_release_image_argument(source);
        ipcv_release_image_argument(element);
        return sciErr.iErr;
    }
    getScalarInteger8(pvApiCtx, piAddr, &operation);

    if (nbInputArgument(pvApiCtx) >= 4)
    {
        double value = 0.0;
        iRet = get_optional_double_arg(pvApiCtx, 4, &value);
        if (iRet)
        {
            ipcv_release_image_argument(source);
            ipcv_release_image_argument(element);
            return iRet;
        }
        iterations = static_cast<int>(floor(value + 0.5));
    }
    if (nbInputArgument(pvApiCtx) >= 5)
    {
        double value = 0.0;
        iRet = get_optional_double_arg(pvApiCtx, 5, &value);
        if (iRet)
        {
            ipcv_release_image_argument(source);
            ipcv_release_image_argument(element);
            return iRet;
        }
        anchorRow = static_cast<int>(floor(value + 0.5));
    }
    if (nbInputArgument(pvApiCtx) >= 6)
    {
        double value = 0.0;
        iRet = get_optional_double_arg(pvApiCtx, 6, &value);
        if (iRet)
        {
            ipcv_release_image_argument(source);
            ipcv_release_image_argument(element);
            return iRet;
        }
        anchorCol = static_cast<int>(floor(value + 0.5));
    }
    if (nbInputArgument(pvApiCtx) >= 7)
    {
        double value = 0.0;
        iRet = get_optional_double_arg(pvApiCtx, 7, &value);
        if (iRet)
        {
            ipcv_release_image_argument(source);
            ipcv_release_image_argument(element);
            return iRet;
        }
        borderType = static_cast<int>(floor(value + 0.5));
    }
    if (nbInputArgument(pvApiCtx) >= 8)
    {
        double value = 0.0;
        iRet = get_optional_double_arg(pvApiCtx, 8, &value);
        if (iRet)
        {
            ipcv_release_image_argument(source);
            ipcv_release_image_argument(element);
            return iRet;
        }
        useDefaultBorderValue = value != 0.0 ? 1 : 0;
    }
    if (nbInputArgument(pvApiCtx) >= 9)
    {
        iRet = get_optional_double_arg(pvApiCtx, 9, &borderValue);
        if (iRet)
        {
            ipcv_release_image_argument(source);
            ipcv_release_image_argument(element);
            return iRet;
        }
    }

    iRet = ipcv_morphology_image(&source, &element, operation, iterations, anchorRow, anchorCol, borderType, useDefaultBorderValue, borderValue, &output);
    ipcv_release_image_argument(source);
    ipcv_release_image_argument(element);
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
