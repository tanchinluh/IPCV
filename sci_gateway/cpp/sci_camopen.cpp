/***********************************************************************
 * IPCV - Scilab Image Processing and Computer Vision toolbox
 * Copyright (C) 2017  Tan Chin Luh
***********************************************************************/

#include "common.h"
#include "ipcv_gateway_image.h"

int sci_camopen(char *fname, void* pvApiCtx)
{
	CheckInputArgument(pvApiCtx, 1, 2);
	CheckOutputArgument(pvApiCtx, 1, 1);

	double *cameraValue = NULL;
	double *sizeValue = NULL;
	int iRows = 0;
	int iCols = 0;
	GetDouble(1, cameraValue, iRows, iCols, pvApiCtx);

	int requestedSize[2] = {0, 0};
	int hasSize = 0;
	if (nbInputArgument(pvApiCtx) == 2)
	{
		GetDouble(2, sizeValue, iRows, iCols, pvApiCtx);
		requestedSize[0] = static_cast<int>(sizeValue[0]);
		requestedSize[1] = static_cast<int>(sizeValue[1]);
		hasSize = 1;
	}

	int handle = -1;
	double width = 0;
	double height = 0;
	char error[1024] = {0};
	int iRet = ipcv_cam_open(static_cast<int>(*cameraValue), requestedSize, hasSize, &handle, &width, &height, error, static_cast<int>(sizeof(error)));
	if (iRet)
	{
		Scierror(999, "%s: %s.\r\n", fname, error);
		return iRet;
	}

	sciprint("Camera %i opened with folllowing resolution\n", handle);
	sciprint("Size : [%.0f,%.0f]\n", width, height);

	iRet = createScalarDouble(pvApiCtx, nbInputArgument(pvApiCtx) + 1, static_cast<double>(handle));
	if (iRet)
	{
		return iRet;
	}

	AssignOutputVariable(pvApiCtx, 1) = nbInputArgument(pvApiCtx) + 1;
	return 0;
}
