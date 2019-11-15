#include <wchar.h>
#include "libgw_ipcv.hxx"
extern "C"
{
#include "libgw_ipcv.h"
#include "addfunction.h"
}

#define MODULE_NAME L"libgw_ipcv"

int libgw_ipcv(wchar_t* _pwstFuncName)
{
    if(wcscmp(_pwstFuncName, L"imdisplay") == 0){ addCStackFunction(L"imdisplay", &sci_imdisplay, MODULE_NAME); }
    if(wcscmp(_pwstFuncName, L"aviopen") == 0){ addCStackFunction(L"aviopen", &sci_aviopen, MODULE_NAME); }
    if(wcscmp(_pwstFuncName, L"int_imextract_DescriptorORB") == 0){ addCStackFunction(L"int_imextract_DescriptorORB", &sci_int_imextract_DescriptorORB, MODULE_NAME); }
    if(wcscmp(_pwstFuncName, L"int_imfilter") == 0){ addCStackFunction(L"int_imfilter", &sci_int_imfilter, MODULE_NAME); }
    if(wcscmp(_pwstFuncName, L"imresize") == 0){ addCStackFunction(L"imresize", &sci_imresize, MODULE_NAME); }
    if(wcscmp(_pwstFuncName, L"int_dnn_unloadall") == 0){ addCStackFunction(L"int_dnn_unloadall", &sci_int_dnn_unloadall, MODULE_NAME); }
    if(wcscmp(_pwstFuncName, L"camopen") == 0){ addCStackFunction(L"camopen", &sci_camopen, MODULE_NAME); }
    if(wcscmp(_pwstFuncName, L"imabsdiff") == 0){ addCStackFunction(L"imabsdiff", &sci_imabsdiff, MODULE_NAME); }
    if(wcscmp(_pwstFuncName, L"int_affinetransform") == 0){ addCStackFunction(L"int_affinetransform", &sci_int_affinetransform, MODULE_NAME); }
    if(wcscmp(_pwstFuncName, L"addframe") == 0){ addCStackFunction(L"addframe", &sci_addframe, MODULE_NAME); }
    if(wcscmp(_pwstFuncName, L"int_imidct") == 0){ addCStackFunction(L"int_imidct", &sci_int_imidct, MODULE_NAME); }
    if(wcscmp(_pwstFuncName, L"imadd") == 0){ addCStackFunction(L"imadd", &sci_imadd, MODULE_NAME); }
    if(wcscmp(_pwstFuncName, L"int_imextract_DescriptorBRISK") == 0){ addCStackFunction(L"int_imextract_DescriptorBRISK", &sci_int_imextract_DescriptorBRISK, MODULE_NAME); }
    if(wcscmp(_pwstFuncName, L"camclose") == 0){ addCStackFunction(L"camclose", &sci_camclose, MODULE_NAME); }
    if(wcscmp(_pwstFuncName, L"int_imdetect_FAST") == 0){ addCStackFunction(L"int_imdetect_FAST", &sci_int_imdetect_FAST, MODULE_NAME); }
    if(wcscmp(_pwstFuncName, L"avireadframe") == 0){ addCStackFunction(L"avireadframe", &sci_avireadframe, MODULE_NAME); }
    if(wcscmp(_pwstFuncName, L"int_dnn_getParam") == 0){ addCStackFunction(L"int_dnn_getParam", &sci_int_dnn_getParam, MODULE_NAME); }
    if(wcscmp(_pwstFuncName, L"imdestroyall") == 0){ addCStackFunction(L"imdestroyall", &sci_imdestroyall, MODULE_NAME); }
    if(wcscmp(_pwstFuncName, L"int_perspectivetransform") == 0){ addCStackFunction(L"int_perspectivetransform", &sci_int_perspectivetransform, MODULE_NAME); }
    if(wcscmp(_pwstFuncName, L"int_imdetect_ORB") == 0){ addCStackFunction(L"int_imdetect_ORB", &sci_int_imdetect_ORB, MODULE_NAME); }
    if(wcscmp(_pwstFuncName, L"int_immatch_BruteForce") == 0){ addCStackFunction(L"int_immatch_BruteForce", &sci_int_immatch_BruteForce, MODULE_NAME); }
    if(wcscmp(_pwstFuncName, L"int_imradon") == 0){ addCStackFunction(L"int_imradon", &sci_int_imradon, MODULE_NAME); }
    if(wcscmp(_pwstFuncName, L"int_dnn_list") == 0){ addCStackFunction(L"int_dnn_list", &sci_int_dnn_list, MODULE_NAME); }
    if(wcscmp(_pwstFuncName, L"int_imdetect_BRISK") == 0){ addCStackFunction(L"int_imdetect_BRISK", &sci_int_imdetect_BRISK, MODULE_NAME); }
    if(wcscmp(_pwstFuncName, L"avifile") == 0){ addCStackFunction(L"avifile", &sci_avifile, MODULE_NAME); }
    if(wcscmp(_pwstFuncName, L"int_imlogpolar") == 0){ addCStackFunction(L"int_imlogpolar", &sci_int_imlogpolar, MODULE_NAME); }
    if(wcscmp(_pwstFuncName, L"int_imhough") == 0){ addCStackFunction(L"int_imhough", &sci_int_imhough, MODULE_NAME); }
    if(wcscmp(_pwstFuncName, L"int_dnn_getLayersCount") == 0){ addCStackFunction(L"int_dnn_getLayersCount", &sci_int_dnn_getLayersCount, MODULE_NAME); }
    if(wcscmp(_pwstFuncName, L"int_imhoughcircles") == 0){ addCStackFunction(L"int_imhoughcircles", &sci_int_imhoughcircles, MODULE_NAME); }
    if(wcscmp(_pwstFuncName, L"int_imsuperres") == 0){ addCStackFunction(L"int_imsuperres", &sci_int_imsuperres, MODULE_NAME); }
    if(wcscmp(_pwstFuncName, L"int_imadapthistequal") == 0){ addCStackFunction(L"int_imadapthistequal", &sci_int_imadapthistequal, MODULE_NAME); }
    if(wcscmp(_pwstFuncName, L"aviinfo") == 0){ addCStackFunction(L"aviinfo", &sci_aviinfo, MODULE_NAME); }
    if(wcscmp(_pwstFuncName, L"int_imextract_DescriptorSIFT") == 0){ addCStackFunction(L"int_imextract_DescriptorSIFT", &sci_int_imextract_DescriptorSIFT, MODULE_NAME); }
    if(wcscmp(_pwstFuncName, L"int_imerode") == 0){ addCStackFunction(L"int_imerode", &sci_int_imerode, MODULE_NAME); }
    if(wcscmp(_pwstFuncName, L"int_imextract_DescriptorSURF") == 0){ addCStackFunction(L"int_imextract_DescriptorSURF", &sci_int_imextract_DescriptorSURF, MODULE_NAME); }
    if(wcscmp(_pwstFuncName, L"int_immatch_Flann") == 0){ addCStackFunction(L"int_immatch_Flann", &sci_int_immatch_Flann, MODULE_NAME); }
    if(wcscmp(_pwstFuncName, L"int_imfindContours") == 0){ addCStackFunction(L"int_imfindContours", &sci_int_imfindContours, MODULE_NAME); }
    if(wcscmp(_pwstFuncName, L"imdestroy") == 0){ addCStackFunction(L"imdestroy", &sci_imdestroy, MODULE_NAME); }
    if(wcscmp(_pwstFuncName, L"int_canny") == 0){ addCStackFunction(L"int_canny", &sci_int_canny, MODULE_NAME); }
    if(wcscmp(_pwstFuncName, L"int_tracker_unloadall") == 0){ addCStackFunction(L"int_tracker_unloadall", &sci_int_tracker_unloadall, MODULE_NAME); }
    if(wcscmp(_pwstFuncName, L"camlistopened") == 0){ addCStackFunction(L"camlistopened", &sci_camlistopened, MODULE_NAME); }
    if(wcscmp(_pwstFuncName, L"imsubtract") == 0){ addCStackFunction(L"imsubtract", &sci_imsubtract, MODULE_NAME); }
    if(wcscmp(_pwstFuncName, L"int_imlabel") == 0){ addCStackFunction(L"int_imlabel", &sci_int_imlabel, MODULE_NAME); }
    if(wcscmp(_pwstFuncName, L"int_imdct") == 0){ addCStackFunction(L"int_imdct", &sci_int_imdct, MODULE_NAME); }
    if(wcscmp(_pwstFuncName, L"int_cvtcolor") == 0){ addCStackFunction(L"int_cvtcolor", &sci_int_cvtcolor, MODULE_NAME); }
    if(wcscmp(_pwstFuncName, L"int_imfill") == 0){ addCStackFunction(L"int_imfill", &sci_int_imfill, MODULE_NAME); }
    if(wcscmp(_pwstFuncName, L"int_rgb2gray") == 0){ addCStackFunction(L"int_rgb2gray", &sci_int_rgb2gray, MODULE_NAME); }
    if(wcscmp(_pwstFuncName, L"avicloseall") == 0){ addCStackFunction(L"avicloseall", &sci_avicloseall, MODULE_NAME); }
    if(wcscmp(_pwstFuncName, L"int_imwrite") == 0){ addCStackFunction(L"int_imwrite", &sci_int_imwrite, MODULE_NAME); }
    if(wcscmp(_pwstFuncName, L"int_dnn_getLayerNames") == 0){ addCStackFunction(L"int_dnn_getLayerNames", &sci_int_dnn_getLayerNames, MODULE_NAME); }
    if(wcscmp(_pwstFuncName, L"int_detectobjects") == 0){ addCStackFunction(L"int_detectobjects", &sci_int_detectobjects, MODULE_NAME); }
    if(wcscmp(_pwstFuncName, L"int_imstitchImage") == 0){ addCStackFunction(L"int_imstitchImage", &sci_int_imstitchImage, MODULE_NAME); }
    if(wcscmp(_pwstFuncName, L"int_immorphologyex") == 0){ addCStackFunction(L"int_immorphologyex", &sci_int_immorphologyex, MODULE_NAME); }
    if(wcscmp(_pwstFuncName, L"int_sobel") == 0){ addCStackFunction(L"int_sobel", &sci_int_sobel, MODULE_NAME); }
    if(wcscmp(_pwstFuncName, L"immultiply") == 0){ addCStackFunction(L"immultiply", &sci_immultiply, MODULE_NAME); }
    if(wcscmp(_pwstFuncName, L"int_imconvexHull") == 0){ addCStackFunction(L"int_imconvexHull", &sci_int_imconvexHull, MODULE_NAME); }
    if(wcscmp(_pwstFuncName, L"int_imread2") == 0){ addCStackFunction(L"int_imread2", &sci_int_imread2, MODULE_NAME); }
    if(wcscmp(_pwstFuncName, L"int_tracker_init") == 0){ addCStackFunction(L"int_tracker_init", &sci_int_tracker_init, MODULE_NAME); }
    if(wcscmp(_pwstFuncName, L"int_imdetect_SURF") == 0){ addCStackFunction(L"int_imdetect_SURF", &sci_int_imdetect_SURF, MODULE_NAME); }
    if(wcscmp(_pwstFuncName, L"int_immedian") == 0){ addCStackFunction(L"int_immedian", &sci_int_immedian, MODULE_NAME); }
    if(wcscmp(_pwstFuncName, L"int_imdilate") == 0){ addCStackFunction(L"int_imdilate", &sci_int_imdilate, MODULE_NAME); }
    if(wcscmp(_pwstFuncName, L"int_imdrawmatches") == 0){ addCStackFunction(L"int_imdrawmatches", &sci_int_imdrawmatches, MODULE_NAME); }
    if(wcscmp(_pwstFuncName, L"int_imcreatese") == 0){ addCStackFunction(L"int_imcreatese", &sci_int_imcreatese, MODULE_NAME); }
    if(wcscmp(_pwstFuncName, L"aviaddframe") == 0){ addCStackFunction(L"aviaddframe", &sci_aviaddframe, MODULE_NAME); }
    if(wcscmp(_pwstFuncName, L"int_dnn_unload") == 0){ addCStackFunction(L"int_dnn_unload", &sci_int_dnn_unload, MODULE_NAME); }
    if(wcscmp(_pwstFuncName, L"camread") == 0){ addCStackFunction(L"camread", &sci_camread, MODULE_NAME); }
    if(wcscmp(_pwstFuncName, L"ipcv_init") == 0){ addCStackFunction(L"ipcv_init", &sci_ipcv_init, MODULE_NAME); }
    if(wcscmp(_pwstFuncName, L"int_imdetect_MSER") == 0){ addCStackFunction(L"int_imdetect_MSER", &sci_int_imdetect_MSER, MODULE_NAME); }
    if(wcscmp(_pwstFuncName, L"int_dnn_forward") == 0){ addCStackFunction(L"int_dnn_forward", &sci_int_dnn_forward, MODULE_NAME); }
    if(wcscmp(_pwstFuncName, L"int_imdetect_GFTT") == 0){ addCStackFunction(L"int_imdetect_GFTT", &sci_int_imdetect_GFTT, MODULE_NAME); }
    if(wcscmp(_pwstFuncName, L"int_dnn_init") == 0){ addCStackFunction(L"int_dnn_init", &sci_int_dnn_init, MODULE_NAME); }
    if(wcscmp(_pwstFuncName, L"filter2") == 0){ addCStackFunction(L"filter2", &sci_filter2, MODULE_NAME); }
    if(wcscmp(_pwstFuncName, L"int_imdetect_STAR") == 0){ addCStackFunction(L"int_imdetect_STAR", &sci_int_imdetect_STAR, MODULE_NAME); }
    if(wcscmp(_pwstFuncName, L"impyramid") == 0){ addCStackFunction(L"impyramid", &sci_impyramid, MODULE_NAME); }
    if(wcscmp(_pwstFuncName, L"int_iminpaint") == 0){ addCStackFunction(L"int_iminpaint", &sci_int_iminpaint, MODULE_NAME); }
    if(wcscmp(_pwstFuncName, L"int_imfinfo") == 0){ addCStackFunction(L"int_imfinfo", &sci_int_imfinfo, MODULE_NAME); }
    if(wcscmp(_pwstFuncName, L"camcloseall") == 0){ addCStackFunction(L"camcloseall", &sci_camcloseall, MODULE_NAME); }
    if(wcscmp(_pwstFuncName, L"int_tracker_update") == 0){ addCStackFunction(L"int_tracker_update", &sci_int_tracker_update, MODULE_NAME); }
    if(wcscmp(_pwstFuncName, L"int_rgb2lab") == 0){ addCStackFunction(L"int_rgb2lab", &sci_int_rgb2lab, MODULE_NAME); }
    if(wcscmp(_pwstFuncName, L"int_imread") == 0){ addCStackFunction(L"int_imread", &sci_int_imread, MODULE_NAME); }
    if(wcscmp(_pwstFuncName, L"int_imrotate") == 0){ addCStackFunction(L"int_imrotate", &sci_int_imrotate, MODULE_NAME); }
    if(wcscmp(_pwstFuncName, L"int_getaffinetransform") == 0){ addCStackFunction(L"int_getaffinetransform", &sci_int_getaffinetransform, MODULE_NAME); }
    if(wcscmp(_pwstFuncName, L"avilistopened") == 0){ addCStackFunction(L"avilistopened", &sci_avilistopened, MODULE_NAME); }
    if(wcscmp(_pwstFuncName, L"int_imdetect_SIFT") == 0){ addCStackFunction(L"int_imdetect_SIFT", &sci_int_imdetect_SIFT, MODULE_NAME); }
    if(wcscmp(_pwstFuncName, L"iminspect") == 0){ addCStackFunction(L"iminspect", &sci_iminspect, MODULE_NAME); }
    if(wcscmp(_pwstFuncName, L"int_getperspectivetransform") == 0){ addCStackFunction(L"int_getperspectivetransform", &sci_int_getperspectivetransform, MODULE_NAME); }
    if(wcscmp(_pwstFuncName, L"imdivide") == 0){ addCStackFunction(L"imdivide", &sci_imdivide, MODULE_NAME); }
    if(wcscmp(_pwstFuncName, L"int_imboundingRect") == 0){ addCStackFunction(L"int_imboundingRect", &sci_int_imboundingRect, MODULE_NAME); }
    if(wcscmp(_pwstFuncName, L"aviclose") == 0){ addCStackFunction(L"aviclose", &sci_aviclose, MODULE_NAME); }
    if(wcscmp(_pwstFuncName, L"mat2utfimg") == 0){ addCStackFunction(L"mat2utfimg", &sci_mat2utfimg, MODULE_NAME); }

    return 1;
}
