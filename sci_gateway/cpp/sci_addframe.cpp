/***********************************************************************
 * IPCV - Scilab Image Processing and Computer Vision toolbox
 * Copyright (C) 2017  Tan Chin Luh
***********************************************************************/

#include "common.h"
#include "ipcv_gateway_image.h"

int sci_addframe(char * fname, void* pvApiCtx)
{
	CheckInputArgument(pvApiCtx, 2, 2);
	CheckOutputArgument(pvApiCtx, 0, 1);

	double *handleValue = NULL;
	int iRows = 0;
	int iCols = 0;
	GetDouble(1, handleValue, iRows, iCols, pvApiCtx);

	IpcvDecodedImage frame;
	int iRet = ipcv_get_image_argument(pvApiCtx, 2, frame);
	if (iRet)
	{
		Scierror(999, "%s: Wrong type for input argument #%d: Image expected.\n", fname, 2);
		return iRet;
	}

	char error[1024] = {0};
	iRet = ipcv_avi_add_frame(static_cast<int>(*handleValue), &frame, error, static_cast<int>(sizeof(error)));
	ipcv_release_image_argument(frame);
	if (iRet)
	{
		Scierror(999, "%s: %s.\r\n", fname, error);
		return iRet;
	}

	return 0;
}
