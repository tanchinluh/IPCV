/***********************************************************************
 *
 * IPCV - Scilab Image Processing and Computer Vision toolbox
 * Copyright (C) 2017  Tan Chin Luh
 *
***********************************************************************/

#include "common.h"
#include "ipcv_gateway_image.h"

int sci_int_imhough(char * fname,void* pvApiCtx)
{
	CheckInputArgument(pvApiCtx, 1, 1);
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

	iRet = ipcv_hough_lines_overlay(&image, &output);
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
