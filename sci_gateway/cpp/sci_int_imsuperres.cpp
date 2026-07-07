/***********************************************************************
* IPCV - Scilab Image Processing and Computer Vision toolbox
* Copyright (C) 2017  Tan Chin Luh
*
* Super resolution with Bilateral Total Variation
***********************************************************************/

#include "ipcv_gateway_common.h"
#include "ipcv_gateway_image.h"

int sci_int_imsuperres(char * fname,void* pvApiCtx)
{
	CheckInputArgument(pvApiCtx, 6, 6);
	CheckOutputArgument(pvApiCtx, 0, 1);

	IpcvImageList images;
	IpcvDecodedImage output;
	memset(&images, 0, sizeof(images));
	memset(&output, 0, sizeof(output));

	int iRet = ipcv_get_image_list_argument(pvApiCtx, 1, images);
	if (iRet)
	{
		Scierror(999, "%s: Wrong type for input argument #%d: List of images expected.\n", fname, 1);
		ipcv_release_image_list_argument(images);
		return iRet;
	}

	int iRows = 0;
	int iCols = 0;
	double *scaleFactor = NULL;
	double *iterations = NULL;
	double *beta = NULL;
	double *lambda = NULL;
	double *alpha = NULL;

	GetDouble(2, scaleFactor, iRows, iCols, pvApiCtx);
	GetDouble(3, iterations, iRows, iCols, pvApiCtx);
	GetDouble(4, beta, iRows, iCols, pvApiCtx);
	GetDouble(5, lambda, iRows, iCols, pvApiCtx);
	GetDouble(6, alpha, iRows, iCols, pvApiCtx);

	iRet = ipcv_superres_btv(&images, int(*scaleFactor), int(*iterations), float(*beta), float(*lambda), float(*alpha), &output);
	ipcv_release_image_list_argument(images);
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
