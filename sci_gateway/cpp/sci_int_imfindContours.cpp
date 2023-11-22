/***********************************************************************
* IPCV - Scilab Image Processing and Computer Vision toolbox
* Copyright (C) 2017  Tan Chin Luh
***********************************************************************/

#include "common.h"
using namespace cv;
using namespace std;

int sci_int_imfindContours(char * fname, void* pvApiCtx)
{

	double *mode = NULL;
	double *method = NULL;
	int iRows = 0;
	int iCols = 0;

	CheckInputArgument(pvApiCtx, 3, 3);
	CheckOutputArgument(pvApiCtx, 0, 1);

	Mat canny_output;

	GetImage(1, canny_output, pvApiCtx);
	if (canny_output.empty())
	{
		sciprint("Can't read image\n");
		return -1;
	}

	// Get	RetrievalModes
	GetDouble(2, mode, iRows, iCols, pvApiCtx);

	// Get	RetrievalModes
	GetDouble(3, method, iRows, iCols, pvApiCtx);

	vector<vector<Point> > contours;
	vector<Vec4i> hierarchy;

	//findContours( canny_output, contours, hierarchy, RETR_TREE, CHAIN_APPROX_SIMPLE, Point(0, 0) );
	try
	{
		findContours(canny_output, contours, hierarchy, *mode, *method);
	}
	catch (std::exception& e)
	{
		sciprint("%s\n", e.what());
	}

	///// Draw contours - Export method by producing index images for contours
	//Mat drawing = Mat::zeros( canny_output.size(), CV_64FC1 );
	//
	//for( int i = 0; i < contours.size(); i++ )
	//{
	//	//Scalar color = Scalar( rng.uniform(0, 255), rng.uniform(0,255), rng.uniform(0,255) );
	//	//drawContours( drawing, contours, i, i, 1, 0, hierarchy, 0, Point() );
	//	for( int j = 0; j < contours[i].size(); j++ )
	//		{
	//			drawing.at<double>(contours[i][j].y,contours[i][j].x) = i+1;
	//		}
	//	
	//}
	//
	//SetImage(1,drawing,pvApiCtx);


	// Preparing output in list, each contour in each list item
	SciErr sciErr;
	int *piAddr = NULL;
	int cnt_num = contours.size();

	// create list size base on number of contours found
	sciErr = createList(pvApiCtx, nbInputArgument(pvApiCtx) + 1, cnt_num, &piAddr);
	if (sciErr.iErr)
	{
		printError(&sciErr, 0);
		return 0;
	}

	for (int num = 0; num < cnt_num; num++)
	{
		int iRows1 = contours[num].size() * 1;
		int iCols1 = 2;
		double* pdblReal1 = NULL;
		pdblReal1 = new double[iRows1*iCols1];

		for (int cnt = 0; cnt < iRows1; cnt++)
		{
			pdblReal1[iCols1 / 2 * cnt] = contours[num][cnt].x + 1;
			pdblReal1[iRows1 + iCols1 / 2 * cnt] = contours[num][cnt].y + 1;

		}

		sciErr = createMatrixOfDoubleInList(pvApiCtx, nbInputArgument(pvApiCtx) + 1, piAddr, num + 1, iRows1, iCols1, pdblReal1);
		if (sciErr.iErr)
		{
			printError(&sciErr, 0);
			return 0;
		}

	}

	AssignOutputVariable(pvApiCtx, 1) = nbInputArgument(pvApiCtx) + 1;


	return 0;
}



//cv::RetrievalModes{
//  cv::RETR_EXTERNAL = 0,
//  cv::RETR_LIST = 1,
//  cv::RETR_CCOMP = 2,	--> (CV_32SC1) allowed
//  cv::RETR_TREE = 3,
//  cv::RETR_FLOODFILL = 4 --> (CV_32SC1) allowed
//
//
//cv::ContourApproximationModes {
//  cv::CHAIN_APPROX_NONE = 1,
//  cv::CHAIN_APPROX_SIMPLE = 2,
//  cv::CHAIN_APPROX_TC89_L1 = 3,
//  cv::CHAIN_APPROX_TC89_KCOS = 4
//}