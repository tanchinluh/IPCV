/***********************************************************************
 * IPCV - Scilab Image Processing and Computer Vision toolbox
 * Copyright (C) 2017  Tan Chin Luh
 ***********************************************************************/

#include "common.h"
#include "ipcv_gateway_image.h"

#include <string.h>

int sci_int_imerode(char *fname, void *pvApiCtx)
{
    IpcvDecodedImage source;
    IpcvDecodedImage element;
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

    iRet = ipcv_get_image_argument(pvApiCtx, 2, element);
    if (iRet)
    {
        Scierror(999, "%s: Wrong type for input argument #%d: Structuring element expected.\n", fname, 2);
        ipcv_release_image_argument(source);
        return iRet;
    }

    iRet = ipcv_morphology_image(&source, &element, 0, &output);
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
