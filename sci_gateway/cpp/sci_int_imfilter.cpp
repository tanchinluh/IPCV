/***********************************************************************
 * SIVP - Scilab Image and Video Processing toolbox
 * Copyright (C) 2006  Shiqi Yu
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

#include <string.h>

int sci_int_imfilter(char *fname, void *pvApiCtx)
{
    IpcvDecodedImage source;
    IpcvDecodedImage kernel;
    IpcvDecodedImage output;

    memset(&output, 0, sizeof(output));
    CheckInputArgument(pvApiCtx, 2, 2);
    CheckOutputArgument(pvApiCtx, 0, 1);

    int iRet = ipcv_get_image_argument(pvApiCtx, 1, source);
    if (iRet)
    {
        Scierror(999, "%s: Wrong type for input argument #%d: Image expected.\n", fname, 1);
        return iRet;
    }

    iRet = ipcv_get_image_argument(pvApiCtx, 2, kernel);
    if (iRet)
    {
        Scierror(999, "%s: Wrong type for input argument #%d: 2D kernel expected.\n", fname, 2);
        ipcv_release_image_argument(source);
        return iRet;
    }

    iRet = ipcv_filter2d_image(&source, &kernel, IPCV_FILTER_OUTPUT_SAME_DEPTH, &output);
    ipcv_release_image_argument(source);
    ipcv_release_image_argument(kernel);
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
