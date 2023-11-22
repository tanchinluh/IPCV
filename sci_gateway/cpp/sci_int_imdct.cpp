/***********************************************************************
 * IPCV - Scilab Image Processing and Computer Vision toolbox
 * Copyright (C) 2017  Tan Chin Luh
 ***********************************************************************/


#include "common.h"

/************************************************************
* y = int_imdct(x);
************************************************************/


int sci_int_imdct(char * fname,void* pvApiCtx)
{

	//// Initialization
	//IplImage *pSrcImg = NULL;
	//IplImage *pDstImg = NULL;

	//// Checking numbers of Arguments
	//CheckRhs(1, 1);
	//CheckLhs(1, 1);

	//// Creating images
	//pSrcImg = Mat2IplImg(1);	
	//pDstImg = cvCreateImage(cvSize(pSrcImg->width, pSrcImg->height),pSrcImg->depth, pSrcImg->nChannels);

	//// Do the transformation
	//cvDCT( pSrcImg, pDstImg,0);

	////	Export Image
	//IplImg2Mat(pDstImg, Rhs+1);
	//LhsVar(1) = Rhs+1;

	//// Cleaning up
	//cvReleaseImage( &pSrcImg );
	//cvReleaseImage( &pDstImg );
	CheckInputArgument(pvApiCtx, 1, 1);
	CheckOutputArgument(pvApiCtx, 1, 1);

	/////////////////
	// First Input //
	/////////////////
	Mat pSrcImg;
	GetImage(1,pSrcImg,pvApiCtx);
	/////////////////
	Mat pDstImg = pSrcImg;
	//
	dct(pSrcImg, pDstImg,0);
	//sciprint("dims : %i\n",pSrcImg.dims);
	//sciprint("dims : %i\n",pSrcImg.dims);
	//
	SetImage(1,pDstImg,pvApiCtx);

	return 0;


}
