/***********************************************************************
 * IPCV - Scilab Image Processing and Computer Vision toolbox
 * Copyright (C) 2017  Tan Chin Luh
***********************************************************************/

#include "ipcv_gateway_common.h"
#include "ipcv_gateway_image.h"

int sci_int_imdetect_ORB(char * fname,void* pvApiCtx)
{

	CheckInputArgument(pvApiCtx, 9, 9);
	CheckOutputArgument(pvApiCtx, 0, 1);

	IpcvDecodedImage image;
	IpcvKeypointMatrix keypoints;
	memset(&keypoints, 0, sizeof(keypoints));
	double *val = NULL;
	int iRows			= 0;
	int iCols			= 0;
	int iRet = ipcv_get_image_argument(pvApiCtx, 1, image);
	if (iRet)
	{
		Scierror(999, "%s: Wrong type for input argument #%d: Image expected.\n", fname, 1);
		return iRet;
	}

	GetDouble(2,val,iRows,iCols,pvApiCtx);
	int nfeatures = int(*val);
	GetDouble(3,val,iRows,iCols,pvApiCtx);
	float scaleFactor = float(*val);
	GetDouble(4,val,iRows,iCols,pvApiCtx);
	int nlevels = int(*val);
	GetDouble(5,val,iRows,iCols,pvApiCtx);
	int edgeThreshold = int(*val);
	GetDouble(6,val,iRows,iCols,pvApiCtx);
	int firstLevel = int(*val);
	GetDouble(7,val,iRows,iCols,pvApiCtx);
	int WTA_K = int(*val);
	GetDouble(8,val,iRows,iCols,pvApiCtx);
	int scoreType=int(*val);
	GetDouble(9,val,iRows,iCols,pvApiCtx);
	int patchSize = int(*val);

	iRet = ipcv_detect_orb(&image, nfeatures, scaleFactor, nlevels, edgeThreshold, firstLevel, WTA_K, scoreType, patchSize, &keypoints);
	ipcv_release_image_argument(image);
	if (iRet)
	{
		Scierror(999, "%s: %s\n", fname, keypoints.error);
		ipcv_free_keypoint_matrix(&keypoints);
		return iRet;
	}

	iRet = ipcv_set_keypoint_matrix_argument(pvApiCtx, 1, keypoints);
	ipcv_free_keypoint_matrix(&keypoints);
	return iRet;
}
