/***********************************************************************
 * IPCV - Scilab Image Processing and Computer Vision toolbox
 * Copyright (C) 2017  Tan Chin Luh
 ***********************************************************************/

#include "ipcv_gateway_common.h"
#include "ipcv_display_utils.h"

/**********************************************************************
* This function is used to close the windows created using highgui
* imdestroyall();
**********************************************************************/
int sci_imdestroyall(char * fname,void* pvApiCtx)
{
	CheckInputArgument(pvApiCtx, 0, 0);
	CheckOutputArgument(pvApiCtx, 0, 1);

	char error[1024] = {0};
	int status = ipcv_close_display_windows(NULL, error, sizeof(error));
	if (status != 0)
	{
		Scierror(999, "%s: %s\n", fname, error);
	}
	return status;
}
