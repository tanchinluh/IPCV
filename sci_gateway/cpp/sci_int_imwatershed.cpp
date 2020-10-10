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
*  imout = int_imwatershed(imin);
************************************************************/


int sci_int_imwatershed(char * fname, void* pvApiCtx)
{

	CheckInputArgument(pvApiCtx, 3, 3);
	CheckOutputArgument(pvApiCtx, 0, 2);

	// First Input - Image
	Mat src_gray;
	GetImage(1, src_gray, pvApiCtx);

	Mat src_labeled;
	GetImage(2, src_labeled, pvApiCtx);

	Mat markers;
	src_labeled.convertTo(markers, CV_32S);

	int *piAddr3 = NULL;
	double num_objs = 0;
	getVarAddressFromPosition(pvApiCtx, 3, &piAddr3);
	getScalarDouble(pvApiCtx, piAddr3, &num_objs);


	// sciprint
	// ToDo: Checking Image type, automatically convert RGB or Gray to binary (lazy approach)
	//int src_type = src.type();
	//if (src_type!=0)
	//{
	//	Scierror(1,"The input must be in Scilab binary format.\n", fname);
	//	return -1;
	//}

	// Perform the distance transform algorithm


	//sciprint("%i\n", src.type());
	//sciprint("%i\n", src.type());
	watershed(src_gray, markers);

	Mat mark;
	markers.convertTo(mark, CV_8U);
	bitwise_not(mark, mark);
	//    imshow("Markers_v2", mark); // uncomment this if you want to see how the mark
	// image looks like at that point
	// Generate random colors
	vector<Vec3b> colors;
	for (size_t i = 0; i < num_objs; i++)
	{
		int b = theRNG().uniform(0, 256);
		int g = theRNG().uniform(0, 256);
		int r = theRNG().uniform(0, 256);
		colors.push_back(Vec3b((uchar)b, (uchar)g, (uchar)r));
	}
	// Create the result image
	Mat dst = Mat::zeros(markers.size(), CV_8UC3);
	// Fill labeled objects with random colors
	for (int i = 0; i < markers.rows; i++)
	{
		for (int j = 0; j < markers.cols; j++)
		{
			int index = markers.at<int>(i, j);
			if (index > 0 && index <= static_cast<int>(num_objs))
			{
				dst.at<Vec3b>(i, j) = colors[index - 1];
			}
		}
	}

	// Set output to Scilab
	SetImage(1, dst, pvApiCtx);
	SetImage(2, markers, pvApiCtx);

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
