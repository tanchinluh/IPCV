/***********************************************************************
 * IPCV - Scilab Image Processing and Computer Vision toolbox
 * Copyright (C) 2017  Tan Chin Luh
***********************************************************************/

#include "common.h"
#include "ipcv_gateway_image.h"

int sci_int_dnn_forward(char * fname, void* pvApiCtx)
{
	CheckInputArgument(pvApiCtx, 8, 8);
	CheckOutputArgument(pvApiCtx, 0, 1);

	double *handleValue = NULL;
	double *inputSize = NULL;
	char *layerName = NULL;
	double *scaleFactor = NULL;
	double *mean = NULL;
	double *swapRB = NULL;
	double *crop = NULL;
	int iRows = 0;
	int iCols = 0;

	GetDouble(1, handleValue, iRows, iCols, pvApiCtx);
	const int handle = static_cast<int>(round(*handleValue));

	IpcvDecodedImage image;
	int iRet = ipcv_get_image_argument(pvApiCtx, 2, image);
	if (iRet)
	{
		Scierror(999, "%s: Wrong type for input argument #%d: Image expected.\n", fname, 2);
		return iRet;
	}

	GetDouble(3, inputSize, iRows, iCols, pvApiCtx);
	GetString(4, layerName, pvApiCtx);
	GetDouble(5, scaleFactor, iRows, iCols, pvApiCtx);
	GetDouble(6, mean, iRows, iCols, pvApiCtx);
	GetDouble(7, swapRB, iRows, iCols, pvApiCtx);
	GetDouble(8, crop, iRows, iCols, pvApiCtx);

	IpcvDnnTensor output;
	memset(&output, 0, sizeof(output));
	iRet = ipcv_dnn_forward(handle, &image, static_cast<int>(inputSize[0]), static_cast<int>(inputSize[1]), layerName, *scaleFactor, mean, static_cast<int>(*swapRB), static_cast<int>(*crop), &output);
	ipcv_release_image_argument(image);
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
