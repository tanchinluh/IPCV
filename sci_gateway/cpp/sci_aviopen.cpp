/***********************************************************************
 * IPCV - Scilab Image Processing and Computer Vision toolbox
 * Copyright (C) 2017  Tan Chin Luh
***********************************************************************/

#include "ipcv_gateway_common.h"
#include "ipcv_gateway_image.h"

int sci_aviopen(char *fname, void* pvApiCtx)
{
	CheckInputArgument(pvApiCtx, 1, 1);
	CheckOutputArgument(pvApiCtx, 1, 1);

	char *filename = NULL;
	GetString(1, filename, pvApiCtx);

	int handle = -1;
	char error[1024] = {0};
	int iRet = ipcv_avi_open(filename, &handle, error, static_cast<int>(sizeof(error)));
	if (iRet)
	{
		Scierror(999, "%s: %s: %s.\r\n", fname, error, filename);
		return iRet;
	}

	iRet = createScalarDouble(pvApiCtx, nbInputArgument(pvApiCtx) + 1, static_cast<double>(handle));
	if (iRet)
	{
		return iRet;
	}

	AssignOutputVariable(pvApiCtx, 1) = nbInputArgument(pvApiCtx) + 1;
	return 0;
}
