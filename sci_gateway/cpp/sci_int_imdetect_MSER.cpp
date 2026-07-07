/***********************************************************************
 * IPCV - Scilab Image Processing and Computer Vision toolbox
 * Copyright (C) 2017  Tan Chin Luh
***********************************************************************/

#include "ipcv_gateway_common.h"
#include "ipcv_gateway_image.h"

int sci_int_imdetect_MSER(char * fname,void* pvApiCtx)
{

	CheckInputArgument(pvApiCtx, 10, 10);
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
	int _delta = int(*val);
	GetDouble(3,val,iRows,iCols,pvApiCtx);
	int _min_area = int(*val);
	GetDouble(4,val,iRows,iCols,pvApiCtx);
	int _max_area = int(*val);
	GetDouble(5,val,iRows,iCols,pvApiCtx);
	float _max_variation = float(*val);
	GetDouble(6,val,iRows,iCols,pvApiCtx);
	float _min_diversity = float(*val);
	GetDouble(7,val,iRows,iCols,pvApiCtx);
	int _max_evolution = int(*val);
	GetDouble(8,val,iRows,iCols,pvApiCtx);
	double _area_threshold=*val;
	GetDouble(9,val,iRows,iCols,pvApiCtx);
	double _min_margin = *val;
	GetDouble(10,val,iRows,iCols,pvApiCtx);
	int _edge_blur_size = int(*val);

	iRet = ipcv_detect_mser(&image, _delta, _min_area, _max_area, _max_variation, _min_diversity, _max_evolution, _area_threshold, _min_margin, _edge_blur_size, &keypoints);
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
