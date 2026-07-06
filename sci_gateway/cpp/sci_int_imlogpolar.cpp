/***********************************************************************
 *
 * IPCV - Scilab Image Processing and Computer Vision toolbox
 * Copyright (C) 2017  Tan Chin Luh
 *
 ***********************************************************************/

#include "common.h"
#include "ipcv_gateway_image.h"

int sci_int_imlogpolar(char * fname,void* pvApiCtx)
{
	CheckInputArgument(pvApiCtx, 2, 2);
	CheckOutputArgument(pvApiCtx, 1, 1);

	IpcvDecodedImage image;
	IpcvDecodedImage output;
	memset(&output, 0, sizeof(output));

	int iRet = ipcv_get_image_argument(pvApiCtx, 1, image);
	if (iRet)
	{
		Scierror(999, "%s: Wrong type for input argument #%d: Image expected.\n", fname, 1);
		return iRet;
	}

	double *scale = NULL;
	int iRows = 0;
	int iCols = 0;
	GetDouble(2, scale, iRows, iCols, pvApiCtx);

	iRet = ipcv_log_polar(&image, *scale, &output);
	ipcv_release_image_argument(image);
	if (iRet)
	{
		Scierror(999, "%s: %s\n", fname, output.error);
		ipcv_free_decoded_image(&output);
		return iRet;
	}

	iRet = ipcv_set_image_argument(pvApiCtx, 1, output);
	ipcv_free_decoded_image(&output);
	return iRet;
}
