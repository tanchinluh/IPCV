#include "ipcv_gateway_common.h"
#include "ipcv_gateway_image.h"

#include <cmath>
#include <cstring>

int sci_int_imsegkmeans(char *fname, void *pvApiCtx)
{
    IpcvDecodedImage source;
    IpcvDecodedImage labels;
    IpcvDecodedImage centers;
    double *cluster_value = NULL;
    int rows = 0;
    int cols = 0;
    std::memset(&labels, 0, sizeof(labels));
    std::memset(&centers, 0, sizeof(centers));

    CheckInputArgument(pvApiCtx, 2, 2);
    CheckOutputArgument(pvApiCtx, 2, 2);
    int iRet = ipcv_get_image_argument(pvApiCtx, 1, source);
    if (iRet)
    {
        Scierror(999, "%s: image input expected.\n", fname);
        return iRet;
    }
    iRet = GetDouble(2, cluster_value, rows, cols, pvApiCtx);
    if (iRet || rows * cols != 1)
    {
        ipcv_release_image_argument(source);
        Scierror(999, "%s: cluster count must be a scalar.\n", fname);
        return -1;
    }

    iRet = ipcv_kmeans_image(&source, static_cast<int>(std::round(*cluster_value)), &labels, &centers);
    ipcv_release_image_argument(source);
    if (iRet)
    {
        Scierror(999, "%s: %s\n", fname, labels.error);
        ipcv_free_decoded_image(&labels);
        ipcv_free_decoded_image(&centers);
        return iRet;
    }

    iRet = ipcv_set_image_argument(pvApiCtx, 1, labels);
    if (!iRet) iRet = ipcv_set_image_argument(pvApiCtx, 2, centers);
    ipcv_free_decoded_image(&labels);
    ipcv_free_decoded_image(&centers);
    return iRet;
}
