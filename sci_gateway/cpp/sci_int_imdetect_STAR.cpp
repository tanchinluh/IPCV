/***********************************************************************
 * IPCV - Scilab Image Processing and Computer Vision toolbox
 * Copyright (C) 2017  Tan Chin Luh
***********************************************************************/

#include "common.h"
#include "ipcv_gateway_image.h"

int sci_int_imdetect_STAR(char * fname,void* pvApiCtx)
{

	CheckInputArgument(pvApiCtx, 6, 6);
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
	int maxSize=int(*val);
	GetDouble(3,val,iRows,iCols,pvApiCtx);
	int responseThreshold=int(*val);
	GetDouble(4,val,iRows,iCols,pvApiCtx);
	int lineThresholdProjected = int(*val);
	GetDouble(5,val,iRows,iCols,pvApiCtx);
	int lineThresholdBinarized=int(*val);
	GetDouble(6,val,iRows,iCols,pvApiCtx);
	int suppressNonmaxSize=int(*val);	

	iRet = ipcv_detect_star(&image, maxSize, responseThreshold, lineThresholdProjected, lineThresholdBinarized, suppressNonmaxSize, &keypoints);
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
