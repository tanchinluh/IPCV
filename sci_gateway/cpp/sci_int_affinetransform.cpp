#include "common.h"
#include "ipcv_gateway_image.h"

#include <string.h>

int sci_int_affinetransform(char *fname, void *pvApiCtx)
{
    IpcvDecodedImage source;
    IpcvDecodedImage matrix;
    IpcvDecodedImage output;
    double *widthValue = NULL;
    double *heightValue = NULL;
    int rows = 0;
    int cols = 0;

    memset(&output, 0, sizeof(output));
    CheckInputArgument(pvApiCtx, 2, 4);
    CheckOutputArgument(pvApiCtx, 0, 1);

    int iRet = ipcv_get_image_argument(pvApiCtx, 1, source);
    if (iRet)
    {
        Scierror(999, "%s: Wrong type for input argument #%d: Image expected.\n", fname, 1);
        return iRet;
    }

    iRet = ipcv_get_image_argument(pvApiCtx, 2, matrix);
    if (iRet)
    {
        Scierror(999, "%s: Wrong type for input argument #%d: 2x3 affine matrix expected.\n", fname, 2);
        ipcv_release_image_argument(source);
        return iRet;
    }

    GetDouble(3, widthValue, rows, cols, pvApiCtx);
    GetDouble(4, heightValue, rows, cols, pvApiCtx);

    iRet = ipcv_affine_transform_image(&source, &matrix, static_cast<int>(*heightValue), static_cast<int>(*widthValue), &output);
    ipcv_release_image_argument(source);
    ipcv_release_image_argument(matrix);
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
