#include "common.h"
#include "ipcv_gateway_image.h"

#include <math.h>
#include <string.h>

int sci_int_iminpaint(char *fname, void *pvApiCtx)
{
    IpcvDecodedImage source;
    IpcvDecodedImage mask;
    IpcvDecodedImage output;
    double *radius = NULL;
    double *method = NULL;
    int rows = 0;
    int cols = 0;

    memset(&output, 0, sizeof(output));
    CheckInputArgument(pvApiCtx, 4, 4);
    CheckOutputArgument(pvApiCtx, 1, 1);

    int iRet = ipcv_get_image_argument(pvApiCtx, 1, source);
    if (iRet)
    {
        Scierror(999, "%s: Wrong type for input argument #%d: Image expected.\n", fname, 1);
        return iRet;
    }

    iRet = ipcv_get_image_argument(pvApiCtx, 2, mask);
    if (iRet)
    {
        Scierror(999, "%s: Wrong type for input argument #%d: Mask expected.\n", fname, 2);
        ipcv_release_image_argument(source);
        return iRet;
    }

    GetDouble(3, radius, rows, cols, pvApiCtx);
    GetDouble(4, method, rows, cols, pvApiCtx);

    iRet = ipcv_inpaint_image(&source, &mask, *radius, static_cast<int>(round(*method)), &output);
    ipcv_release_image_argument(source);
    ipcv_release_image_argument(mask);
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
