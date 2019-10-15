/***********************************************************************
 * IPCV - Scilab Image Processing and Computer Vision toolbox
 * Copyright (C) 2017  Tan Chin Luh
***********************************************************************/

#include "common.h"
#include <opencv2/core/utils/trace.hpp>
using namespace cv;
using namespace cv::dnn;
#include <fstream>
#include <iostream>
#include <cstdlib>
using namespace std;
/************************************************************
* imout = sci_int_imboundingRect(imin, se);
************************************************************/

/* Find best class for the blob (i. e. class with maximal probability) */


int sci_int_imboundingRect(char * fname,void* pvApiCtx)
{

	Mat img;
	int iRows			= 0;
	int iCols			= 0;
	double *sz1 = NULL;
	int sz2;

	char *pstName = NULL;

	CheckInputArgument(pvApiCtx, 0, 1);
	CheckOutputArgument(pvApiCtx, 0, 1);

	GetImage(1, img, pvApiCtx);

	Rect myrect = boundingRect(img);

	//sciprint("%i %i %i %i\n",myrect.x, myrect.y, myrect.width, myrect.height);


	int iRows1 = 4;
	int iCols1 = 1;
	double* pdblReal1 = NULL;
	pdblReal1 = new double[iRows1*iCols1];


//	for (int cnt = 0; cnt < iCols1; cnt++)
//	{
		pdblReal1[0] = (double)myrect.x;
		pdblReal1[1] = (double)myrect.y;
		pdblReal1[2] = (double)myrect.width;
		pdblReal1[3] = (double)myrect.height;
//	}

	SetDouble(1, pdblReal1, iRows1, iCols1, pvApiCtx);
	delete[] pdblReal1;
	return 0;

	
}
