/***********************************************************************
 *
 * IPCV - Scilab Image Processing and Computer Vision toolbox
 * Copyright (C) 2020  Tan Chin Luh
 * 
 * Reference : https://docs.opencv.org/4.1.2/d2/dbd/tutorial_distance_transform.html
 ***********************************************************************/

#include "common.h"

using namespace cv;
using namespace std;

/************************************************************
*  imout = int_imdistransf(imin);
************************************************************/


int sci_int_imdistransf(char * fname,void* pvApiCtx)
{

	CheckInputArgument(pvApiCtx, 2, 2);
	CheckOutputArgument(pvApiCtx, 0, 1);
		
	// First Input - Image
	Mat src;
	GetImage(1,src,pvApiCtx);
	
	// Second Input - Method
	int *piAddr2 = NULL;
	double num_objs = 0;
	getVarAddressFromPosition(pvApiCtx, 2, &piAddr2);
	getScalarDouble(pvApiCtx, piAddr2, &num_objs);
	int method = round(num_objs);

	// ToDo: Checking Image type, automatically convert RGB or Gray to binary (lazy approach)
	int src_type = src.type();
	if (src_type!=0)
	{
		Scierror(1,"The input must be in Scilab binary format.\n", fname);
		return -1;
	}

	// Perform the distance transform algorithm
	Mat dist;
	distanceTransform(src, dist, method, 3);
	normalize(dist, dist, 0, 1.0, NORM_MINMAX);

	// Set output to Scilab
	SetImage(1,dist,pvApiCtx);


	return 0;


}

//+--------+----+----+----+----+----+----+----+----+
//|        | C1 | C2 | C3 | C4 | C5 | C6 | C7 | C8 |
//+--------+----+----+----+----+----+----+----+----+
//| CV_8U  |  0 |  8 | 16 | 24 | 32 | 40 | 48 | 56 |
//| CV_8S  |  1 |  9 | 17 | 25 | 33 | 41 | 49 | 57 |
//| CV_16U |  2 | 10 | 18 | 26 | 34 | 42 | 50 | 58 |
//| CV_16S |  3 | 11 | 19 | 27 | 35 | 43 | 51 | 59 |
//| CV_32S |  4 | 12 | 20 | 28 | 36 | 44 | 52 | 60 |
//| CV_32F |  5 | 13 | 21 | 29 | 37 | 45 | 53 | 61 |
//| CV_64F |  6 | 14 | 22 | 30 | 38 | 46 | 54 | 62 |
//+--------+----+----+----+----+----+----+----+----+

//cv::DIST_L1 = 1,
//cv::DIST_L2 = 2,
//cv::DIST_C = 3,
