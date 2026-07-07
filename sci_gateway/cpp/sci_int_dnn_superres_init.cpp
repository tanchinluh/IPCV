/***********************************************************************
 * IPCV - Scilab Image Processing and Computer Vision toolbox
 * Copyright (C) 2017  Tan Chin Luh
***********************************************************************/

#include "common.h"
#include "ipcv_gateway_image.h"

int sci_int_dnn_superres_init(char * fname, void* pvApiCtx)
{
	CheckInputArgument(pvApiCtx, 3, 3);
	CheckOutputArgument(pvApiCtx, 0, 1);

	char *model = NULL;
	double *scale = NULL;
	double *algorithmType = NULL;
	int iRows = 0;
	int iCols = 0;

	GetString(1, model, pvApiCtx);
	GetDouble(2, scale, iRows, iCols, pvApiCtx);
	GetDouble(3, algorithmType, iRows, iCols, pvApiCtx);

	int handle = -1;
	char error[1024] = {0};
	int iRet = ipcv_dnn_superres_load(model, static_cast<int>(round(*scale)), static_cast<int>(round(*algorithmType)), &handle, error, static_cast<int>(sizeof(error)));
	if (iRet)
	{
		Scierror(999, "%s: %s\n", fname, error);
		createScalarDouble(pvApiCtx, nbInputArgument(pvApiCtx) + 1, -1);
		AssignOutputVariable(pvApiCtx, 1) = nbInputArgument(pvApiCtx) + 1;
		return 0;
	}

	iRet = createScalarDouble(pvApiCtx, nbInputArgument(pvApiCtx) + 1, static_cast<double>(handle));
	if (iRet)
	{
		return iRet;
	}
	AssignOutputVariable(pvApiCtx, 1) = nbInputArgument(pvApiCtx) + 1;
	return 0;
}
