/***********************************************************************
 * IPCV - Scilab Image Processing and Computer Vision toolbox
 * Copyright (C) 2017  Tan Chin Luh
***********************************************************************/

#include "ipcv_gateway_common.h"
#include "ipcv_gateway_image.h"

int sci_int_immatch_BruteForce(char * fname,void* pvApiCtx)
{

	CheckInputArgument(pvApiCtx, 3, 3);
	CheckOutputArgument(pvApiCtx, 0, 1);

	IpcvDecodedImage left;
	IpcvDecodedImage right;
	IpcvMatchMatrix matches;
	memset(&matches, 0, sizeof(matches));

	int iRet = ipcv_get_image_argument(pvApiCtx, 1, left);
	if (iRet)
	{
		Scierror(999, "%s: Wrong type for input argument #%d: Descriptor matrix expected.\n", fname, 1);
		return iRet;
	}

	iRet = ipcv_get_image_argument(pvApiCtx, 2, right);
	if (iRet)
	{
		ipcv_release_image_argument(left);
		Scierror(999, "%s: Wrong type for input argument #%d: Descriptor matrix expected.\n", fname, 2);
		return iRet;
	}

	double *normData = NULL;
	int normRows = 0;
	int normCols = 0;
	GetDouble(3, normData, normRows, normCols, pvApiCtx);
	int normType = int(*normData);

	iRet = ipcv_match_bruteforce(&left, &right, normType, &matches);
	ipcv_release_image_argument(left);
	ipcv_release_image_argument(right);
	if (iRet)
	{
		Scierror(999, "%s: %s\n", fname, matches.error);
		ipcv_free_match_matrix(&matches);
		return iRet;
	}

	SciErr sciErr;
	const int outVar = nbInputArgument(pvApiCtx) + 1;
	sciErr = createMatrixOfDouble(pvApiCtx, outVar, matches.rows, matches.cols, matches.data);
	if (sciErr.iErr)
	{
		printError(&sciErr, 0);
		ipcv_free_match_matrix(&matches);
		return sciErr.iErr;
	}

	AssignOutputVariable(pvApiCtx, 1) = outVar;
	ipcv_free_match_matrix(&matches);
	return 0;
}
