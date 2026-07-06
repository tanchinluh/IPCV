/***********************************************************************
 * IPCV - Scilab Image Processing and Computer Vision toolbox
 * Copyright (C) 2017  Tan Chin Luh
***********************************************************************/

#include "common.h"
#include "ipcv_gateway_image.h"

int sci_aviinfo(char *fname, void* pvApiCtx)
{
	CheckInputArgument(pvApiCtx, 1, 1);
	CheckOutputArgument(pvApiCtx, 0, 4);

	char *filename = NULL;
	GetString(1, filename, pvApiCtx);

	IpcvVideoInfo info;
	int iRet = ipcv_avi_info(filename, &info);
	if (iRet)
	{
		Scierror(999, "%s: %s: %s.\r\n", fname, info.error, filename);
		return iRet;
	}

	iRet = createScalarDouble(pvApiCtx, nbInputArgument(pvApiCtx) + 1, info.frames);
	if (iRet) { return iRet; }
	iRet = createScalarDouble(pvApiCtx, nbInputArgument(pvApiCtx) + 2, info.width);
	if (iRet) { return iRet; }
	iRet = createScalarDouble(pvApiCtx, nbInputArgument(pvApiCtx) + 3, info.height);
	if (iRet) { return iRet; }
	iRet = createScalarDouble(pvApiCtx, nbInputArgument(pvApiCtx) + 4, info.fps);
	if (iRet) { return iRet; }

	AssignOutputVariable(pvApiCtx, 1) = nbInputArgument(pvApiCtx) + 1;
	AssignOutputVariable(pvApiCtx, 2) = nbInputArgument(pvApiCtx) + 2;
	AssignOutputVariable(pvApiCtx, 3) = nbInputArgument(pvApiCtx) + 3;
	AssignOutputVariable(pvApiCtx, 4) = nbInputArgument(pvApiCtx) + 4;
	return 0;
}
