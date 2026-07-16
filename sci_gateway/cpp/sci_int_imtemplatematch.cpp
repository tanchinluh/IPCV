#include "ipcv_gateway_common.h"
#include "ipcv_gateway_image.h"

#include <cstring>

int sci_int_imtemplatematch(char *fname, void *pvApiCtx)
{
    IpcvDecodedImage source;
    IpcvDecodedImage templ;
    IpcvDecodedImage score;
    char *method_name = NULL;
    std::memset(&score, 0, sizeof(score));

    CheckInputArgument(pvApiCtx, 3, 3);
    CheckOutputArgument(pvApiCtx, 1, 1);

    int iRet = ipcv_get_image_argument(pvApiCtx, 1, source);
    if (iRet)
    {
        Scierror(999, "%s: source image expected.\n", fname);
        return iRet;
    }
    iRet = ipcv_get_image_argument(pvApiCtx, 2, templ);
    if (iRet)
    {
        ipcv_release_image_argument(source);
        Scierror(999, "%s: template image expected.\n", fname);
        return iRet;
    }
    iRet = GetString(3, method_name, pvApiCtx);
    if (iRet || method_name == NULL)
    {
        ipcv_release_image_argument(source);
        ipcv_release_image_argument(templ);
        Scierror(999, "%s: matching method string expected.\n", fname);
        return iRet ? iRet : -1;
    }

    int method = IPCV_TEMPLATE_CCORR_NORMED;
    if (std::strcmp(method_name, "ccorr") == 0) method = IPCV_TEMPLATE_CCORR;
    else if (std::strcmp(method_name, "ccorr_normed") == 0) method = IPCV_TEMPLATE_CCORR_NORMED;
    else if (std::strcmp(method_name, "ccoeff") == 0) method = IPCV_TEMPLATE_CCOEFF;
    else if (std::strcmp(method_name, "ccoeff_normed") == 0) method = IPCV_TEMPLATE_CCOEFF_NORMED;
    else
    {
        Scierror(999, "%s: method must be ccorr, ccoeff, ccorr_normed, or ccoeff_normed.\n", fname);
        freeAllocatedSingleString(method_name);
        ipcv_release_image_argument(source);
        ipcv_release_image_argument(templ);
        return -1;
    }
    freeAllocatedSingleString(method_name);

    iRet = ipcv_template_match_image(&source, &templ, method, &score);
    ipcv_release_image_argument(source);
    ipcv_release_image_argument(templ);
    if (iRet)
    {
        Scierror(999, "%s: %s\n", fname, score.error);
        ipcv_free_decoded_image(&score);
        return iRet;
    }

    iRet = ipcv_set_image_argument(pvApiCtx, 1, score);
    ipcv_free_decoded_image(&score);
    return iRet;
}
