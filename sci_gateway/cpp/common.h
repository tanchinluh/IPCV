/***********************************************************************
* SIVP - Scilab Image and Video Processing toolbox
* Original work Copyright (C) 2005  Shiqi Yu
*
* IPCV - Scilab Image Processing and Computer Vision toolbox
* Original work Copyright (C) 2017  Tan Chin Luh
*
* This program is free software; you can redistribute it and/or modify
* it under the terms of the GNU General Public License as published by
* the Free Software Foundation; either version 2 of the License, or
* (at your option) any later version.
*
* This program is distributed in the hope that it will be useful,
* but WITHOUT ANY WARRANTY; without even the implied warranty of
* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
* GNU General Public License for more details.
*
* You should have received a copy of the GNU General Public License
* along with this program; if not, write to the Free Software
* Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
***********************************************************************/



#ifndef IPCV_COMMON_H
#define IPCV_COMMON_H

//#ifdef __cplusplus
//extern "C" {
//#endif


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
#include <sciprint.h>
#include <api_scilab.h>
#include <iostream>
#include <fstream>
#include <cstdlib>
#include <stdlib.h>
#include <stdio.h>
#include <sys/types.h>
#include <sys/stat.h>


#include <opencv2/core.hpp>
#include <opencv2/videoio.hpp>
#include <opencv2/highgui.hpp>
#include <opencv2/features2d.hpp>
#include <opencv2/xfeatures2d.hpp>
#include <opencv2/stitching.hpp>
#include <opencv2/video.hpp>
#include <opencv2/imgproc.hpp>
#include <opencv2/photo.hpp>
#include <opencv2/tracking.hpp>
#include <opencv2/core/ocl.hpp>
#include <opencv2/imgcodecs.hpp>

//#ifdef HAVE_OPENCV_NONFREE
//#endif

#include <opencv2/dnn.hpp>
#include <opencv2/dnn/shape_utils.hpp>


#define MAX_AVI_FILE_NUM 32
#define MAX_FILENAME_LENGTH 2048
#define MAX_DL_NUM 3
#define MAX_TRACK_NUM 3

using namespace cv;
using namespace cv::dnn;
using namespace std;


typedef struct OpenedAviFile{ 
	int iswriter; //reader or writer
//	union{
//		CvCapture * cap; //for reading from video files or cameras
//		CvVideoWriter * writer; // for writing to video files
//	}video;
	VideoCapture cap; //for reading from video files or cameras
	VideoWriter writer; // for writing to video files
	int width; //now only used by writer
	int height;//now only used by writer
	char filename[MAX_FILENAME_LENGTH];
} OpenedAviFile;

extern OpenedAviFile OpenedAvi[MAX_AVI_FILE_NUM];

typedef struct OpenedCamCapture {
	int iswriter; //reader or writer
	VideoCapture cap; //for reading from video files or cameras
	VideoWriter writer; // for writing to video files
	int width; //now only used by writer
	int height;//now only used by writer
	char filename[MAX_FILENAME_LENGTH];
} OpenedCamCapture;
extern OpenedCamCapture OpenedCam[MAX_AVI_FILE_NUM];

typedef struct DeepNetwork {
	dnn::Net net;
} DeepNetwork;

extern DeepNetwork DeepNet[MAX_DL_NUM];

typedef struct ObjectTracker {
	//Track trackobj;
	Ptr<Tracker> trackobj;
} TrackObj;

extern ObjectTracker ObjTrack[MAX_TRACK_NUM];


extern char sIPCV_PATH[MAX_FILENAME_LENGTH];
extern "C"
{
// SIVP interface functions
int IplImg2Mat(IplImage * pImage, int nPos);
int Create2DIntMat(int nPos, int nRow, int nCol, void * pData, int nType);
int Create2DFloatMat(int nPos, int nRow, int nCol, float * pData);
int Create2DDoubleMat(int nPos, int nRow, int nCol, double * pData);
int Create3DIntMat(int nPos, int nRow, int nCol, int nCh, void * pData, int nType);
int Create3DFloatMat(int nPos, int nRow, int nCol, int nCh, float* pData);
int Create3DDoubleMat(int nPos, int nRow, int nCol, int nCh, double* pData);
IplImage * Mat2IplImg(int nPos);
IplImage * CreateIplImgFromHm(int nPos);
Mat sci2mat(int nPos);
int mat2sci(Mat pImage, int nPos);
int MatData2ImgData(IplImage * pImage, void * pMatData);
int ImgData2MatData(IplImage * pImage, void * pMatData);
int IplType2SciType(int IplType);
int SciType2IplType(int SciType);
void img2mat(unsigned char* pSrc, unsigned char * pDst, int nWidth, int nHeight, int nCh);
void mat2img(unsigned char * pMat, unsigned char *pImg, int nWidth, int nHeight, int nCh);

// ???
static void generate(const int &_N,const cv::Mat &_TRANS,const cv::Mat &_EMIS, const cv::Mat &_INIT, cv::Mat &seq, cv::Mat &states);
static void viterbi(const cv::Mat &seq, const cv::Mat &_TRANS, const cv::Mat &_EMIS, const cv::Mat &_INIT, cv::Mat &states);
static void decode(const cv::Mat &seq,const cv::Mat &_TRANS,const cv::Mat &_EMIS, const cv::Mat &_INIT, double &logpseq, cv::Mat &PSTATES, cv::Mat &FORWARD, cv::Mat &BACKWARD);
static void getUniformModel(const int &n_states,const int &n_observations, cv::Mat &TRANS,cv::Mat &EMIS,cv::Mat &INIT);
static void train(const cv::Mat &seq, const int max_iter, cv::Mat &TRANS, cv::Mat &EMIS, cv::Mat &INIT,bool UseUniformPrior = false);
static void correctModel(cv::Mat &TRANS, cv::Mat &EMIS, cv::Mat &INIT);
static void printPaths(const cv::Mat &PATHS,const cv::Mat &P, const int &t);
static void printModel(const cv::Mat &TRANS,const cv::Mat &EMIS,const cv::Mat &INIT);



// IPCV interface functions
int matdata2scidata(Mat &pImage, void *pMatData);
int scidata2matdata(Mat &pImage, void *pMatData);
int GetImage(int nPos, Mat& new_img,void* pvApiCtx);
int SetImage(int nPos, Mat& new_img,void* pvApiCtx);
int GetString(int nPos, char *&pstName,void* pvApiCtx);
int SetString(int nPos, char *&pstName, void* pvApiCtx);
int GetDouble(int nPos, double *&pstdata, int& iRows,int& iCols,void* pvApiCtx);
int GetDouble2(int nPos, double *&pstdata, int& iRows,int& iCols,void* pvApiCtx);
int SetDouble(int nPos, double *&pstdata, int& iRows,int& iCols,void* pvApiCtx);
string type2str(int type);
int is_binary_image( Mat& new_img);
int GetListImg(int _iRhs, int* _piParent, int *_piAddr, int _iItemPos,vector<Mat>& imgs,void* pvApiCtx);
int get_info_imgvec(int _iRhs, int* _piParent, int *_piAddr, int _iItemPos,vector<Mat>& imgs,void* pvApiCtx);
int get_list_info_imgvec(int _iRhs, int* _piParent, int *_piAddr, int _iItemPos,vector<Mat>& imgs,void* pvApiCtx);
int get_double_info_imgvec(int _iRhs, int* _piParent, int *_piAddr, int _iItemPos,vector<Mat>& imgs,void* pvApiCtx);
int get_poly_info_imgvec(int _iRhs, int* _piParent, int *_piAddr, int _iItemPos,vector<Mat>& imgs,void* pvApiCtx);
int get_boolean_info_imgvec(int _iRhs, int* _piParent, int *_piAddr, int _iItemPos,vector<Mat>& imgs,void* pvApiCtx);
int get_sparse_info_imgvec(int _iRhs, int* _piParent, int *_piAddr, int _iItemPos,vector<Mat>& imgs,void* pvApiCtx);
int get_bsparse_info_imgvec(int _iRhs, int* _piParent, int *_piAddr, int _iItemPos,vector<Mat>& imgs,void* pvApiCtx);
int get_integer_info_imgvec(int _iRhs, int* _piParent, int *_piAddr, int _iItemPos, vector<Mat>& imgs, void* pvApiCtx);
int get_string_info_imgvec(int _iRhs, int* _piParent, int *_piAddr, int _iItemPos,vector<Mat>& imgs,void* pvApiCtx);
int get_pointer_info_imgvec(int _iRhs, int* _piParent, int *_piAddr, int _iItemPos,vector<Mat>& imgs,void* pvApiCtx);
int SetImages(int nPos, vector<Mat>& new_img, void* pvApiCtx);
int matvec2scihyper(vector<Mat> &pImage, void *pMatData);

//	int sci_int_dnnclassify2(char * fname,  void* pvApiCtx);
//	int sci_int_mnist(char * fname, void* pvApiCtx);
//	int sci_int_loadmnist(char * fname, void* pvApiCtx);
//	int sci_int_cppsum(char * fname, void* pvApiCtx);
//	int sci_int_lenet(char * fname, int argc, char **argv, void* pvApiCtx);
//	int sci_int_geotiffread(char * fname, void* pvApiCtx);
//	int sci_int_gpu_conv(char * fname, void* pvApiCtx);
//	int sci_int_test(char * fname, void* pvApiCtx);
	int sci_int_imdist(char * fname, void* pvApiCtx);
	int sci_int_tracker_init(char * fname, void* pvApiCtx);
	int sci_int_tracker_update(char * fname, void* pvApiCtx);
	int sci_int_tracker_unloadall(char * fname, void* pvApiCtx);
	int sci_iminspect(char * fname, void* pvApiCtx);
/////////////////////////////////////////////////////////////////	
	int sci_ipcv_init(char * fname,void* pvApiCtx);
	int sci_imabsdiff(char * fname,void* pvApiCtx);
	int sci_imadd(char * fname,void* pvApiCtx);
	int sci_imdivide(char * fname,void* pvApiCtx);
	int sci_imresize(char * fname,void* pvApiCtx);
	int sci_imsubtract(char * fname,void* pvApiCtx);
	int sci_int_affinetransform(char * fname,void* pvApiCtx);
	int sci_camopen(char *fname,void* pvApiCtx);
	int sci_camread(char * fname,void* pvApiCtx);
	int sci_camlistopened(char * fname, void* pvApiCtx);
	int sci_camclose(char *fname, void* pvApiCtx);
	int sci_camcloseall(char *fname, void* pvApiCtx);
	int sci_int_imrotate(char * fname,void* pvApiCtx);
	int sci_int_rgb2gray(char * fname,void* pvApiCtx);
	int sci_imdisplay(char * fname,void* pvApiCtx);
	int sci_avireadframe(char * fname,void* pvApiCtx);
	int sci_immultiply(char * fname,void* pvApiCtx);
	int sci_int_imidct(char * fname,void* pvApiCtx);
	int sci_int_imdct(char * fname,void* pvApiCtx);
	int sci_imdestroy(char * fname,void* pvApiCtx);
	int sci_imdestroyall(char * fname,void* pvApiCtx);
	int sci_int_immorphologyex(char * fname,void* pvApiCtx);
	int sci_int_imcreatese(char * fname,void* pvApiCtx);
	int sci_int_imdilate(char * fname,void* pvApiCtx);
	int sci_int_imerode(char * fname,void* pvApiCtx);
	int sci_int_rgb2lab(char * fname,void* pvApiCtx);
	int sci_int_imadapthistequal(char * fname,void* pvApiCtx);
	int sci_int_detectobjects(char * fname,void* pvApiCtx);
	int sci_int_imwrite(char * fname,void* pvApiCtx);
	int sci_int_imfilter(char * fname,void* pvApiCtx);
	int sci_int_imhough(char * fname,void* pvApiCtx);
	int sci_int_imhoughcircles(char * fname,void* pvApiCtx);
	int sci_int_imradon(char * fname,void* pvApiCtx);
	int sci_int_imfill(char * fname,void* pvApiCtx);
	int sci_int_perspectivetransform(char * fname,void* pvApiCtx);
	int sci_int_getaffinetransform(char * fname,void* pvApiCtx);
	int sci_int_getperspectivetransform(char * fname,void* pvApiCtx);
	int sci_int_immedian(char * fname,void* pvApiCtx);
	int sci_impyramid(char *fname,void* pvApiCtx);
	int sci_int_imlogpolar(char * fname,void* pvApiCtx);
	int sci_int_iminpaint(char * fname,void* pvApiCtx);
	int sci_int_canny(char *fname,void* pvApiCtx);
	int sci_int_sobel(char *fname,void* pvApiCtx);
	int sci_int_cvtcolor(char *fname,void* pvApiCtx);
	int sci_int_imlabel(char * fname,void* pvApiCtx);
	int sci_filter2(char * fname,void* pvApiCtx);
	int sci_aviclose(char *fname,void* pvApiCtx);
	int sci_aviopen(char *fname,void* pvApiCtx);
	int sci_avilistopened(char * fname,void* pvApiCtx);
	int sci_avifile(char *fname,void* pvApiCtx);
	int sci_avicloseall(char *fname, void* pvApiCtx);
	int sci_aviaddframe(char * fname, void* pvApiCtx);
	int sci_addframe(char * fname,void* pvApiCtx);
	int sci_int_imdetect_FAST(char * fname,void* pvApiCtx);
	int sci_int_imdetect_MSER(char * fname,void* pvApiCtx);
	int sci_int_imdetect_ORB(char * fname,void* pvApiCtx);
	int sci_int_imdetect_BRISK(char * fname,void* pvApiCtx);
	int sci_int_imdetect_STAR(char * fname,void* pvApiCtx);
	int sci_int_imdetect_SURF(char * fname,void* pvApiCtx);
	int sci_int_imdetect_SIFT(char * fname,void* pvApiCtx);
	int sci_int_imdetect_GFTT(char * fname,void* pvApiCtx);
	//int sci_int_imdetect_HARRIS(char * fname,void* pvApiCtx);
	//int sci_int_imdetect_DENSE(char * fname,void* pvApiCtx);
	int sci_int_imextract_DescriptorSIFT(char * fname,void* pvApiCtx);
	int sci_int_imextract_DescriptorSURF(char * fname,void* pvApiCtx);
	//int sci_int_imextract_DescriptorBRIEF(char * fname,void* pvApiCtx);
	int sci_int_imextract_DescriptorBRISK(char * fname,void* pvApiCtx);
	int sci_int_imextract_DescriptorORB(char * fname,void* pvApiCtx);
	//int sci_int_imextract_DescriptorFREAK(char * fname,void* pvApiCtx);
	int sci_int_immatch_BruteForce(char * fname,void* pvApiCtx);
	int sci_int_immatch_Flann(char * fname,void* pvApiCtx);
	int sci_int_imdrawmatches(char * fname,void* pvApiCtx);
	int sci_mat2utfimg(char * fname,void* pvApiCtx);
	int sci_int_imfindContours(char * fname,void* pvApiCtx);
	int sci_int_imconvexHull(char * fname,void* pvApiCtx);
	int sci_int_imstitchImage(char * fname,void* pvApiCtx);
	int sci_int_imsuperres(char * fname,void* pvApiCtx);
	int sci_int_imsuperres2(char * fname,void* pvApiCtx);
	int sci_videoquickview(char * fname,void* pvApiCtx);
	int sci_int_dnn_init(char * fname, void* pvApiCtx);
	int sci_int_dnn_forward(char * fname, void* pvApiCtx);
	int sci_int_dnn_getLayerNames(char * fname, void* pvApiCtx);
	int sci_int_dnn_getLayersCount(char * fname, void* pvApiCtx);
	int sci_int_dnn_list(char * fname, void* pvApiCtx);
	int sci_int_dnn_unload(char * fname, void* pvApiCtx);
	int sci_int_dnn_unloadall(char * fname, void* pvApiCtx);
	int sci_int_dnn_getParam(char * fname, void* pvApiCtx);
	int sci_int_imboundingRect(char * fname, void* pvApiCtx);
	int sci_int_imfinfo(char *fname, void* pvApiCtx);
	int sci_aviinfo(char *fname, void* pvApiCtx);
	int sci_int_imdistransf(char * fname, void* pvApiCtx);
	int sci_int_imwatershed(char * fname, void* pvApiCtx);
}
#endif
