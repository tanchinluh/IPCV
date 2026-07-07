/***********************************************************************
 * IPCV - Scilab Image Processing and Computer Vision toolbox
 * Copyright (C) 2017  Tan Chin Luh
***********************************************************************/

#include "ipcv_gateway_common.h"
#include "ipcv_gateway_image.h"

int sci_int_imdetect_SURF(char * fname,void* pvApiCtx)
{

	CheckInputArgument(pvApiCtx, 6, 6);
	CheckOutputArgument(pvApiCtx, 0, 1);

	IpcvDecodedImage image;
	IpcvKeypointMatrix keypoints;
	memset(&keypoints, 0, sizeof(keypoints));
	double *val = NULL;
	int iRows = 0;
	int iCols = 0;
	int iRet = ipcv_get_image_argument(pvApiCtx, 1, image);
	if (iRet)
	{
		Scierror(999, "%s: Wrong type for input argument #%d: Image expected.\n", fname, 1);
		return iRet;
	}

	GetDouble(2, val, iRows, iCols, pvApiCtx);
	double hessianThreshold = double(*val);
	GetDouble(3, val, iRows, iCols, pvApiCtx);
	int nOctaves = int(*val);
	GetDouble(4, val, iRows, iCols, pvApiCtx);
	int nOctaveLayers = int(*val);
	GetDouble(5, val, iRows, iCols, pvApiCtx);
	int extended = (*val != 0);
	GetDouble(6, val, iRows, iCols, pvApiCtx);
	int upright = (*val != 0);

	iRet = ipcv_detect_surf(&image, hessianThreshold, nOctaves, nOctaveLayers, extended, upright, &keypoints);
	ipcv_release_image_argument(image);
	if (iRet)
	{
		sciprint("%s: %s\n", fname, keypoints.error);
		ipcv_free_keypoint_matrix(&keypoints);
		keypoints.rows = 7;
		keypoints.cols = 0;
		keypoints.data = static_cast<double*>(calloc(1, sizeof(double)));
		if (keypoints.data == NULL)
		{
			Scierror(999, "%s: out of memory\n", fname);
			return -1;
		}
	}

	iRet = ipcv_set_keypoint_matrix_argument(pvApiCtx, 1, keypoints);
	ipcv_free_keypoint_matrix(&keypoints);
	return iRet;
}
