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

	CheckInputArgument(pvApiCtx, 2, 2);
	CheckOutputArgument(pvApiCtx, 0, 1);
		
	///////////////////
	//// First Input //
	///////////////////
	Mat src;
	GetImage(1,src,pvApiCtx);

	//sciprint("Input type %d\n",src.type());

	///////////////////
	Mat dst;

	int *piAddr2 = NULL;
	double angle	= 0;
	getVarAddressFromPosition(pvApiCtx, 2, &piAddr2);
	getScalarDouble(pvApiCtx, piAddr2, &angle);
	
 //Point2f pt(src.cols*0.5f, src.rows*0.5f);    
 //   Mat r = getRotationMatrix2D(pt, angle, 1.0);
 //   warpAffine(src, dst, r, dst.size());
	
	/////////////
	Point2f center(src.cols/2.0, src.rows/2.0);
    Mat rot = getRotationMatrix2D(center, angle, 1.0);
    // determine bounding rectangle
    Rect bbox = RotatedRect(center,src.size(), angle).boundingRect();
    // adjust transformation matrix
    rot.at<double>(0,2) += bbox.width/2.0 - center.x;
    rot.at<double>(1,2) += bbox.height/2.0 - center.y;

    warpAffine(src, dst, rot, bbox.size());
	////////////
	
	//waitKey(0);  

	SetImage(1,dst,pvApiCtx);



	return 0;


}
