/***********************************************************************
 *
 * IPCV - Scilab Image Processing and Computer Vision toolbox
 * Copyright (C) 2017  Tan Chin Luh
 *
 ***********************************************************************/

#include "common.h"

using namespace cv;
using namespace std;

/************************************************************
*  imout = int_imrotate(im2,deg);
************************************************************/


int sci_int_imrotate(char * fname,void* pvApiCtx)
{

	CheckInputArgument(pvApiCtx, 3, 3);
	CheckOutputArgument(pvApiCtx, 0, 1);
		
	// First Input - Image
	Mat src;
	GetImage(1,src,pvApiCtx);
	Mat dst;

	// Second Input - Rotation angle
	int *piAddr2 = NULL;
	double angle	= 0;
	getVarAddressFromPosition(pvApiCtx, 2, &piAddr2);
	getScalarDouble(pvApiCtx, piAddr2, &angle);
	
	// Third Input - Crop
	int *piAddr3 = NULL;
	double crop = 0;
	getVarAddressFromPosition(pvApiCtx, 3, &piAddr3);
	getScalarDouble(pvApiCtx, piAddr3, &crop);

	// Process
	Point2f center(src.cols/2.0, src.rows/2.0);
    Mat rot = getRotationMatrix2D(center, angle, 1.0);

	if (crop == 1) {
		warpAffine(src, dst, rot, src.size());
	}
	else {
		// determine bounding rectangle
		Rect bbox = RotatedRect(center, src.size(), angle).boundingRect();
		// adjust transformation matrix
		rot.at<double>(0, 2) += bbox.width / 2.0 - center.x;
		rot.at<double>(1, 2) += bbox.height / 2.0 - center.y;
		warpAffine(src, dst, rot, bbox.size());
	}
	//waitKey(0);  

	SetImage(1,dst,pvApiCtx);



	return 0;


}
