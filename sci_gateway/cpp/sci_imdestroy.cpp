/***********************************************************************
 * IPCV - Scilab Image Processing and Computer Vision toolbox
 * Copyright (C) 2017  Tan Chin Luh
 ***********************************************************************/

#include "ipcv_gateway_common.h"
#include "ipcv_display_utils.h"

/**********************************************************************
* This function is used to close the windows created using highgui
* imdestroy("name");
**********************************************************************/
int sci_imdestroy(char * fname,void* pvApiCtx)
{

	CheckInputArgument(pvApiCtx, 1, 1);
	CheckOutputArgument(pvApiCtx, 0, 1);

	char *pstName = NULL;
	if (GetString(1, pstName, pvApiCtx) != 0)
	{
		Scierror(999, "%s: A scalar window name is expected.\n", fname);
		return -1;
	}

	char error[1024] = {0};
	int status = ipcv_close_display_windows(pstName, error, sizeof(error));
	freeAllocatedSingleString(pstName);
	if (status != 0)
	{
		Scierror(999, "%s: %s\n", fname, error);
	}
	return status;
}
