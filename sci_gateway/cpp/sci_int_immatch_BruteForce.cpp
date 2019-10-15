/***********************************************************************
 * IPCV - Scilab Image Processing and Computer Vision toolbox
 * Copyright (C) 2017  Tan Chin Luh
***********************************************************************/

#include "common.h"

int sci_int_immatch_BruteForce(char * fname,void* pvApiCtx)
{

	CheckInputArgument(pvApiCtx, 3, 3);
	CheckOutputArgument(pvApiCtx, 0, 1);

	Mat d1,d2,descriptors1, descriptors2;

	GetImage(1,d1,pvApiCtx);
	GetImage(2,d2,pvApiCtx);

	int iRows1 = 0;
	int iCols1 = 0;
	double* mData = NULL;

	GetDouble(3,mData,iRows1,iCols1,pvApiCtx);

	//sciprint("%i\n",d1.type());
	//DescriptorMatcher matcher();
	Ptr<DescriptorMatcher> matcher;  

	if(*mData == 1) { 
		matcher = DescriptorMatcher::create("BruteForce-L1"); 
		if (d1.type() == 0)
		{
			d1.convertTo(descriptors1,CV_32F,1/255.0);
			d2.convertTo(descriptors2,CV_32F,1/255.0);
		}
		else if (d1.type() == 6)
		{
			d1.convertTo(descriptors1,CV_32F);
			d2.convertTo(descriptors2,CV_32F);
		}
		else
		{
			Scierror(999,"Error\n");
		}

	}else if(*mData == 2) {
		matcher = DescriptorMatcher::create("BruteForce"); 
		if (d1.type() == 0)
		{
			d1.convertTo(descriptors1,CV_32F,1/255.0);
			d2.convertTo(descriptors2,CV_32F,1/255.0);
		}
		else if (d1.type() == 6)
		{
			d1.convertTo(descriptors1,CV_32F);
			d2.convertTo(descriptors2,CV_32F);
		}
		else
		{
			Scierror(999,"Error\n");
		}
	}else if(*mData == 3) {
		matcher = DescriptorMatcher::create("BruteForce-Hamming"); 
		if (d1.type() == 0)
		{
			descriptors1 = d1;
			descriptors2 = d2;
		}
		else if (d1.type() == 6)
		{
			d1.convertTo(descriptors1,CV_8U,255.0);
			d2.convertTo(descriptors2,CV_8U,255.0);
		}
		else
		{
			Scierror(999,"Error\n");
		}

	}else if(*mData == 4) {
		matcher = DescriptorMatcher::create("BruteForce-Hamming(2)"); 
		if (d1.type() == 0)
		{
			descriptors1 = d1;
			descriptors2 = d2;
		}
		else if (d1.type() == 6)
		{
			d1.convertTo(descriptors1,CV_8U,255.0);
			d2.convertTo(descriptors2,CV_8U,255.0);
		}
		else
		{
			Scierror(999,"Error\n");
		}

	} else  {
		Scierror(999,"Error\n");
	}

	//enum { NORM_INF=1, NORM_L1=2, NORM_L2=4, NORM_L2SQR=5, NORM_HAMMING=6, NORM_HAMMING2=7, NORM_TYPE_MASK=7, NORM_RELATIVE=8, NORM_MINMAX=32 };
	// NORM_L1, NORM_L2, NORM_HAMMING, NORM_HAMMING2
	// matching descriptors  BFMatcher matcher(NORM_L2); BruteForceMatcher<Hamming> matcher; BFMatcher matcher_popcount(NORM_HAMMING);
	//BruteForceMatcher<L2<float> > matcher;
	//BFMatcher matcher(NORM_L2); 

	vector<DMatch> matches;
	matcher->match(descriptors1, descriptors2, matches);

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

	//SciErr sciErr;
	//sciErr = createMatrixOfDouble(pvApiCtx, nbInputArgument(pvApiCtx) + 1, iRows3, iCols3, pdblReal3);      
	//AssignOutputVariable(pvApiCtx, 1) = nbInputArgument(pvApiCtx) + 1;	

	SetDouble(1,pdblReal3,iRows3,iCols3,pvApiCtx);

	delete [] pdblReal3;


	return 0;
}

