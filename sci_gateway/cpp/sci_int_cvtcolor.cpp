#include "ipcv_gateway_common.h"
#include "ipcv_gateway_image.h"

#include <string.h>

static int ipcv_color_conversion_from_string(const char *code)
{
    if (strcmp(code, "rgb2hsv") == 0)
    {
        return IPCV_COLOR_RGB2HSV;
    }
    if (strcmp(code, "rgb2lab") == 0)
    {
        return IPCV_COLOR_RGB2LAB;
    }
    if (strcmp(code, "bgr2lab") == 0)
    {
        return IPCV_COLOR_BGR2LAB;
    }
    if (strcmp(code, "hsv2rgb") == 0)
    {
        return IPCV_COLOR_HSV2RGB;
    }
    if (strcmp(code, "rgb2ycrcb") == 0)
    {
        return IPCV_COLOR_RGB2YCRCB;
    }
    if (strcmp(code, "ycrcb2rgb") == 0)
    {
        return IPCV_COLOR_YCRCB2RGB;
    }
    if (strcmp(code, "lab2rgb") == 0)
    {
        return IPCV_COLOR_LAB2RGB;
    }
    if (strcmp(code, "rgb2gray") == 0)
    {
        return IPCV_COLOR_RGB2GRAY;
    }
    if (strcmp(code, "gray2rgb") == 0)
    {
        return IPCV_COLOR_GRAY2RGB;
    }
    if (strcmp(code, "rgb2hls") == 0)
    {
        return IPCV_COLOR_RGB2HLS;
    }
    if (strcmp(code, "hls2rgb") == 0)
    {
        return IPCV_COLOR_HLS2RGB;
    }
    if (strcmp(code, "rgb2xyz") == 0)
    {
        return IPCV_COLOR_RGB2XYZ;
    }
    if (strcmp(code, "xyz2rgb") == 0)
    {
        return IPCV_COLOR_XYZ2RGB;
    }
    if (strcmp(code, "rgb2luv") == 0)
    {
        return IPCV_COLOR_RGB2LUV;
    }
    if (strcmp(code, "luv2rgb") == 0)
    {
        return IPCV_COLOR_LUV2RGB;
    }
    if (strcmp(code, "rgb2yuv") == 0)
    {
        return IPCV_COLOR_RGB2YUV;
    }
    if (strcmp(code, "yuv2rgb") == 0)
    {
        return IPCV_COLOR_YUV2RGB;
    }
    return -1;
}

int sci_int_cvtcolor(char *fname, void *pvApiCtx)
{
    IpcvDecodedImage source;
    IpcvDecodedImage output;
    char *cvtCode = NULL;

    memset(&output, 0, sizeof(output));
    CheckInputArgument(pvApiCtx, 2, 2);
    CheckOutputArgument(pvApiCtx, 1, 1);

    int iRet = ipcv_get_image_argument(pvApiCtx, 1, source);
    if (iRet)
    {
        Scierror(999, "%s: Wrong type for input argument #%d: 3-channel image expected.\n", fname, 1);
        return iRet;
    }

    GetString(2, cvtCode, pvApiCtx);
    const int conversion = ipcv_color_conversion_from_string(cvtCode);
    if (conversion < 0)
    {
        Scierror(999, "%s: Unsupported conversion code %s.\n", fname, cvtCode);
        ipcv_release_image_argument(source);
        return -1;
    }

    iRet = ipcv_convert_color_image(&source, conversion, &output);
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
