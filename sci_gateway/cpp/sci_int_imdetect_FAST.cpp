/***********************************************************************
 * IPCV - Scilab Image Processing and Computer Vision toolbox
 * Copyright (C) 2017  Tan Chin Luh
***********************************************************************/

#include "common.h"

int sci_int_imdetect_FAST(char * fname,void* pvApiCtx)
{

	CheckInputArgument(pvApiCtx, 4, 4);
	CheckOutputArgument(pvApiCtx, 0, 1);

	Mat img1;
	GetImage(1,img1,pvApiCtx);
	
	if(img1.empty())
	{
		sciprint("Can't read image\n");
		return -1;
	}

	///////////////

	double *val = NULL;
	int iRows = 0;
	int iCols = 0;
	GetDouble(2, val, iRows, iCols, pvApiCtx);
	double threshold = double(*val);
	GetDouble(3, val, iRows, iCols, pvApiCtx);
	double nonmaxSuppression = (*val != 0);
	GetDouble(4, val, iRows, iCols, pvApiCtx);
	int type = int(*val);


	/////////////////

	Ptr<FastFeatureDetector> detector;
	detector = FastFeatureDetector::create(threshold, nonmaxSuppression, FastFeatureDetector::DetectorType(type));

	

	vector<KeyPoint> keypoints1;
	detector->detect(img1, keypoints1);
	
	int iRows1 = 7;
	int iCols1 = keypoints1.size()*1;
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


	//SciErr sciErr;
	//sciErr = createMatrixOfDouble(pvApiCtx, nbInputArgument(pvApiCtx) + 1, iRows1, iCols1, pdblReal1);      
	//AssignOutputVariable(pvApiCtx, 1) = nbInputArgument(pvApiCtx) + 1;	
	SetDouble(1,pdblReal1,iRows1,iCols1,pvApiCtx);

	////free(pdblReal);
	delete [] pdblReal1;

	return 0;
}

