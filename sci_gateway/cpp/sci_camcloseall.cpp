/***********************************************************************
 * IPCV - Scilab Image Processing and Computer Vision toolbox
 * Copyright (C) 2017  Tan Chin Luh
***********************************************************************/

#include "ipcv_gateway_common.h"
#include "ipcv_gateway_image.h"

int sci_camcloseall(char *fname, void* pvApiCtx)
{
	CheckInputArgument(pvApiCtx, 0, 0);
	CheckOutputArgument(pvApiCtx, 0, 1);

	ipcv_cam_close_all();
	return 0;
}
