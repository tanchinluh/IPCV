/*****************************************************************************
* IPCV - Scilab Image Processing and Computer Vision toolbox
* Copyright (C) 2017  Tan Chin Luh
*****************************************************************************/

#include "common.h"
#include "ipcv_gateway_image.h"

int sci_int_detectobjects(char * fname, void* pvApiCtx)
{
	CheckInputArgument(pvApiCtx, 6, 6);
	CheckOutputArgument(pvApiCtx, 0, 1);

	IpcvDecodedImage image;
	IpcvRectMatrix objects;
	memset(&objects, 0, sizeof(objects));

	int iRet = ipcv_get_image_argument(pvApiCtx, 1, image);
	if (iRet)
	{
		Scierror(999, "%s: Wrong type for input argument #%d: Image expected.\n", fname, 1);
		return iRet;
	}

	char *cascadeFilename = NULL;
	GetString(2, cascadeFilename, pvApiCtx);

	double *scaleFactor = NULL;
	double *minNeighbors = NULL;
	double *minSize = NULL;
	double *maxSize = NULL;
	int iRows = 0;
	int iCols = 0;

	GetDouble(3, scaleFactor, iRows, iCols, pvApiCtx);
	GetDouble(4, minNeighbors, iRows, iCols, pvApiCtx);
	GetDouble(5, minSize, iRows, iCols, pvApiCtx);
	GetDouble(6, maxSize, iRows, iCols, pvApiCtx);

	iRet = ipcv_detect_objects(&image, cascadeFilename, *scaleFactor, static_cast<int>(*minNeighbors), minSize, maxSize, &objects);
	ipcv_release_image_argument(image);
	if (iRet)
	{
		Scierror(999, "%s: %s\n", fname, objects.error);
		ipcv_free_rect_matrix(&objects);
		return iRet;
	}

	const int outVar = nbInputArgument(pvApiCtx) + 1;
	SciErr sciErr = createMatrixOfDouble(pvApiCtx, outVar, objects.rows, objects.cols, objects.data);
	if (sciErr.iErr)
	{
		printError(&sciErr, 0);
		ipcv_free_rect_matrix(&objects);
		return sciErr.iErr;
	}

	AssignOutputVariable(pvApiCtx, 1) = outVar;
	ipcv_free_rect_matrix(&objects);
	return 0;
}
