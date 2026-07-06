/***********************************************************************
 * IPCV - Scilab Image Processing and Computer Vision toolbox
 * Copyright (C) 2017  Tan Chin Luh
***********************************************************************/

#include "common.h"
#include "ipcv_gateway_image.h"

int sci_int_tracker_update(char * fname, void* pvApiCtx)
{
	CheckInputArgument(pvApiCtx, 2, 2);
	CheckOutputArgument(pvApiCtx, 0, 1);

	double *trackerIdValue = NULL;
	int iRows = 0;
	int iCols = 0;
	GetDouble(1, trackerIdValue, iRows, iCols, pvApiCtx);

	IpcvDecodedImage image;
	IpcvRectMatrix bbox;
	memset(&bbox, 0, sizeof(bbox));

	int iRet = ipcv_get_image_argument(pvApiCtx, 2, image);
	if (iRet)
	{
		Scierror(999, "%s: Wrong type for input argument #%d: Image expected.\n", fname, 2);
		return iRet;
	}

	iRet = ipcv_tracker_update(static_cast<int>(*trackerIdValue), &image, &bbox);
	ipcv_release_image_argument(image);
	if (iRet)
	{
		Scierror(999, "%s: %s\n", fname, bbox.error);
		ipcv_free_rect_matrix(&bbox);
		return iRet;
	}

	const int outVar = nbInputArgument(pvApiCtx) + 1;
	SciErr sciErr = createMatrixOfDouble(pvApiCtx, outVar, bbox.rows, bbox.cols, bbox.data);
	if (sciErr.iErr)
	{
		printError(&sciErr, 0);
		ipcv_free_rect_matrix(&bbox);
		return sciErr.iErr;
	}

	AssignOutputVariable(pvApiCtx, 1) = outVar;
	ipcv_free_rect_matrix(&bbox);
	return 0;
}
