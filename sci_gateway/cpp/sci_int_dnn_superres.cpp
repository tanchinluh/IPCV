/***********************************************************************
 * IPCV - Scilab Image Processing and Computer Vision toolbox
 * Copyright (C) 2017  Tan Chin Luh
***********************************************************************/

#include "common.h"
#include "ipcv_gateway_image.h"

int sci_int_dnn_superres(char * fname, void* pvApiCtx)
{
	CheckInputArgument(pvApiCtx, 4, 4);
	CheckOutputArgument(pvApiCtx, 0, 1);

	IpcvDecodedImage image;
	IpcvDecodedImage output;
	memset(&output, 0, sizeof(output));
	int iRet = ipcv_get_image_argument(pvApiCtx, 1, image);
	if (iRet)
	{
		Scierror(999, "%s: Wrong type for input argument #%d: Image expected.\n", fname, 1);
		return iRet;
	}

	char *model = NULL;
	double *scale = NULL;
	double *algorithmType = NULL;
	int iRows = 0;
	int iCols = 0;

	GetString(2, model, pvApiCtx);
	GetDouble(3, scale, iRows, iCols, pvApiCtx);
	GetDouble(4, algorithmType, iRows, iCols, pvApiCtx);

	int handle = -1;
	char error[1024] = {0};
	iRet = ipcv_dnn_superres_load(model, static_cast<int>(round(*scale)), static_cast<int>(round(*algorithmType)), &handle, error, static_cast<int>(sizeof(error)));
	if (iRet)
	{
		ipcv_release_image_argument(image);
		Scierror(999, "%s: %s\n", fname, error);
		return iRet;
	}

	iRet = ipcv_dnn_superres_upsample(handle, &image, &output);
	ipcv_release_image_argument(image);
	ipcv_dnn_unload(handle, error, static_cast<int>(sizeof(error)));
	if (iRet)
	{
		Scierror(999, "%s: %s\n", fname, output.error);
		ipcv_free_decoded_image(&output);
		return iRet;
	}

	iRet = ipcv_set_image_argument(pvApiCtx, 1, output);
	ipcv_free_decoded_image(&output);
	return iRet;
}
