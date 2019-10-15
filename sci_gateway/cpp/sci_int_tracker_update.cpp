/***********************************************************************
 * IPCV - Scilab Image Processing and Computer Vision toolbox
 * Copyright (C) 2017  Tan Chin Luh
***********************************************************************/

#include "common.h"
//#include <opencv2/core/utils/trace.hpp>


/************************************************************
* imout = sci_int_dnn_forward(imin, se);
************************************************************/

int sci_int_tracker_update(char * fname, void* pvApiCtx)
{
	Mat pSrcImg, pDstImg;
	int iRet = 0;
	int iRows = 0;
	int iCols = 0;
	double *sz1 = NULL;
	double *sz2 = NULL;
	double *sf = NULL;
	int nFile;
	Mat img;
	char *pstName = NULL;
	double *out = NULL;
	int nWidth, nHeight;
	double R, G, B;
	bool swapRB,crop;

	CheckInputArgument(pvApiCtx, 0, 8);
	CheckOutputArgument(pvApiCtx, 0, 1);

	try
	{
		// Input 1 : Pointer to the DNN
		GetDouble(1, out, iRows, iCols, pvApiCtx);
		nFile = round(*out);
		nFile -= 1;

		// Input 2 : Image
		GetImage(2, img, pvApiCtx);

		// Input 3 : Image Size
		//GetDouble(3, sz1, iRows, iCols, pvApiCtx);
		//Rect2d bbox(*sz1, *(sz1 + 1), *(sz1 + 2), *(sz1 + 3));

		

		// tracker->update(frame, roi);

		// Error Checking
		// ObjTrack[nCurrFile].trackobj 
		if (ObjTrack[nFile].trackobj.empty())
		{
			Scierror(999, "%s: Could not load tracker.\n", fname);
			return -1;
		}

		if (img.empty())
		{
			Scierror(999, "%s: Not a valid image\n", fname);
			return -1;
		}


		//sciprint("img : %i %i\n", img.type(), img.depth());

		//GoogLeNet accepts only 224x224 BGR-images
		Rect2d bbox;
		ObjTrack[nFile].trackobj->update(img, bbox);

		//sciprint("%f\t%f\t%f\t%f\n", bbox.x, bbox.y, bbox.width, bbox.height);
		
		int iRows1 = 4;
		int iCols1 = 1;
		double* pdblReal1 = NULL;
		pdblReal1 = new double[iRows1*iCols1];


		//	for (int cnt = 0; cnt < iCols1; cnt++)
		//	{
		pdblReal1[0] = (double)bbox.x;
		pdblReal1[1] = (double)bbox.y;
		pdblReal1[2] = (double)bbox.width;
		pdblReal1[3] = (double)bbox.height;
		//	}

		SetDouble(1, pdblReal1, iRows1, iCols1, pvApiCtx);
		delete[] pdblReal1;

		//AssignOutputVariable(pvApiCtx, 1) = nbInputArgument(pvApiCtx) + 1;

		//SetImage(1, prob,pvApiCtx);
	}
	catch (const cv::Exception& e)
	{
		sciprint("Error code: %i \n", e.code);
		sciprint("Error description: %s \n", e.err.c_str());
		sciprint("Error source: %s \n", e.file.c_str());
		sciprint("Error function: %s \n", e.func.c_str());
		sciprint("Error line: %i \n", e.line);
		iRet = createScalarDouble(pvApiCtx, nbInputArgument(pvApiCtx) + 1, -1);
		AssignOutputVariable(pvApiCtx, 1) = nbInputArgument(pvApiCtx) + 1;
		return -1;
	}
	return 0;


}
