/***********************************************************************
 * IPCV - Scilab Image Processing and Computer Vision toolbox
 * Copyright (C) 2017  Tan Chin Luh
 ***********************************************************************/


#include "common.h"

int sci_int_iminpaint(char * fname,void* pvApiCtx)
{

	// Initialization
	//IplImage *pSrcImg = NULL;
	//IplImage *pMask = NULL;
	//IplImage *pDstImg = NULL;
	Mat pSrcImg, pDstImg,pMask;

	int mR1 = 0, nR1, lR1 = 0;
	int mR2 = 0, nR2 = 0, lR2 = 0;
	int flags = 0;
	double *inpaintRange = NULL;
	double *FLAG = NULL;
	int flag;
	int iRows			= 0;
	int iCols			= 0;

	// Checking numbers of Arguments
	//CheckRhs(4, 4);
	//CheckLhs(1, 1);
	CheckInputArgument(pvApiCtx, 4, 4);
	CheckOutputArgument(pvApiCtx, 1, 1);
	
	// Creating images and getting parameters
	//pSrcImg = Mat2IplImg(1);
	GetImage(1,pSrcImg,pvApiCtx);
	//pMask = Mat2IplImg(2);
	GetImage(2,pMask,pvApiCtx);
	//GetRhsVar(3,"d", &mR1, &nR1, &lR1);
	//inpaintRange = *stk(lR1);
	GetDouble(3,inpaintRange,iRows,iCols,pvApiCtx);
	//GetRhsVar(4,"i", &mR2, &nR2, &lR2);
	//flags = *istk(lR2);
	GetDouble(4,FLAG,iRows,iCols,pvApiCtx);
	flag = round(*FLAG);
	//pDstImg = cvCreateImage(cvSize(pSrcImg->width, pSrcImg->height),pSrcImg->depth, pSrcImg->nChannels);

	// Do the transformation
	inpaint(pSrcImg, pMask, pDstImg, *inpaintRange, flag);

	// Export image
	SetImage(1,pDstImg,pvApiCtx);

	return 0;


}
