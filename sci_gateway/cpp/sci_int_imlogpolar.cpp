/***********************************************************************
 *
 * IPCV - Scilab Image Processing and Computer Vision toolbox
 * Copyright (C) 2017  Tan Chin Luh
 *
 ***********************************************************************/

#include "common.h"

/************************************************************
*  imout = int_imlogpolar(im2,deg);
************************************************************/


int sci_int_imlogpolar(char * fname,void* pvApiCtx)
{

	// Initialization
	//IplImage *pSrcImg2 = NULL;
	//IplImage *pDstImg2 = NULL;
	int iRows			= 0;
	int iCols			= 0;
	//int mR2 = 0, nR2 = 0, lR2 = 0, M = 0;
	Mat pSrcImg1, pDstImg1;
	double *m = NULL;
	int M;
	// Checking numbers of Arguments
	CheckInputArgument(pvApiCtx, 2, 2);
	CheckOutputArgument(pvApiCtx, 1, 1);

	// Creating images and getting parameters
	//pSrcImg = Mat2IplImg(1);
	GetImage(1,pSrcImg1,pvApiCtx);

	//GetRhsVar(2,"i", &mR2, &nR2, &lR2);
	GetDouble(2,m,iRows,iCols,pvApiCtx);
	
	M = round(*m);
	//IplImage * pSrcImg2 = cvCloneImage(&(IplImage)pSrcImg1);//IplImage(pSrcImg1);
	//IplImage* pSrcImg2 = new IplImage(pSrcImg1);

	//IplImage* pSrcImg2;
	//pSrcImg2 = cvCreateImage(cvSize(pSrcImg1.cols,pSrcImg1.rows),8,3);
	//IplImage ipltemp=pSrcImg1;
	//cvCopy(&ipltemp,pSrcImg2);



	//pDstImg2 = cvCreateImage(cvSize(pSrcImg2->width, pSrcImg2->height),pSrcImg2->depth, pSrcImg2->nChannels);

	//cvLogPolar( pSrcImg2, pDstImg2, cvPoint2D32f(pSrcImg2->width/2,pSrcImg2->height/2), M, CV_INTER_LINEAR+CV_WARP_FILL_OUTLIERS );
	//cvLogPolar( dst, src2, cvPoint2D32f(src->width/2,src->height/2), 40, CV_INTER_LINEAR+CV_WARP_FILL_OUTLIERS+CV_WARP_INVERSE_MA

	logPolar(pSrcImg1, pDstImg1, cvPoint2D32f(pSrcImg1.cols / 2, pSrcImg1.rows / 2), M, INTER_LINEAR + WARP_FILL_OUTLIERS);

	//pDstImg1 = Mat(pDstImg2);
	
	SetImage(1,pDstImg1,pvApiCtx);


	return 0;


}

