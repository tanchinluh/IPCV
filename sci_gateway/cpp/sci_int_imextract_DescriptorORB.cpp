/***********************************************************************
*  Copyright (C) Trity Technologies - 2012 -
* http://www.gnu.org/licenses/gpl-2.0.txt
***********************************************************************/

#include "common.h"

int sci_int_imextract_DescriptorORB(char * fname,void* pvApiCtx)
{

	CheckInputArgument(pvApiCtx, 2, 2);
	CheckOutputArgument(pvApiCtx, 0, 1);

	Mat img1;

	GetImage(1,img1,pvApiCtx);

	int iRows1in = 0;
	int iCols1in = 0;
	double* mData = NULL;

	GetDouble(2,mData,iRows1in,iCols1in,pvApiCtx);

	vector<KeyPoint> keypoints1;

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

	// computing descriptors
	//ORB extractor;
	Ptr<ORB> extractor = ORB::create();

	Mat descriptors1;
	extractor->compute(img1, keypoints1, descriptors1);

	SetImage(1,descriptors1,pvApiCtx);

	return 0;
}

