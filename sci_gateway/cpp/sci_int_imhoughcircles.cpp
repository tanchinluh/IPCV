/***********************************************************************
 * IPCV - Scilab Image Processing and Computer Vision toolbox
 * Copyright (C) 2017  Tan Chin Luh
***********************************************************************/

#include "common.h"
#include "ipcv_gateway_image.h"

int sci_int_imhoughcircles(char * fname,void* pvApiCtx)
{
	CheckInputArgument(pvApiCtx, 1, 1);
	CheckOutputArgument(pvApiCtx, 0, 1);

	IpcvDecodedImage image;
	IpcvCircleMatrix circles;
	memset(&circles, 0, sizeof(circles));

	int iRet = ipcv_get_image_argument(pvApiCtx, 1, image);
	if (iRet)
	{
		Scierror(999, "%s: Wrong type for input argument #%d: Image expected.\n", fname, 1);
		return iRet;
	}

	iRet = ipcv_hough_circles(&image, &circles);
	ipcv_release_image_argument(image);
	if (iRet)
	{
		Scierror(999, "%s: %s\n", fname, circles.error);
		ipcv_free_circle_matrix(&circles);
		return iRet;
	}

	const int outVar = nbInputArgument(pvApiCtx) + 1;
	SciErr sciErr = createMatrixOfDouble(pvApiCtx, outVar, circles.rows, circles.cols, circles.data);
	if (sciErr.iErr)
	{
		printError(&sciErr, 0);
		ipcv_free_circle_matrix(&circles);
		return sciErr.iErr;
	}

	AssignOutputVariable(pvApiCtx, 1) = outVar;
	ipcv_free_circle_matrix(&circles);
	return 0;
}
