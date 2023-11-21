/***********************************************************************
* IPCV - Scilab Image Processing and Computer Vision toolbox
* Copyright (C) 2017  Tan Chin Luh
***********************************************************************/

#include "common.h"
using namespace cv;
using namespace std;

int sci_int_imfindContours2(char * fname,void* pvApiCtx)
{

	CheckInputArgument(pvApiCtx, 1, 2);
	CheckOutputArgument(pvApiCtx, 0, 3);

	Mat canny_output;

	GetImage(1,canny_output,pvApiCtx);
	if (canny_output.empty())
	{
		sciprint("Can't read image\n");
		return -1;
	}

	
	vector<vector<Point> > contours;
	vector<Vec4i> hierarchy;

	
	//findContours( canny_output, contours, hierarchy, RETR_TREE, CHAIN_APPROX_SIMPLE, Point(0, 0) );
	findContours(canny_output, contours, hierarchy,2,1);

	vector<Point> contour = contours[0];

	vector<Point>hull;
	convexHull(contour, hull);
	vector<int> hullIndices;
	convexHull(contour, hullIndices, false, false);
	vector<Vec4i>  defects;

	sciprint("Contours size%i\n", contour.size());
	sciprint("Contour0 size%i\n", contour.size());

	for (int i = 0; i < contour.size(); i++)
	{
		sciprint("%i\t%i\n", contour[i].y, contour[i].x);
	}

	//sort(hullIndices.begin(), hullIndices.end(), greater<int>());

	try
	{
		convexityDefects(contour, hullIndices, defects);
	}
	catch (std::exception& e)
	{
		sciprint("%s\n", e.what());
	}

	int cntd = 0;
	for (size_t i = 0; i < defects.size(); i++)
	{
		Vec4i v = defects[i];
		float depth = v[3] / 256;
		if (depth > 150) //  filter defects by depth, e.g more than 10
		{
			int startidx = v[0]; //Point ptStart(Contours[i][startidx]);
			int endidx = v[1]; //Point ptEnd(Contours[i][endidx]);
			int faridx = v[2]; //Point ptFar(Contours[i][faridx]);
			cntd++;
		}
	}
	Mat crd = Mat(hull.size(), 2, CV_32SC1, hull.data());

	double cntdd;
	cntdd = double(cntd);
	double* pdblReal1 = NULL;
	pdblReal1 = &cntdd;
	int iRows1 = 1;
	int iCols1 = 1;

	SetImage(1, crd, pvApiCtx);
	//SetDouble(2, pdblReal1, iRows1, iCols1, pvApiCtx);
	Mat crd2 = Mat(hullIndices.size(), 1, CV_32S, hullIndices.data());
	SetImage(2, crd2, pvApiCtx);

	Mat crd3 = Mat(defects.size(), 4, CV_32S, defects.data());
	SetImage(3, crd3, pvApiCtx);


	return 0;
}

