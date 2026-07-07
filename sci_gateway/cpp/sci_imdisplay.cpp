/***********************************************************************
 *
 * IPCV - Scilab Image Processing and Computer Vision toolbox
 * Copyright (C) 2017  Tan Chin Luh
 *
***********************************************************************/

#include "common.h"
#include "ipcv_gateway_image.h"

int sci_imdisplay(char * fname, void* pvApiCtx)
{
	CheckInputArgument(pvApiCtx, 1, 2);
	CheckOutputArgument(pvApiCtx, 0, 1);

	IpcvDecodedImage image;
	int iRet = ipcv_get_image_argument(pvApiCtx, 1, image);
	if (iRet)
	{
		Scierror(999, "%s: Wrong type for input argument #%d: Image expected.\n", fname, 1);
		return iRet;
	}

	char *windowName = NULL;
	if (nbInputArgument(pvApiCtx) == 2)
	{
		GetString(2, windowName, pvApiCtx);
	}
	else
	{
		windowName = (char *)"Display Window";
	}

	double status = 0;
	char error[1024] = {0};
	iRet = ipcv_display_image(&image, windowName, &status, error, static_cast<int>(sizeof(error)));
	ipcv_release_image_argument(image);
	if (iRet)
	{
		Scierror(999, "%s: %s.\r\n", fname, error);
		return iRet;
	}

	iRet = createScalarDouble(pvApiCtx, nbInputArgument(pvApiCtx) + 1, status);
	if (iRet)
	{
		return iRet;
	}

	AssignOutputVariable(pvApiCtx, 1) = nbInputArgument(pvApiCtx) + 1;
	return 0;
}
