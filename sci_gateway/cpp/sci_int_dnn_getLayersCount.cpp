/***********************************************************************
 * IPCV - Scilab Image Processing and Computer Vision toolbox
 * Copyright (C) 2017  Tan Chin Luh
***********************************************************************/

#include "common.h"

/************************************************************
* imout = sci_int_dnn_forward(imin, se);
************************************************************/


int sci_int_dnn_getLayersCount(char * fname,void* pvApiCtx)
{

	int iRows			= 0;
	int iCols			= 0;
	int nFile;
	double *out = NULL;

	CheckInputArgument(pvApiCtx, 1, 1);
	CheckOutputArgument(pvApiCtx, 0, 1);
	
	GetDouble(1, out, iRows, iCols, pvApiCtx);
	nFile = round(*out);
	nFile -= 1;
	
	GetDouble(1, out, iRows, iCols, pvApiCtx);
	nFile = round(*out);
	nFile -= 1;

	if (DeepNet[nFile].net.empty())
	{
		Scierror(999, "%s: Not a valid image\n", fname, MAX_AVI_FILE_NUM);
		return -1;
	}
	


	return 0;

	
}
