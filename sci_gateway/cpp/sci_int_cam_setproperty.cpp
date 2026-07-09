/***********************************************************************
 * IPCV - Scilab Image Processing and Computer Vision toolbox
 * Copyright (C) 2017  Tan Chin Luh
***********************************************************************/

#include "ipcv_gateway_common.h"
#include "ipcv_gateway_image.h"

int sci_int_cam_setproperty(char *fname, void* pvApiCtx)
{
	CheckInputArgument(pvApiCtx, 3, 3);
	CheckOutputArgument(pvApiCtx, 1, 1);

	double *handleValue = NULL;
	double *propertyValue = NULL;
	double *newValue = NULL;
	int rows = 0;
	int cols = 0;
	GetDouble(1, handleValue, rows, cols, pvApiCtx);
	GetDouble(2, propertyValue, rows, cols, pvApiCtx);
	GetDouble(3, newValue, rows, cols, pvApiCtx);

	char error[1024] = {0};
	int iRet = ipcv_cam_set_property(static_cast<int>(*handleValue), static_cast<int>(*propertyValue), *newValue, error, static_cast<int>(sizeof(error)));
	if (iRet)
	{
		Scierror(999, "%s: %s.\r\n", fname, error);
		return iRet;
	}

	iRet = createScalarDouble(pvApiCtx, nbInputArgument(pvApiCtx) + 1, 1.0);
	if (iRet)
	{
		return iRet;
	}

	AssignOutputVariable(pvApiCtx, 1) = nbInputArgument(pvApiCtx) + 1;
	return 0;
}
