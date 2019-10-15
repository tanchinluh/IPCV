/***********************************************************************
*  Copyright (C) Trity Technologies - 2012 -
* http://www.gnu.org/licenses/gpl-2.0.txt
***********************************************************************/

#include "common.h"

int sci_int_imdrawmatches(char * fname,void* pvApiCtx)
{

	CheckInputArgument(pvApiCtx, 5, 5);
	CheckOutputArgument(pvApiCtx, 0, 1);

	Mat img1,img2;

	GetImage(1,img1,pvApiCtx);
	GetImage(2,img2,pvApiCtx);

	int iRows1in = 0;
	int iCols1in = 0;
	double* mData = NULL;
	GetDouble(3,mData,iRows1in,iCols1in,pvApiCtx);
	int iRows2in = 0;
	int iCols2in = 0;
	double* nData = NULL;
	GetDouble(4,nData,iRows2in,iCols2in,pvApiCtx);
	int iRows3in = 0;
	int iCols3in = 0;
	double* oData = NULL;
	GetDouble(5,oData,iRows3in,iCols3in,pvApiCtx);

	vector<KeyPoint> keypoints1,keypoints2;

	// Extract data into keypoints
	for (int cnt = 0 ; cnt < iCols1in; cnt++)
	{
		//	keypoints1.push_back(KeyPoint(*(nData+iRows2in*cnt),*(nData+iRows2in*cnt+1),4,-1,0,0,-1)); 
		keypoints1.push_back(KeyPoint(*(mData+iRows1in*cnt),
			*(mData+iRows1in*cnt+1),
			*(mData+iRows1in*cnt+2),
			*(mData+iRows1in*cnt+3),
			*(mData+iRows1in*cnt+4),
			*(mData+iRows1in*cnt+5),
			*(mData+iRows1in*cnt+6))); 
	}

	for (int cnt = 0 ; cnt < iCols2in; cnt++)
	{
		//	keypoints1.push_back(KeyPoint(*(nData+iRows2in*cnt),*(nData+iRows2in*cnt+1),4,-1,0,0,-1)); 
		keypoints2.push_back(KeyPoint(*(nData+iRows2in*cnt),
			*(nData+iRows2in*cnt+1),
			*(nData+iRows2in*cnt+2),
			*(nData+iRows2in*cnt+3),
			*(nData+iRows2in*cnt+4),
			*(nData+iRows2in*cnt+5),
			*(nData+iRows2in*cnt+6))); 
	}

	// computing descriptors
	vector<DMatch> matches;
	for (int cnt = 0 ; cnt < iCols3in; cnt++)
	{
		//	keypoints1.push_back(KeyPoint(*(nData+iRows2in*cnt),*(nData+iRows2in*cnt+1),4,-1,0,0,-1)); 
		matches.push_back(DMatch(*(oData+iRows3in*cnt)-1,
			*(oData+iRows3in*cnt+1)-1,
			*(oData+iRows3in*cnt+2),
			*(oData+iRows3in*cnt+3))); 
	}


	Mat img_matches;
	drawMatches(img1, keypoints1, img2, keypoints2, matches, img_matches);

	SetImage(1,img_matches,pvApiCtx);

	return 0;
}

