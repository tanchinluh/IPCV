/***********************************************************************
*  Copyright (C) Trity Technologies - 2012 -
* http://www.gnu.org/licenses/gpl-2.0.txt
***********************************************************************/

#include "common.h"
#include "ipcv_gateway_image.h"

int sci_iminspect(char * fname, void* pvApiCtx)
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
		windowName = (char *)"Inspect Window";
	}

	char error[1024] = {0};
	iRet = ipcv_inspect_image(&image, windowName, error, static_cast<int>(sizeof(error)));
	ipcv_release_image_argument(image);
	if (iRet)
	{
		Scierror(999, "%s: %s.\r\n", fname, error);
		return iRet;
	}

	return 0;
}
