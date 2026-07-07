/*******************************************************************************
 * SIVP - Scilab Image and Video Processing toolbox
 * Copyright (C) 2008  Jia Wu
 *
 * IPCV - Scilab Image Processing and Computer Vision toolbox
 * Copyright (C) 2017  Tan Chin Luh
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version.
 *******************************************************************************/

#include "ipcv_gateway_common.h"
#include "ipcv_gateway_image.h"

#include <string.h>

int sci_impyramid(char *fname, void *pvApiCtx)
{
    IpcvDecodedImage source;
    IpcvDecodedImage output;
    char *directionName = NULL;
    int direction = IPCV_PYRAMID_REDUCE;

    memset(&output, 0, sizeof(output));
    CheckInputArgument(pvApiCtx, 2, 2);
    CheckOutputArgument(pvApiCtx, 1, 1);

    int iRet = ipcv_get_image_argument(pvApiCtx, 1, source);
    if (iRet)
    {
        Scierror(999, "%s: Wrong type for input argument #%d: Image expected.\n", fname, 1);
        return iRet;
    }

    iRet = GetString(2, directionName, pvApiCtx);
    if (iRet || directionName == NULL)
    {
        Scierror(999, "%s: Wrong type for input argument #%d: String expected.\n", fname, 2);
        ipcv_release_image_argument(source);
        return -1;
    }

    if (strcmp(directionName, "reduce") == 0)
    {
        direction = IPCV_PYRAMID_REDUCE;
    }
    else if (strcmp(directionName, "expand") == 0)
    {
        direction = IPCV_PYRAMID_EXPAND;
    }
    else
    {
        Scierror(999, "%s: Undefined pyramid direction '%s'.\n", fname, directionName);
        ipcv_release_image_argument(source);
        return -1;
    }

    iRet = ipcv_pyramid_image(&source, direction, &output);
    ipcv_release_image_argument(source);
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
