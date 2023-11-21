/***********************************************************************
 * IPCV - Scilab Image Processing and Computer Vision toolbox
 * Copyright (C) 2017  Tan Chin Luh
 ***********************************************************************/

#include "common.h"

/************************************************************
* imout = int_bgr2lab(imin, se);
************************************************************/

int sci_int_bgr2lab(char * fname,void* pvApiCtx)
{

	// Initialization
	Mat src;
	Mat dst;

	// Check arguments
	CheckInputArgument(pvApiCtx, 1, 1);
	CheckOutputArgument(pvApiCtx, 1, 1);

	// Creating images
	GetImage(1,src,pvApiCtx);
	//sciprint("CheckPoint : 1\n");
	// Conversion
	//cvCvtColor(pSrcImg, pDstImg, CV_RGB2Lab);
	cvtColor( src, dst, COLOR_BGR2Lab);
	//sciprint("CheckPoint : 2\n");
	// Creating output image
	SetImage(1,dst,pvApiCtx);

	//free(dst);
	//free(src);
	return 0;


}
