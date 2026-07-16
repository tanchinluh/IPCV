#include "ipcv_gateway_common.h"
#include "ipcv_gateway_image.h"

#include <cmath>
#include <cstring>

int sci_int_imgrabcut(char *fname, void *pvApiCtx)
{
    IpcvDecodedImage source;
    IpcvDecodedImage mask;
    IpcvDecodedImage foreground;
    double *rect = NULL;
    double *iterations_value = NULL;
    int rows = 0;
    int cols = 0;
    std::memset(&mask, 0, sizeof(mask));
    std::memset(&foreground, 0, sizeof(foreground));

    CheckInputArgument(pvApiCtx, 2, 3);
    CheckOutputArgument(pvApiCtx, 2, 2);
    int iRet = ipcv_get_image_argument(pvApiCtx, 1, source);
    if (iRet)
    {
        Scierror(999, "%s: RGB image input expected.\n", fname);
        return iRet;
    }
    iRet = GetDouble(2, rect, rows, cols, pvApiCtx);
    if (iRet || rows * cols != 4)
    {
        ipcv_release_image_argument(source);
        Scierror(999, "%s: rectangle must be [x y width height].\n", fname);
        return -1;
    }
    int iterations = 5;
    if (nbInputArgument(pvApiCtx) == 3)
    {
        iRet = GetDouble(3, iterations_value, rows, cols, pvApiCtx);
        if (iRet || rows * cols != 1)
        {
            ipcv_release_image_argument(source);
            Scierror(999, "%s: iterations must be a scalar.\n", fname);
            return -1;
        }
        iterations = static_cast<int>(std::round(*iterations_value));
    }

    iRet = ipcv_grabcut_image(&source, rect, iterations, &mask, &foreground);
    ipcv_release_image_argument(source);
    if (iRet)
    {
        Scierror(999, "%s: %s\n", fname, mask.error);
        ipcv_free_decoded_image(&mask);
        ipcv_free_decoded_image(&foreground);
        return iRet;
    }
    iRet = ipcv_set_image_argument(pvApiCtx, 1, mask);
    if (!iRet) iRet = ipcv_set_image_argument(pvApiCtx, 2, foreground);
    ipcv_free_decoded_image(&mask);
    ipcv_free_decoded_image(&foreground);
    return iRet;
}
