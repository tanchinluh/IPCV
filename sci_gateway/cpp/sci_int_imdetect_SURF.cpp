/***********************************************************************
 * IPCV - Scilab Image Processing and Computer Vision toolbox
 * Copyright (C) 2017  Tan Chin Luh
***********************************************************************/

#include "common.h"

int sci_int_imdetect_SURF(char * fname,void* pvApiCtx)
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

	

	// double hessianThreshold, int nOctaves=4, int nOctaveLayers=2, bool extended=true, bool upright=false
	/*double *val = NULL;
	int iRows			= 0;
	int iCols			= 0;
	GetDouble(2,val,iRows,iCols,pvApiCtx);
	detector->set("hessianThreshold", *val);
	GetDouble(3,val,iRows,iCols,pvApiCtx);
	detector->set("nOctaves", int(*val));
	GetDouble(4,val,iRows,iCols,pvApiCtx);
	detector->set("nOctaveLayers", int(*val));
	GetDouble(5,val,iRows,iCols,pvApiCtx);
	detector->set("extended", (*val!=0));
	GetDouble(6,val,iRows,iCols,pvApiCtx);
	detector->set("upright", (*val!=0));*/

	// double hessianThreshold, int nOctaves=4, int nOctaveLayers=2, bool extended=true, bool upright=false
	double *val = NULL;
	int iRows = 0;
	int iCols = 0;
	GetDouble(2, val, iRows, iCols, pvApiCtx);
	double hessianThreshold = double(*val);
	GetDouble(3, val, iRows, iCols, pvApiCtx);
	int nOctaves = int(*val);
	GetDouble(4, val, iRows, iCols, pvApiCtx);
	int nOctaveLayers = int(*val);
	GetDouble(5, val, iRows, iCols, pvApiCtx);
	int extended = (*val != 0);
	GetDouble(6, val, iRows, iCols, pvApiCtx);
	int upright = (*val != 0);


	//Ptr<FeatureDetector> detector;
	//detector = FeatureDetector::create("SURF");

  try {
	Ptr<xfeatures2d::SURF> detector = xfeatures2d::SURF::create(hessianThreshold, nOctaves, nOctaveLayers, extended, upright);


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


