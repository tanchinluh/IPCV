/***********************************************************************
* IPCV - Scilab Image Processing and Computer Vision toolbox
* Copyright (C) 2017  Tan Chin Luh
***********************************************************************/

#include "common.h"
using namespace cv;
using namespace std;

int sci_int_imconvexHull(char * fname,void* pvApiCtx)
{

	CheckInputArgument(pvApiCtx, 1, 2);
	CheckOutputArgument(pvApiCtx, 0, 2);
	Mat C;
	GetImage(1,C,pvApiCtx);
	if (C.empty())
	{
		sciprint("Can't read image\n");
		return -1;
	}
	vector<Point>contour;
	for (int x = 0; x < C.cols-1; x++)
		for (int y = 0; y < C.rows; y++)
		{
			contour.push_back(Point(C.at<double>(y,x),C.at<double>(y,x+1)));
		}
		vector<Point>hull;
		convexHull(contour, hull);
		vector<int> hullIndices; 
		convexHull(contour, hullIndices);
		vector<Vec4i>  defects;
		convexityDefects(contour, hullIndices, defects);

		int cntd = 0;
		for(size_t i = 0; i < defects.size(); i++)
		{
			Vec4i v = defects[i];
			float depth = v[3] / 256;
			if (depth > 150) //  filter defects by depth, e.g more than 10
			{
				int startidx = v[0]; //Point ptStart(Contours[i][startidx]);
				int endidx = v[1]; //Point ptEnd(Contours[i][endidx]);
				int faridx = v[2]; //Point ptFar(Contours[i][faridx]);
				cntd ++;
			}
		}
		Mat crd = Mat(hull.size(),2,CV_32SC1,hull.data());
		double cntdd;
		cntdd = double(cntd); 
		double* pdblReal1 = NULL;
		pdblReal1 = &cntdd;
		int iRows1			= 1;
		int iCols1			= 1;

		SetImage(1,crd,pvApiCtx);
		SetDouble(2,pdblReal1,iRows1,iCols1,pvApiCtx);
		return 0;
}

