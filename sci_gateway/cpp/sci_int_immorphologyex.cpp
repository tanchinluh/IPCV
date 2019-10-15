/***********************************************************************
 * IPCV - Scilab Image Processing and Computer Vision toolbox
 * Copyright (C) 2017  Tan Chin Luh
 ***********************************************************************/


#include "common.h"



/************************************************************
* imout = int_immorphologyex(imin, se, operation);
************************************************************/


int sci_int_immorphologyex(char * fname,void* pvApiCtx)
{

	SciErr sciErr;
	int* piAddr     = NULL;
	int iType       = 0;
	int iRet        = 0;
	int iPrec       = 0;
	char op  = 0;
	Mat src;
	Mat dst;
	Mat se;

	GetImage(1,src,pvApiCtx);
	GetImage(2,se,pvApiCtx);
	getVarAddressFromPosition(pvApiCtx, 3, &piAddr);
	getScalarInteger8(pvApiCtx, piAddr, &op);

	morphologyEx(src,dst,op,se);

	SetImage(1,dst,pvApiCtx);

	return 0;


}

