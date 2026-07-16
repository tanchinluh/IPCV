#include "ipcv_gateway_common.h"
#include "ipcv_gateway_image.h"

#include <cmath>
#include <cstring>

int sci_int_imsuperpixels(char *fname, void *pvApiCtx)
{
    IpcvDecodedImage source;
    IpcvDecodedImage labels;
    IpcvDecodedImage contours;
    double *region_value = NULL;
    double *ruler_value = NULL;
    double *iterations_value = NULL;
    int rows = 0;
    int cols = 0;
    std::memset(&labels, 0, sizeof(labels));
    std::memset(&contours, 0, sizeof(contours));

    CheckInputArgument(pvApiCtx, 1, 4);
    CheckOutputArgument(pvApiCtx, 2, 2);
    int iRet = ipcv_get_image_argument(pvApiCtx, 1, source);
    if (iRet)
    {
        Scierror(999, "%s: image input expected.\n", fname);
        return iRet;
    }
    int region_size = 20;
    double ruler = 10.0;
    int iterations = 10;
    if (nbInputArgument(pvApiCtx) >= 2)
    {
        iRet = GetDouble(2, region_value, rows, cols, pvApiCtx);
        if (iRet || rows * cols != 1) { iRet = -1; }
        if (!iRet) region_size = static_cast<int>(std::round(*region_value));
    }
    if (!iRet && nbInputArgument(pvApiCtx) >= 3)
    {
        iRet = GetDouble(3, ruler_value, rows, cols, pvApiCtx);
        if (iRet || rows * cols != 1) { iRet = -1; }
        if (!iRet) ruler = *ruler_value;
    }
    if (!iRet && nbInputArgument(pvApiCtx) >= 4)
    {
        iRet = GetDouble(4, iterations_value, rows, cols, pvApiCtx);
        if (iRet || rows * cols != 1) { iRet = -1; }
        if (!iRet) iterations = static_cast<int>(std::round(*iterations_value));
    }
    if (iRet)
    {
        ipcv_release_image_argument(source);
        Scierror(999, "%s: optional parameters must be scalar values.\n", fname);
        return -1;
    }

    iRet = ipcv_superpixels_image(&source, region_size, ruler, iterations, &labels, &contours);
    ipcv_release_image_argument(source);
    if (iRet)
    {
        Scierror(999, "%s: %s\n", fname, labels.error);
        ipcv_free_decoded_image(&labels);
        ipcv_free_decoded_image(&contours);
        return iRet;
    }
    iRet = ipcv_set_image_argument(pvApiCtx, 1, labels);
    if (!iRet) iRet = ipcv_set_image_argument(pvApiCtx, 2, contours);
    ipcv_free_decoded_image(&labels);
    ipcv_free_decoded_image(&contours);
    return iRet;
}
