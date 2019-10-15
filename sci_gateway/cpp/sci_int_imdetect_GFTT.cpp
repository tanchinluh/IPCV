/***********************************************************************
 * IPCV - Scilab Image Processing and Computer Vision toolbox
 * Copyright (C) 2017  Tan Chin Luh
***********************************************************************/

#include "common.h"

int sci_int_imdetect_GFTT(char * fname,void* pvApiCtx)
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

	// int maxCorners=1000, double qualityLevel=0.01,
               // double minDistance=1., int blockSize=3,
               // bool useHarrisDetector=false, double k=0.04 
	double *val = NULL;
	int iRows			= 0;
	int iCols			= 0;
	GetDouble(2,val,iRows,iCols,pvApiCtx);
	int maxCorner=int(*val);
	GetDouble(3,val,iRows,iCols,pvApiCtx);
	double qualityLevel=*val;
	GetDouble(4,val,iRows,iCols,pvApiCtx);
	double minDistance=*val;
	GetDouble(5,val,iRows,iCols,pvApiCtx);
	int blockSize=int(*val);
	GetDouble(6,val,iRows,iCols,pvApiCtx);
	double k=*val;


	//GoodFeaturesToTrackDetector detector(maxCorner,qualityLevel,minDistance,blockSize,false,k);
	Ptr<GFTTDetector> detector = GFTTDetector::create(maxCorner, qualityLevel, minDistance, blockSize, false, k);

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

