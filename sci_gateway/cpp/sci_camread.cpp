/***********************************************************************
 * IPCV - Scilab Image Processing and Computer Vision toolbox
 * Copyright (C) 2017  Tan Chin Luh
***********************************************************************/

#include "ipcv_gateway_common.h"
#include "ipcv_gateway_image.h"

int sci_camread(char * fname, void* pvApiCtx)
{
	CheckInputArgument(pvApiCtx, 1, 1);
	CheckOutputArgument(pvApiCtx, 0, 1);

	double *handleValue = NULL;
	int iRows = 0;
	int iCols = 0;
	GetDouble(1, handleValue, iRows, iCols, pvApiCtx);

	IpcvDecodedImage frame;
	int iRet = ipcv_cam_read(static_cast<int>(*handleValue), &frame);
	if (iRet)
	{
		Scierror(999, "%s: %s.\r\n", fname, frame.error);
		ipcv_free_decoded_image(&frame);
		return iRet;
	}

	iRet = ipcv_set_image_argument(pvApiCtx, 1, frame);
	ipcv_free_decoded_image(&frame);
	return iRet;
}
