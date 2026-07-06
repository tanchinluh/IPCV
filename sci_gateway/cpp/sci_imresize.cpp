/***********************************************************************
 * SIVP - Scilab Image and Video Processing toolbox
 * Copyright (C) 2005  Shiqi Yu
 *
 * IPCV - Scilab Image Processing and Computer Vision toolbox
 * Copyright (C) 2017  Tan Chin Luh
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version.
 ***********************************************************************/

#include "common.h"
#include "ipcv_gateway_image.h"

#include <math.h>
#include <string.h>

int sci_imresize(char *fname, void *pvApiCtx)
{
    IpcvDecodedImage source;
    IpcvDecodedImage output;
    double *sizeArg = NULL;
    int sizeRows = 0;
    int sizeCols = 0;
    int targetRows = 0;
    int targetCols = 0;
    int interpolation = IPCV_INTER_NEAREST;

    memset(&output, 0, sizeof(output));
    CheckInputArgument(pvApiCtx, 2, 3);
    CheckOutputArgument(pvApiCtx, 0, 1);

    int iRet = ipcv_get_image_argument(pvApiCtx, 1, source);
    if (iRet)
    {
        Scierror(999, "%s: Wrong type for input argument #%d: Image expected.\n", fname, 1);
        return iRet;
    }

    iRet = GetDouble(2, sizeArg, sizeRows, sizeCols, pvApiCtx);
    if (iRet || sizeArg == NULL)
    {
        Scierror(999, "%s: Wrong type for input argument #%d: Double value or 1x2 vector expected.\n", fname, 2);
        return -1;
    }

    if (sizeRows == 1 && sizeCols == 1)
    {
        targetRows = static_cast<int>(round(source.rows * sizeArg[0]));
        targetCols = static_cast<int>(round(source.cols * sizeArg[0]));
    }
    else if (sizeRows * sizeCols == 2)
    {
        targetRows = static_cast<int>(round(sizeArg[0]));
        targetCols = static_cast<int>(round(sizeArg[1]));
    }
    else
    {
        Scierror(999, "%s: The second parameter should be a double value or 1x2 vector.\n", fname);
        return -1;
    }

    if (nbInputArgument(pvApiCtx) == 3)
    {
        char *method = NULL;
        iRet = GetString(3, method, pvApiCtx);
        if (iRet || method == NULL)
        {
            Scierror(999, "%s: Wrong type for input argument #%d: String expected.\n", fname, 3);
            return -1;
        }

        if (strcmp(method, "nearest") == 0)
        {
            interpolation = IPCV_INTER_NEAREST;
        }
        else if (strcmp(method, "bilinear") == 0)
        {
            interpolation = IPCV_INTER_LINEAR;
        }
        else if (strcmp(method, "bicubic") == 0)
        {
            interpolation = IPCV_INTER_CUBIC;
        }
        else if (strcmp(method, "area") == 0)
        {
            interpolation = IPCV_INTER_AREA;
        }
        else if (strcmp(method, "lanczos") == 0)
        {
            interpolation = IPCV_INTER_LANCZOS;
        }
        else
        {
            Scierror(999, "%s: Interpolation method '%s' is not supported.\n", fname, method);
            return -1;
        }
    }

    iRet = ipcv_resize_image(&source, targetRows, targetCols, interpolation, &output);
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
