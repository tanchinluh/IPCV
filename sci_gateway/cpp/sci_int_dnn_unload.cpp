/***********************************************************************
 * IPCV - Scilab Image Processing and Computer Vision toolbox
 * Copyright (C) 2017  Tan Chin Luh
***********************************************************************/

#include "common.h"

/************************************************************
*  sci_int_dnn_unload(char * fname,void* pvApiCtx)
************************************************************/


int sci_int_dnn_unload(char * fname,void* pvApiCtx)
{

	int nFile;
	double *out = NULL;
	int iRows = 0;
	int iCols = 0;

	CheckInputArgument(pvApiCtx, 1, 1);
	CheckOutputArgument(pvApiCtx, 0, 1);

	GetDouble(1, out, iRows, iCols, pvApiCtx);
	nFile = round(*out);

	//nFile = *((int *)(istk(lR)));
	nFile = nFile - 1;

	if (nFile >= 0 && nFile < MAX_DL_NUM)
	{
		if (!(DeepNet[nFile].net.empty()))
		{
			
			DeepNet[nFile].net = dnn::Net();
		}
		else
		{
			Scierror(999, "%s: The %d'th DNN is not opened.\r\n", fname, nFile + 1);
		}
	}
	else
	{
		Scierror(999, "%s: The argument should >=1 and <= %d.\r\n", fname, MAX_DL_NUM);
	}

	return 0;
}
