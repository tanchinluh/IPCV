/***********************************************************************
 * IPCV - Scilab Image Processing and Computer Vision toolbox
 * Common gateway helpers for Scilab API argument exchange.
 ***********************************************************************/

#ifndef IPCV_GATEWAY_COMMON_H
#define IPCV_GATEWAY_COMMON_H

#ifndef TRUE
#define TRUE 1
#endif
#ifndef FALSE
#define FALSE 0
#endif

#define IPCV_ABS(a) ((a) < 0 ? (-(a)) : (a))
#define IPCV_FLOAT 32
#define IPCV_DOUBLE 64

#include <Scierror.h>
#include <api_scilab.h>
#include <sciprint.h>

#include <algorithm>
#include <cmath>
#include <cstdlib>
#include <cstring>
#include <fstream>
#include <iostream>
#include <stdio.h>
#include <stdlib.h>
#include <string>
#include <sys/stat.h>
#include <sys/types.h>
#include <vector>

#include <opencv2/core.hpp>
#include <opencv2/core/ocl.hpp>
#include <opencv2/core/version.hpp>
#include <opencv2/dnn.hpp>
#include <opencv2/dnn/shape_utils.hpp>
#include <opencv2/dnn_superres.hpp>
#if CV_VERSION_MAJOR >= 5
#include <opencv2/features.hpp>
#else
#include <opencv2/features2d.hpp>
#endif
#include <opencv2/highgui.hpp>
#include <opencv2/imgcodecs.hpp>
#include <opencv2/imgproc.hpp>
#include <opencv2/photo.hpp>
#include <opencv2/stitching.hpp>
#include <opencv2/tracking.hpp>
#include <opencv2/video.hpp>
#include <opencv2/videoio.hpp>
#include <opencv2/xfeatures2d.hpp>

#define MAX_AVI_FILE_NUM 32
#define MAX_FILENAME_LENGTH 2048
#define MAX_DL_NUM 3
#define MAX_TRACK_NUM 3

using namespace cv;
using namespace cv::dnn;
using namespace std;

extern char sIPCV_PATH[MAX_FILENAME_LENGTH];

extern "C"
{
	int sci_addframe(char * fname, void* pvApiCtx);
	int sci_aviaddframe(char * fname, void* pvApiCtx);
	int sci_aviclose(char *fname, void* pvApiCtx);
	int sci_avicloseall(char *fname, void* pvApiCtx);
	int sci_avifile(char *fname, void* pvApiCtx);
	int sci_aviinfo(char *fname, void* pvApiCtx);
	int sci_avilistopened(char * fname, void* pvApiCtx);
	int sci_aviopen(char *fname, void* pvApiCtx);
	int sci_avireadframe(char * fname, void* pvApiCtx);
	int sci_camclose(char *fname, void* pvApiCtx);
	int sci_camcloseall(char *fname, void* pvApiCtx);
	int sci_camlistopened(char * fname, void* pvApiCtx);
	int sci_camopen(char *fname, void* pvApiCtx);
	int sci_camread(char * fname, void* pvApiCtx);
	int sci_filter2(char * fname, void* pvApiCtx);
	int sci_imabsdiff(char * fname, void* pvApiCtx);
	int sci_imadd(char * fname, void* pvApiCtx);
	int sci_imdestroy(char * fname, void* pvApiCtx);
	int sci_imdestroyall(char * fname, void* pvApiCtx);
	int sci_imdisplay(char * fname, void* pvApiCtx);
	int sci_imdivide(char * fname, void* pvApiCtx);
	int sci_iminspect(char * fname, void* pvApiCtx);
	int sci_immultiply(char * fname, void* pvApiCtx);
	int sci_impyramid(char *fname, void* pvApiCtx);
	int sci_imresize(char * fname, void* pvApiCtx);
	int sci_imsubtract(char * fname, void* pvApiCtx);
	int sci_int_affinetransform(char * fname, void* pvApiCtx);
	int sci_int_avi_getproperty(char * fname, void* pvApiCtx);
	int sci_int_avi_setproperty(char * fname, void* pvApiCtx);
	int sci_int_bgr2lab(char * fname, void* pvApiCtx);
	int sci_int_canny(char *fname, void* pvApiCtx);
	int sci_int_cam_getproperty(char * fname, void* pvApiCtx);
	int sci_int_cam_setproperty(char * fname, void* pvApiCtx);
	int sci_int_cvtcolor(char *fname, void* pvApiCtx);
	int sci_int_detectobjects(char * fname, void* pvApiCtx);
	int sci_int_dnn_forward(char * fname, void* pvApiCtx);
	int sci_int_dnn_getFLOPS(char * fname, void* pvApiCtx);
	int sci_int_dnn_getLayerNames(char * fname, void* pvApiCtx);
	int sci_int_dnn_getLayersCount(char * fname, void* pvApiCtx);
	int sci_int_dnn_getLayerTypes(char * fname, void* pvApiCtx);
	int sci_int_dnn_getUnconnectedOutLayerNames(char * fname, void* pvApiCtx);
	int sci_int_dnn_getParam(char * fname, void* pvApiCtx);
	int sci_int_dnn_init(char * fname, void* pvApiCtx);
	int sci_int_dnn_list(char * fname, void* pvApiCtx);
	int sci_int_dnn_setPreferableBackendTarget(char * fname, void* pvApiCtx);
	int sci_int_dnn_superres(char * fname, void* pvApiCtx);
	int sci_int_dnn_superres_init(char * fname, void* pvApiCtx);
	int sci_int_dnn_superres_upsample(char * fname, void* pvApiCtx);
	int sci_int_dnn_unload(char * fname, void* pvApiCtx);
	int sci_int_dnn_unloadall(char * fname, void* pvApiCtx);
	int sci_int_getaffinetransform(char * fname, void* pvApiCtx);
	int sci_int_getperspectivetransform(char * fname, void* pvApiCtx);
	int sci_int_imadapthistequal(char * fname, void* pvApiCtx);
	int sci_int_imbilateralfilter(char * fname, void* pvApiCtx);
	int sci_int_imblur(char * fname, void* pvApiCtx);
	int sci_int_imboundingRect(char * fname, void* pvApiCtx);
	int sci_int_imconvexHull(char * fname, void* pvApiCtx);
	int sci_int_imconvexityDefects(char * fname, void* pvApiCtx);
	int sci_int_imcontourarea(char * fname, void* pvApiCtx);
	int sci_int_imconnectedcomponents(char * fname, void* pvApiCtx);
	int sci_int_imcreatese(char * fname, void* pvApiCtx);
	int sci_int_imdct(char * fname, void* pvApiCtx);
	int sci_int_imdenoise(char * fname, void* pvApiCtx);
	int sci_int_imdetect_BRISK(char * fname, void* pvApiCtx);
	int sci_int_imdetect_FAST(char * fname, void* pvApiCtx);
	int sci_int_imdetect_GFTT(char * fname, void* pvApiCtx);
	int sci_int_imdetect_MSER(char * fname, void* pvApiCtx);
	int sci_int_imdetect_ORB(char * fname, void* pvApiCtx);
	int sci_int_imdetect_SIFT(char * fname, void* pvApiCtx);
	int sci_int_imdetect_STAR(char * fname, void* pvApiCtx);
	int sci_int_imdetect_SURF(char * fname, void* pvApiCtx);
	int sci_int_imdilate(char * fname, void* pvApiCtx);
	int sci_int_imdist(char * fname, void* pvApiCtx);
	int sci_int_imdistransf(char * fname, void* pvApiCtx);
	int sci_int_imdrawmatches(char * fname, void* pvApiCtx);
	int sci_int_imerode(char * fname, void* pvApiCtx);
	int sci_int_imextract_DescriptorBRISK(char * fname, void* pvApiCtx);
	int sci_int_imextract_DescriptorORB(char * fname, void* pvApiCtx);
	int sci_int_imextract_DescriptorSIFT(char * fname, void* pvApiCtx);
	int sci_int_imextract_DescriptorSURF(char * fname, void* pvApiCtx);
	int sci_int_imfill(char * fname, void* pvApiCtx);
	int sci_int_imfilter(char * fname, void* pvApiCtx);
	int sci_int_imfindContours(char * fname, void* pvApiCtx);
	int sci_int_imfinfo(char *fname, void* pvApiCtx);
	int sci_int_imgaussianblur(char * fname, void* pvApiCtx);
	int sci_int_imreadable(char *fname, void* pvApiCtx);
	int sci_int_imhough(char * fname, void* pvApiCtx);
	int sci_int_imhoughcircles(char * fname, void* pvApiCtx);
	int sci_int_imidct(char * fname, void* pvApiCtx);
	int sci_int_ipcv_opencv_version(char * fname, void* pvApiCtx);
	int sci_int_iminpaint(char * fname, void* pvApiCtx);
	int sci_int_imlabel(char * fname, void* pvApiCtx);
	int sci_int_imlogpolar(char * fname, void* pvApiCtx);
	int sci_int_immatch_BruteForce(char * fname, void* pvApiCtx);
	int sci_int_immatch_Flann(char * fname, void* pvApiCtx);
	int sci_int_immedian(char * fname, void* pvApiCtx);
	int sci_int_immorphologyex(char * fname, void* pvApiCtx);
	int sci_int_imthin(char * fname, void* pvApiCtx);
	int sci_int_imthreshold(char * fname, void* pvApiCtx);
	int sci_int_imradon(char * fname, void* pvApiCtx);
	int sci_int_imread(char * fname, void* pvApiCtx);
	int sci_int_imreadmulti(char * fname, void* pvApiCtx);
	int sci_int_imrotate(char * fname, void* pvApiCtx);
	int sci_int_imstitchImage(char * fname, void* pvApiCtx);
	int sci_int_imsuperres(char * fname, void* pvApiCtx);
	int sci_int_imwatershed(char * fname, void* pvApiCtx);
	int sci_int_imwrite(char * fname, void* pvApiCtx);
	int sci_int_imwritable(char *fname, void* pvApiCtx);
	int sci_int_imarclength(char * fname, void* pvApiCtx);
	int sci_int_perspectivetransform(char * fname, void* pvApiCtx);
	int sci_int_rgb2gray(char * fname, void* pvApiCtx);
	int sci_int_rgb2lab(char * fname, void* pvApiCtx);
	int sci_int_sobel(char * fname, void* pvApiCtx);
	int sci_int_tracker_init(char * fname, void* pvApiCtx);
	int sci_int_tracker_unloadall(char * fname, void* pvApiCtx);
	int sci_int_tracker_update(char * fname, void* pvApiCtx);
	int sci_ipcv_init(char * fname, void* pvApiCtx);
	int sci_mat2utfimg(char * fname, void* pvApiCtx);
}

int GetString(int nPos, char *&pstName, void* pvApiCtx);
int SetString(int nPos, char *&pstName, void* pvApiCtx);
int GetDouble(int nPos, double *&pstdata, int& iRows, int& iCols, void* pvApiCtx);
int GetDouble2(int nPos, double *&pstdata, int& iRows, int& iCols, void* pvApiCtx);
int SetDouble(int nPos, double *&pstdata, int& iRows, int& iCols, void* pvApiCtx);
string type2str(int type);
int is_binary_image(Mat& image);

#endif
