#include "common.h"
#include "ipcv_gateway_image.h"

#include <string.h>

int sci_int_rgb2gray(char *fname, void *pvApiCtx)
{
    IpcvDecodedImage source;
    IpcvDecodedImage output;

    memset(&output, 0, sizeof(output));
    CheckInputArgument(pvApiCtx, 1, 1);
    CheckOutputArgument(pvApiCtx, 1, 1);

    int iRet = ipcv_get_image_argument(pvApiCtx, 1, source);
    if (iRet)
    {
        Scierror(999, "%s: Wrong type for input argument #%d: RGB image expected.\n", fname, 1);
        return iRet;
    }

    iRet = ipcv_convert_color_image(&source, IPCV_COLOR_RGB2GRAY, &output);
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
