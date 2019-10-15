/***********************************************************************
*  Copyright (C) Trity Technologies - 2012 -
* http://www.gnu.org/licenses/gpl-2.0.txt
***********************************************************************/

#include "common.h"

int sci_int_immatch_Flann(char * fname,void* pvApiCtx)
{

	CheckInputArgument(pvApiCtx, 2, 2);
	CheckOutputArgument(pvApiCtx, 0, 1);

	Mat d1,d2,descriptors1, descriptors2;

	GetImage(1,d1,pvApiCtx);
	GetImage(2,d2,pvApiCtx);

	d1.convertTo(descriptors1,CV_32F);
	d2.convertTo(descriptors2,CV_32F);

	// matching descriptors
	FlannBasedMatcher matcher;
	vector<DMatch> matches;
	matcher.match(descriptors1, descriptors2, matches);

	//Mat img_matches;
	//drawMatches(img1, keypoints1, img2, keypoints2, matches, img_matches);
	//
		
	int iRows3			= 4;
	int iCols3			= matches.size();
	double* pdblReal3 = NULL;
	pdblReal3 = new double[iRows3*iCols3];

	for (int cnt = 0 ; cnt < iCols3; cnt++)
	{
		pdblReal3[iRows3*cnt] = matches[cnt].queryIdx;
		pdblReal3[iRows3*cnt+1] = matches[cnt].trainIdx;
		pdblReal3[iRows3*cnt+2] = matches[cnt].imgIdx;
		pdblReal3[iRows3*cnt+3] = matches[cnt].distance;
	}

	SciErr sciErr;
	sciErr = createMatrixOfDouble(pvApiCtx, nbInputArgument(pvApiCtx) + 1, iRows3, iCols3, pdblReal3);      
	AssignOutputVariable(pvApiCtx, 1) = nbInputArgument(pvApiCtx) + 1;	

	//SetImage(4,img_matches,pvApiCtx);

	////free(pdblReal);
	delete [] pdblReal3;

	return 0;
}

