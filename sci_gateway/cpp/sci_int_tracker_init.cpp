/***********************************************************************
 * IPCV - Scilab Image Processing and Computer Vision toolbox
 * Copyright (C) 2017  Tan Chin Luh
***********************************************************************/

#include "ipcv_gateway_common.h"
#include "ipcv_gateway_image.h"

int sci_int_tracker_init(char * fname, void* pvApiCtx)
{
	CheckInputArgument(pvApiCtx, 3, 3);
	CheckOutputArgument(pvApiCtx, 0, 1);

	IpcvDecodedImage image;
	int iRet = ipcv_get_image_argument(pvApiCtx, 1, image);
	if (iRet)
	{
		Scierror(999, "%s: Wrong type for input argument #%d: Image expected.\n", fname, 1);
		return iRet;
	}

	double *bbox = NULL;
	double *trackerType = NULL;
	int iRows = 0;
	int iCols = 0;

	GetDouble(2, bbox, iRows, iCols, pvApiCtx);
	GetDouble(3, trackerType, iRows, iCols, pvApiCtx);

	int trackerId = -1;
	char error[1024] = {0};
	iRet = ipcv_tracker_init(&image, bbox, static_cast<int>(*trackerType), &trackerId, error, static_cast<int>(sizeof(error)));
	ipcv_release_image_argument(image);
	if (iRet)
	{
		Scierror(999, "%s: %s\n", fname, error);
		return iRet;
	}

	iRet = createScalarDouble(pvApiCtx, nbInputArgument(pvApiCtx) + 1, static_cast<double>(trackerId));
	if (iRet)
	{
		return iRet;
	}

	AssignOutputVariable(pvApiCtx, 1) = nbInputArgument(pvApiCtx) + 1;
	return 0;
}
