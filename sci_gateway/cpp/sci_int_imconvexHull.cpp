/***********************************************************************
* IPCV - Scilab Image Processing and Computer Vision toolbox
* Copyright (C) 2017  Tan Chin Luh
***********************************************************************/

#include "common.h"
using namespace cv;
using namespace std;

int sci_int_imconvexHull(char * fname, void* pvApiCtx)
{
	SciErr sciErr;
	int iItem = 0;
	int iRet = 0;
	int *piAddr = NULL;
	int iRows = 0;
	int iCols = 0;
	double *cwd = NULL;
	double *indd = NULL;
	bool cw, ind;

	CheckInputArgument(pvApiCtx, 3, 3);
	CheckOutputArgument(pvApiCtx, 0, 3);

	vector<Mat> imgs;
	GetListImg(1, NULL, piAddr, 0, imgs, pvApiCtx);

	GetDouble(2, cwd, iRows, iCols, pvApiCtx);
	cw = (*cwd != 0);

	GetDouble(3, indd, iRows, iCols, pvApiCtx);
	ind = (*indd != 0);

	int num_item = imgs.size();

	vector<vector<Point>>contours(num_item);

	for (int num = 0; num < num_item; num++)
	{
		Mat C = imgs[num];

		for (int x = 0; x < C.cols - 1; x++)
			for (int y = 0; y < C.rows; y++)
			{
				contours[num].push_back(Point(C.at<double>(y, x) - 1, C.at<double>(y, x + 1) - 1));
			}
	}


	// Deside to export the hull in points or indices
	if (ind)
	{
		vector<vector<int> >hull(contours.size());
		for (size_t i = 0; i < contours.size(); i++)
		{
			try
			{
				convexHull(contours[i], hull[i], cw);
			}
			catch (std::exception& e)
			{
				sciprint("%s\n", e.what());
			}
		}

		// Preparing output in list, each hull in each list item
		int hull_num = hull.size();

		// create list size base on number of contours found
		sciErr = createList(pvApiCtx, nbInputArgument(pvApiCtx) + 1, hull_num, &piAddr);
		if (sciErr.iErr)
		{
			printError(&sciErr, 0);
			return 0;
		}

		for (int num = 0; num < hull_num; num++)
		{
			int iRows1 = hull[num].size() * 1;
			int iCols1 = 1;
			double* pdblReal1 = NULL;
			pdblReal1 = new double[iRows1*iCols1];

			for (int cnt = 0; cnt < iRows1; cnt++)
			{
				pdblReal1[cnt] = hull[num][cnt] + 1;

			}

			sciErr = createMatrixOfDoubleInList(pvApiCtx, nbInputArgument(pvApiCtx) + 1, piAddr, num + 1, iRows1, iCols1, pdblReal1);
			if (sciErr.iErr)
			{
				printError(&sciErr, 0);
				return 0;
			}

		}

	}
	else
	{
		vector<vector<Point> >hull(contours.size());
		for (size_t i = 0; i < contours.size(); i++)
		{
			try
			{
				convexHull(contours[i], hull[i], cw);
			}
			catch (std::exception& e)
			{
				sciprint("%s\n", e.what());
			}
		}

		// Preparing output in list, each hull in each list item
		int hull_num = hull.size();

		// create list size base on number of contours found
		sciErr = createList(pvApiCtx, nbInputArgument(pvApiCtx) + 1, hull_num, &piAddr);
		if (sciErr.iErr)
		{
			printError(&sciErr, 0);
			return 0;
		}

		for (int num = 0; num < hull_num; num++)
		{
			int iRows1 = hull[num].size() * 1;
			int iCols1 = 2;
			double* pdblReal1 = NULL;
			pdblReal1 = new double[iRows1*iCols1];

			for (int cnt = 0; cnt < iRows1; cnt++)
			{
				pdblReal1[iCols1 / 2 * cnt] = hull[num][cnt].x + 1;
				pdblReal1[iRows1 + iCols1 / 2 * cnt] = hull[num][cnt].y + 1;

			}

			sciErr = createMatrixOfDoubleInList(pvApiCtx, nbInputArgument(pvApiCtx) + 1, piAddr, num + 1, iRows1, iCols1, pdblReal1);
			if (sciErr.iErr)
			{
				printError(&sciErr, 0);
				return 0;
			}

		}
	}
	AssignOutputVariable(pvApiCtx, 1) = nbInputArgument(pvApiCtx) + 1;

	//vector<vector<Point>>hull;
	//convexHull(contours, hull);

	//vector<vector<int>> hullIndices;
	//convexHull(contours, hullIndices);
	//vector<vector<Vec4i>>  defects;
	//convexityDefects(contours, hullIndices, defects);


	//for (int i = 0; i < contour.size(); i++)
	//{
	//	sciprint("%i\t%i\n", contour.x, contour.y);
	//}

	//vector<Point>hull;
	//convexHull(contour, hull);
	//vector<int> hullIndices;
	//convexHull(contour, hullIndices, false, false);
	//vector<Vec4i>  defects;



	//try
	//{	
	//	convexityDefects(contour, hullIndices, defects);
	//}
	//catch (std::exception& e)
	//{
	//	sciprint("%s\n", e.what());
	//}

	//int cntd = 0;
	//for (size_t i = 0; i < defects.size(); i++)
	//{
	//	Vec4i v = defects[i];
	//	float depth = v[3] / 256;
	//	if (depth > 150) //  filter defects by depth, e.g more than 10
	//	{
	//		int startidx = v[0]; //Point ptStart(Contours[i][startidx]);
	//		int endidx = v[1]; //Point ptEnd(Contours[i][endidx]);
	//		int faridx = v[2]; //Point ptFar(Contours[i][faridx]);
	//		cntd++;
	//	}
	//}


	//double cntdd;
	//cntdd = double(cntd);
	//double* pdblReal1 = NULL;
	//pdblReal1 = &cntdd;
	//int iRows1 = 1;
	//int iCols1 = 1;
	////SetDouble(2, pdblReal1, iRows1, iCols1, pvApiCtx);

	//Mat crd = Mat(hull.size(), 2, CV_32SC1, hull.data());
	//SetImage(1, crd, pvApiCtx);

	//Mat crd2 = Mat(hullIndices.size(), 1, CV_32S, hullIndices.data());
	//SetImage(2, crd2, pvApiCtx);

	//Mat crd3 = Mat(defects.size(), 4, CV_32S, defects.data());
	//SetImage(3, crd3, pvApiCtx);

	return 0;
}

////// Manuall Reading List, Not Complete
//
//
//	// Get the Address of Pos 1
//sciErr = getVarAddressFromPosition(pvApiCtx, 1, &piAddr);
//if (sciErr.iErr)
//{
//	printError(&sciErr, 0);
//	return 0;
//}
//
//// Get the number of Items in the list ( 
//sciErr = getListItemNumber(pvApiCtx, piAddr, &iItem);
//if (sciErr.iErr)
//{
//	printError(&sciErr, 0);
//	return 0;
//}
//
//// Number of Items in List
//sciprint("(%d)\n", iItem);
//
//// Go through all items  
//for (int i = 0; i < iItem; i++)
//{
//	sciErr = getListItemAddress(pvApiCtx, piAddr, i + 1, &piChild);
//	if (sciErr.iErr)
//	{
//		printError(&sciErr, 0);
//		return 0;
//	}
//
//	iRet = get_info_imgvec(1, piAddr, piChild, i + 1);
//
//}