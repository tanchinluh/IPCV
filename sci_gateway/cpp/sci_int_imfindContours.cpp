/***********************************************************************
* IPCV - Scilab Image Processing and Computer Vision toolbox
* Copyright (C) 2017  Tan Chin Luh
***********************************************************************/

#include "common.h"
using namespace cv;
using namespace std;

int sci_int_imfindContours(char * fname,void* pvApiCtx)
{

	CheckInputArgument(pvApiCtx, 1, 2);
	CheckOutputArgument(pvApiCtx, 0, 1);

	Mat canny_output;

	GetImage(1,canny_output,pvApiCtx);
	if (canny_output.empty())
	{
		sciprint("Can't read image\n");
		return -1;
	}

	
	vector<vector<Point> > contours;
	vector<Vec4i> hierarchy;

	
	findContours( canny_output, contours, hierarchy, RETR_TREE, CHAIN_APPROX_SIMPLE, Point(0, 0) );

	/// Draw contours
	Mat drawing = Mat::zeros( canny_output.size(), CV_64FC1 );
	//int iRows1			= 2;
	//int iCols1			= contours.size();
	//double* pdblReal1 = NULL;
	//pdblReal1 = new double[iRows1*iCols1];
	//sciprint("%i\n",contours.size());
	for( int i = 0; i < contours.size(); i++ )
	{
		//Scalar color = Scalar( rng.uniform(0, 255), rng.uniform(0,255), rng.uniform(0,255) );
		//drawContours( drawing, contours, i, i, 1, 0, hierarchy, 0, Point() );
		for( int j = 0; j < contours[i].size(); j++ )
			{
				drawing.at<double>(contours[i][j].y,contours[i][j].x) = i+1;
			}

		//for ( int j = 0; i < contours[i].size(); j++ )
		//{
		//	pdblReal1[iRows1*i+j*2] = (double)contours[i][j].x;
		//	pdblReal1[iRows1*i+1+j*2] = (double)contours[i][j].y;
		//}
		
	}

//for( int j = 0; j < contours[2].size(); j++ )
//	{
//	sciprint("%i,%i\n",contours[2][j].x,contours[2][j].y);
//}
	/// Show in a window
	//namedWindow( "Contours", CV_WINDOW_AUTOSIZE );
	//imshow( "Contours", drawing );

	//SetDouble(1,pdblReal1,iRows1,iCols1,pvApiCtx);
	//delete [] pdblReal1;
	SetImage(1,drawing,pvApiCtx);

	return 0;
}

