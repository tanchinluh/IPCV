/***********************************************************************
 * IPCV - Scilab Image Processing and Computer Vision toolbox
 * Copyright (C) 2017  Tan Chin Luh
***********************************************************************/

#include "common.h"

int sci_int_imdetect_SIFT(char * fname,void* pvApiCtx)
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


	// int nfeatures=0, int nOctaveLayers=3, double contrastThreshold=0.04, double edgeThreshold=10, double sigma=1.6
	double *val = NULL;
	int iRows			= 0;
	int iCols			= 0;
	GetDouble(2,val,iRows,iCols,pvApiCtx);
	int nfeatures=int(*val);
	GetDouble(3,val,iRows,iCols,pvApiCtx);
	int nOctaveLayers=int(*val);
	GetDouble(4,val,iRows,iCols,pvApiCtx);
	double contrastThreshold=*val;
	GetDouble(5,val,iRows,iCols,pvApiCtx);
	double edgeThreshold=*val;
	GetDouble(6,val,iRows,iCols,pvApiCtx);
	double sigma=*val;
		
    
    try {
	Ptr<xfeatures2d::SIFT> detector = xfeatures2d::SIFT::create(nfeatures, nOctaveLayers,contrastThreshold,edgeThreshold,sigma);


	vector<KeyPoint> keypoints1;
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

    } catch (cv::Exception & e) {
        char* pData = const_cast<char *>((e.err).c_str());
        SetString(1,pData,pvApiCtx);
        return 0;
    }

	return 0;
}



