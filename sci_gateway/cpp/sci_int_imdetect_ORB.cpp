/***********************************************************************
 * IPCV - Scilab Image Processing and Computer Vision toolbox
 * Copyright (C) 2017  Tan Chin Luh
***********************************************************************/

#include "common.h"

int sci_int_imdetect_ORB(char * fname,void* pvApiCtx)
{

	CheckInputArgument(pvApiCtx, 9, 9);
	CheckOutputArgument(pvApiCtx, 0, 1);

	Mat img1;
	GetImage(1,img1,pvApiCtx);


	if(img1.empty())
	{
		sciprint("Can't read image\n");
		return -1;
	}

	double *val = NULL;
	int iRows			= 0;
	int iCols			= 0;
	GetDouble(2,val,iRows,iCols,pvApiCtx);
	int nfeatures = int(*val);
	GetDouble(3,val,iRows,iCols,pvApiCtx);
	float scaleFactor = float(*val);
	GetDouble(4,val,iRows,iCols,pvApiCtx);
	int nlevels = int(*val);
	GetDouble(5,val,iRows,iCols,pvApiCtx);
	int edgeThreshold = int(*val);
	GetDouble(6,val,iRows,iCols,pvApiCtx);
	int firstLevel = int(*val);
	GetDouble(7,val,iRows,iCols,pvApiCtx);
	int WTA_K = int(*val);
	GetDouble(8,val,iRows,iCols,pvApiCtx);
	int scoreType=int(*val);
	GetDouble(9,val,iRows,iCols,pvApiCtx);
	int patchSize = int(*val);

	//ORB detector(nfeatures, scaleFactor,nlevels,edgeThreshold,firstLevel,WTA_K,scoreType, patchSize);
	Ptr<ORB> detector = ORB::create(nfeatures, scaleFactor, nlevels, edgeThreshold, firstLevel, WTA_K, ORB::ScoreType(scoreType), patchSize);

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

