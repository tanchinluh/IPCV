/***********************************************************************
 * IPCV - Scilab Image Processing and Computer Vision toolbox
 * Copyright (C) 2017  Tan Chin Luh
***********************************************************************/

#include "common.h"
#include "ipcv_gateway_image.h"
/************************************************************
* imout = sci_int_imboundingRect(imin, se);
************************************************************/

/* Find best class for the blob (i. e. class with maximal probability) */


int sci_int_imboundingRect(char * fname,void* pvApiCtx)
{
	CheckInputArgument(pvApiCtx, 0, 1);
	CheckOutputArgument(pvApiCtx, 0, 1);

	IpcvDecodedImage image;
	double rect[4] = {0, 0, 0, 0};
	char error[1024] = {0};
	int iRet = ipcv_get_image_argument(pvApiCtx, 1, image);
	if (iRet)
	{
		Scierror(999, "%s: Wrong type for input argument #%d: Image expected.\n", fname, 1);
		return iRet;
	}

	iRet = ipcv_bounding_rect(&image, rect, error, sizeof(error));
	ipcv_release_image_argument(image);
	if (iRet)
	{
		Scierror(999, "%s: %s\n", fname, error);
		return iRet;
	}

	int rows = 4;
	int cols = 1;
	double *rect_data = rect;
	SetDouble(1, rect_data, rows, cols, pvApiCtx);
	return 0;	
}
