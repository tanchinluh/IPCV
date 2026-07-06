/***********************************************************************
 * IPCV - Scilab Image Processing and Computer Vision toolbox
 * Copyright (C) 2017  Tan Chin Luh
***********************************************************************/

#include "common.h"
#include "ipcv_gateway_image.h"

int sci_avicloseall(char *fname, void* pvApiCtx)
{
	CheckInputArgument(pvApiCtx, 0, 0);
	CheckOutputArgument(pvApiCtx, 0, 1);

	ipcv_avi_close_all();
	return 0;
}
