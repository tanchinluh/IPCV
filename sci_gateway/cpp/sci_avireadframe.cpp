/***********************************************************************
 * IPCV - Scilab Image Processing and Computer Vision toolbox
 * Copyright (C) 2017  Tan Chin Luh
***********************************************************************/

#include "ipcv_gateway_common.h"
#include "ipcv_gateway_image.h"

int sci_avireadframe(char * fname, void* pvApiCtx)
{
	CheckInputArgument(pvApiCtx, 1, 2);
	CheckOutputArgument(pvApiCtx, 0, 1);

	double *handleValue = NULL;
	double *frameValue = NULL;
	int iRows = 0;
	int iCols = 0;
	GetDouble(1, handleValue, iRows, iCols, pvApiCtx);

	int hasFrameIndex = 0;
	int frameIndex = -1;
	if (nbInputArgument(pvApiCtx) == 2)
	{
		GetDouble(2, frameValue, iRows, iCols, pvApiCtx);
		hasFrameIndex = 1;
		frameIndex = static_cast<int>(*frameValue);
	}

	IpcvDecodedImage frame;
	int iRet = ipcv_avi_read_frame(static_cast<int>(*handleValue), frameIndex, hasFrameIndex, &frame);
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
