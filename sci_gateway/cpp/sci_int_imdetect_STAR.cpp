/***********************************************************************
 * IPCV - Scilab Image Processing and Computer Vision toolbox
 * Copyright (C) 2017  Tan Chin Luh
***********************************************************************/

#include "common.h"

int sci_int_imdetect_STAR(char * fname,void* pvApiCtx)
{

	CheckInputArgument(pvApiCtx, 6, 6);
	CheckOutputArgument(pvApiCtx, 0, 1);

	Mat img1;
	GetImage(1,img1,pvApiCtx);


	if(img1.empty())
	{
		sciprint("Can't read image\n");
		return -1;
	}


	// int maxSize=16, int responseThreshold=30, int lineThresholdProjected = 10, int lineThresholdBinarized=8, int suppressNonmaxSize=5 );
	double *val = NULL;
	int iRows			= 0;
	int iCols			= 0;
	GetDouble(2,val,iRows,iCols,pvApiCtx);
	int maxSize=int(*val);
	GetDouble(3,val,iRows,iCols,pvApiCtx);
	int responseThreshold=int(*val);
	GetDouble(4,val,iRows,iCols,pvApiCtx);
	int lineThresholdProjected = int(*val);
	GetDouble(5,val,iRows,iCols,pvApiCtx);
	int lineThresholdBinarized=int(*val);
	GetDouble(6,val,iRows,iCols,pvApiCtx);
	int suppressNonmaxSize=int(*val);	

	//StarFeatureDetector detector(maxSize,responseThreshold,lineThresholdProjected,lineThresholdBinarized,suppressNonmaxSize);
	Ptr<xfeatures2d::StarDetector> detector = xfeatures2d::StarDetector::create(maxSize, responseThreshold, lineThresholdProjected, lineThresholdBinarized, suppressNonmaxSize);

	vector<KeyPoint> keypoints1;
	//detector.detect(img1, keypoints1);
	detector->detect(img1, keypoints1);


	int iRows1			= 7;
	int iCols1			= keypoints1.size()*1;
	double* pdblReal1 = NULL;
	pdblReal1 = new double[iRows1*iCols1];


	for (int cnt = 0 ; cnt < iCols1; cnt++)
	{
		pdblReal1[iRows1*cnt] = keypoints1[cnt].pt.x;
		pdblReal1[iRows1*cnt+1] = keypoints1[cnt].pt.y;
		pdblReal1[iRows1*cnt+2] = keypoints1[cnt].size;
		pdblReal1[iRows1*cnt+3] = keypoints1[cnt].angle;
		pdblReal1[iRows1*cnt+4] = keypoints1[cnt].response;
		pdblReal1[iRows1*cnt+5] = keypoints1[cnt].octave; 
		pdblReal1[iRows1*cnt+6] = keypoints1[cnt].class_id; 
	}


	SetDouble(1,pdblReal1,iRows1,iCols1,pvApiCtx);

	delete [] pdblReal1;

	return 0;
}

