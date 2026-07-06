/***********************************************************************
* IPCV - Scilab Image Processing and Computer Vision toolbox
* Copyright (C) 2017  Tan Chin Luh
***********************************************************************/

#include "common.h"
#include "ipcv_gateway_image.h"

int sci_int_imstitchImage(char *fname,void* pvApiCtx)
{
	CheckInputArgument(pvApiCtx, 7, 7);
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
	double *registrationResol = NULL;
	double *seamEstimationResol = NULL;
	double *compositingResol = NULL;
	double *panoConfidenceThresh = NULL;
	double *waveCorrection = NULL;
	double *blenderBands = NULL;

	GetDouble(2, registrationResol, iRows, iCols, pvApiCtx);
	GetDouble(3, seamEstimationResol, iRows, iCols, pvApiCtx);
	GetDouble(4, compositingResol, iRows, iCols, pvApiCtx);
	GetDouble(5, panoConfidenceThresh, iRows, iCols, pvApiCtx);
	GetDouble(6, waveCorrection, iRows, iCols, pvApiCtx);
	GetDouble(7, blenderBands, iRows, iCols, pvApiCtx);

	iRet = ipcv_stitch_images(&images, *registrationResol, *seamEstimationResol, *compositingResol, *panoConfidenceThresh, int(*waveCorrection), int(*blenderBands), &output);
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
