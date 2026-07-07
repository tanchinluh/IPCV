/***********************************************************************
 * IPCV - Scilab Image Processing and Computer Vision toolbox
 * Copyright (C) 2017  Tan Chin Luh
***********************************************************************/

#include "ipcv_gateway_common.h"
#include "ipcv_gateway_image.h"

int sci_int_dnn_unload(char * fname,void* pvApiCtx)
{
	CheckInputArgument(pvApiCtx, 1, 1);
	CheckOutputArgument(pvApiCtx, 0, 1);

	double *handleValue = NULL;
	int iRows = 0;
	int iCols = 0;
	GetDouble(1, handleValue, iRows, iCols, pvApiCtx);

	char error[1024] = {0};
	int iRet = ipcv_dnn_unload(static_cast<int>(round(*handleValue)), error, static_cast<int>(sizeof(error)));
	if (iRet)
	{
		Scierror(999, "%s: %s\n", fname, error);
		return iRet;
	}
	return 0;
}
