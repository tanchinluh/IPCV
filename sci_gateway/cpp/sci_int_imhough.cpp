/***********************************************************************
 *
 * IPCV - Scilab Image Processing and Computer Vision toolbox
 * Copyright (C) 2017  Tan Chin Luh
 *
***********************************************************************/

#include "common.h"

/************************************************************
* y = int_imidct(x);
************************************************************/


int sci_int_imhough(char * fname,void* pvApiCtx)
{

SciErr sciErr;
CheckInputArgument(pvApiCtx, 1, 1);
CheckOutputArgument(pvApiCtx, 1, 1);

Mat src;
int* piAddr = NULL;
double* pdbRho = NULL;
double* pdbTheta = NULL;
int iRet    = 0;
int iRows1           = 0;
int iCols1           = 0;
int iRows2           = 0;
int iCols2           = 0;
	
GetImage(1,src,pvApiCtx);

	Mat dst = src;
	//Canny(src, dst, 50, 200, 3);
	Mat cdst;
	
	cvtColor(dst, cdst, COLOR_GRAY2BGR);

#if 1
	vector<Vec2f> lines;
	HoughLines(dst, lines, 1, CV_PI/180, 10, 0, 0 );

	for( size_t i = 0; i < lines.size(); i++ )
	{
		float rho = lines[i][0], theta = lines[i][1];
		Point pt1, pt2;
		double a = cos(theta), b = sin(theta);
		double x0 = a*rho, y0 = b*rho;
		pt1.x = cvRound(x0 + 1000*(-b));
		pt1.y = cvRound(y0 + 1000*(a));
		pt2.x = cvRound(x0 - 1000*(-b));
		pt2.y = cvRound(y0 - 1000*(a));
		line( cdst, pt1, pt2, Scalar(0,0,255), 3, LINE_AA);
		sciprint("Double if (%d x %f x %f )\n", lines.size(), lines[i][0],lines[i][1]);
	}
	//sciprint("Double if (%d x %f x %f x %f x %f)\n", lines.size(),lines[0][0], lines[0][1],lines[1][0], lines[1][1]);
#else
	vector<Vec4i> lines.data();
	HoughLinesP(dst, lines, 1, CV_PI/180, 50, 50, 10 );
	for( size_t i = 0; i < lines.size(); i++ )
	{
		Vec4i l = lines[i];
		line( cdst, Point(l[0], l[1]), Point(l[2], l[3]), Scalar(0,0,255), 3, CV_AA);
	}

	sciprint("Double else (%d x % x %f x %f x %f)\n", lines.size(),lines[0][0], lines[0][1],lines[1][0], lines[1][1]);

#endif
	//imshow("source", src);
	//imshow("detected lines", cdst);

	//waitKey();
	Mat pDstImg(lines);
	SetImage(1,cdst,pvApiCtx);

	return 0;


}

