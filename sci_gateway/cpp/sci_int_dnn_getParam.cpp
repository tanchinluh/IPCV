/***********************************************************************
 * IPCV - Scilab Image Processing and Computer Vision toolbox
 * Copyright (C) 2017  Tan Chin Luh
***********************************************************************/

#include "ipcv_gateway_common.h"
#include "ipcv_gateway_image.h"

int sci_int_dnn_getParam(char * fname, void* pvApiCtx)
{
	CheckInputArgument(pvApiCtx, 3, 3);
	CheckOutputArgument(pvApiCtx, 0, 1);

	double *handleValue = NULL;
	char *layerName = NULL;
	double *paramIndex = NULL;
	int iRows = 0;
	int iCols = 0;

	GetDouble(1, handleValue, iRows, iCols, pvApiCtx);
	GetString(2, layerName, pvApiCtx);
	GetDouble(3, paramIndex, iRows, iCols, pvApiCtx);

	IpcvDnnTensor output;
	memset(&output, 0, sizeof(output));
	int iRet = ipcv_dnn_get_param(static_cast<int>(round(*handleValue)), layerName, static_cast<int>(*paramIndex), &output);
	if (iRet)
	{
		Scierror(999, "%s: %s\n", fname, output.error);
		ipcv_dnn_free_tensor(&output);
		return iRet;
	}

	const int outVar = nbInputArgument(pvApiCtx) + 1;
	SciErr sciErr = createHypermatOfDouble(pvApiCtx, outVar, output.dims, output.ndims, output.data);
	if (sciErr.iErr)
	{
		printError(&sciErr, 0);
		ipcv_dnn_free_tensor(&output);
		return sciErr.iErr;
	}

	AssignOutputVariable(pvApiCtx, 1) = outVar;
	ipcv_dnn_free_tensor(&output);
	return 0;
}
