/***********************************************************************
 * IPCV - Scilab Image Processing and Computer Vision toolbox
 * Copyright (C) 2017  Tan Chin Luh
 ***********************************************************************/

#include "common.h"

/**********************************************************************
* This function is using the OpenCV highgui function for plotting image
* imdisplay(imin);
**********************************************************************/
int sci_int_imwrite(char * fname,void* pvApiCtx)
{
	SciErr sciErr;

	CheckInputArgument(pvApiCtx, 3, 3);
	CheckOutputArgument(pvApiCtx, 0, 1);

	/////////////////
	// First Input //
	/////////////////
	Mat pSrcImg;
	int* piAddr = NULL;
	char* pstData = NULL;
	int iRet    = 0;
	GetImage(1,pSrcImg,pvApiCtx);
	// sciprint(".");
	sciErr = getVarAddressFromPosition(pvApiCtx, 2, &piAddr);
	iRet = getAllocatedSingleString(pvApiCtx, piAddr, &pstData);
		if(iRet)
		{
			freeAllocatedSingleString(pstData);
			return iRet;
		}
    
	// Second Input - Rotation angle
	int *piAddr2 = NULL;
	double compression_ratio = 0;
	getVarAddressFromPosition(pvApiCtx, 3, &piAddr2);
	getScalarDouble(pvApiCtx, piAddr2, &compression_ratio);


	vector<int> p(2);
	p[0] = IMWRITE_JPEG_QUALITY;
	p[1] = int(compression_ratio); // compression factor


	int retval = imwrite( pstData, pSrcImg, p);
	int iRows1 = 1;
	int iCols1 = 1;
	double pdblReal1;
	pdblReal1 = double(retval);

	//SetDouble(1, pdblReal1, iRows1, iCols1, pvApiCtx);
	iRet = createScalarDouble(pvApiCtx, nbInputArgument(pvApiCtx) + 1, pdblReal1);
	AssignOutputVariable(pvApiCtx, 1) = nbInputArgument(pvApiCtx) + 1;

	return 0;

}
