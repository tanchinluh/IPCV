/***********************************************************************
 * IPCV - Scilab Image Processing and Computer Vision toolbox
 * Copyright (C) 2017  Tan Chin Luh
 ***********************************************************************/

#include "common.h"

/************************************************************
*  imout = sci_int_imfill(imin);
************************************************************/


int sci_int_imfill(char * fname,void* pvApiCtx)
{

	CheckInputArgument(pvApiCtx, 1, 1);
	CheckOutputArgument(pvApiCtx, 0, 1);
		
	///////////////////
	//// First Input //
	///////////////////
	Mat src;
	GetImage(1,src,pvApiCtx);
	///////////////////
	Mat dst;

		
	vector<vector<cv::Point> > contours;
    vector<Vec4i> hierarchy;

    findContours(src,contours,hierarchy,RETR_CCOMP,CHAIN_APPROX_SIMPLE,cv::Point(0,0));
    CvScalar color=cvScalar(255);
    dst=Mat::zeros(src.size(),CV_8UC1);

    for(int i=0;i<contours.size();i++)
    {
        drawContours(dst,contours,i,color,-1,8,hierarchy,0,cv::Point());
    }

	//floodFill(src,cvPoint(0,0),cvScalar(255));

	

	SetImage(1,dst,pvApiCtx);



	return 0;


}
