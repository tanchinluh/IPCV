/***********************************************************************
 * IPCV - Scilab Image Processing and Computer Vision toolbox
 * Copyright (C) 2017  Tan Chin Luh
***********************************************************************/

#include "common.h"
#include "ipcv_gateway_image.h"

int sci_aviclose(char *fname, void* pvApiCtx)
{
	CheckInputArgument(pvApiCtx, 1, 1);
	CheckOutputArgument(pvApiCtx, 0, 1);

	double *handleValue = NULL;
	int iRows = 0;
	int iCols = 0;
	GetDouble(1, handleValue, iRows, iCols, pvApiCtx);

	char error[1024] = {0};
	int iRet = ipcv_avi_close(static_cast<int>(*handleValue), error, static_cast<int>(sizeof(error)));
	if (iRet)
	{
		Scierror(999, "%s: %s.\r\n", fname, error);
		return iRet;
	}

	return 0;
}
