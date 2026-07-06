/***********************************************************************
 * IPCV - Scilab Image Processing and Computer Vision toolbox
 * Copyright (C) 2017  Tan Chin Luh
***********************************************************************/

#include "common.h"
#include "ipcv_gateway_image.h"

int sci_avifile(char *fname, void* pvApiCtx)
{
	CheckInputArgument(pvApiCtx, 2, 4);
	CheckOutputArgument(pvApiCtx, 1, 1);

	char *filename = NULL;
	GetString(1, filename, pvApiCtx);

	double *dims = NULL;
	double *fpsValue = NULL;
	double *codecValue = NULL;
	int iRows = 0;
	int iCols = 0;
	GetDouble(2, dims, iRows, iCols, pvApiCtx);

	const int width = static_cast<int>(dims[0]);
	const int height = static_cast<int>(dims[1]);
	int fps = 25;
	if (nbInputArgument(pvApiCtx) >= 3)
	{
		GetDouble(3, fpsValue, iRows, iCols, pvApiCtx);
		fps = static_cast<int>(*fpsValue);
	}

	int handle = -1;
	char error[1024] = {0};
	int iRet = 0;

	if (nbInputArgument(pvApiCtx) == 4)
	{
		int* piAddr = NULL;
		SciErr sciErr = getVarAddressFromPosition(pvApiCtx, 4, &piAddr);
		if (sciErr.iErr)
		{
			printError(&sciErr, 0);
			return sciErr.iErr;
		}

		if (isStringType(pvApiCtx, piAddr))
		{
			char *fourcc = NULL;
			GetString(4, fourcc, pvApiCtx);
			iRet = ipcv_avi_create_fourcc(filename, width, height, fps, fourcc, &handle, error, static_cast<int>(sizeof(error)));
		}
		else if (isDoubleType(pvApiCtx, piAddr))
		{
			GetDouble(4, codecValue, iRows, iCols, pvApiCtx);
			iRet = ipcv_avi_create(filename, width, height, fps, static_cast<int>(*codecValue), &handle, error, static_cast<int>(sizeof(error)));
		}
		else
		{
			Scierror(999, "%s: Input argument #%d must be a fourcc string or numeric codec.\r\n", fname, 4);
			return -1;
		}
	}
	else
	{
		iRet = ipcv_avi_create_fourcc(filename, width, height, fps, "MJPG", &handle, error, static_cast<int>(sizeof(error)));
	}

	if (iRet)
	{
		Scierror(999, "%s: %s: %s.\r\n", fname, error, filename);
		return iRet;
	}

	sciprint("Following file has been created for saving video.\n");
	sciprint("Filename : %s\n", filename);
	sciprint("Size : [%i,%i]\n", width, height);
	sciprint("FPS : %i\n", fps);

	iRet = createScalarDouble(pvApiCtx, nbInputArgument(pvApiCtx) + 1, static_cast<double>(handle));
	if (iRet)
	{
		return iRet;
	}

	AssignOutputVariable(pvApiCtx, 1) = nbInputArgument(pvApiCtx) + 1;
	return 0;
}
