/***********************************************************************
 * IPCV - Scilab Image Processing and Computer Vision toolbox
 * Copyright (C) 2017  Tan Chin Luh
***********************************************************************/

#include "common.h"

/************************************************************
* imout = int_imdilate(imin, se);
************************************************************/

int sci_int_immedian(char * fname,void* pvApiCtx)
{
	Mat pSrcImg, pDstImg;
	int iRows			= 0;
	int iCols			= 0;
	double *sz1 = NULL;
	int sz2;

	CheckInputArgument(pvApiCtx, 2, 2);
	CheckOutputArgument(pvApiCtx, 1, 1);


	GetImage(1,pSrcImg,pvApiCtx);
	GetDouble(2,sz1,iRows,iCols,pvApiCtx);
	
	sz2 = round(*sz1);

	medianBlur(pSrcImg, pDstImg, sz2);
	
	SetImage(1,pDstImg,pvApiCtx);

	return 0;

	
}
