/***********************************************************************
 * IPCV - Scilab Image Processing and Computer Vision toolbox
 ***********************************************************************/

#include "ipcv_gateway_common.h"
#include "ipcv_gateway_image.h"

int sci_int_dnn_getFLOPS(char * fname, void* pvApiCtx)
{
	CheckInputArgument(pvApiCtx, 3, 3);
	CheckOutputArgument(pvApiCtx, 0, 1);

	double *handleValue = NULL;
	double *inputSize = NULL;
	double *channelsValue = NULL;
	int iRows = 0;
	int iCols = 0;

	GetDouble(1, handleValue, iRows, iCols, pvApiCtx);
	GetDouble(2, inputSize, iRows, iCols, pvApiCtx);
	GetDouble(3, channelsValue, iRows, iCols, pvApiCtx);

	double flops = 0.0;
	char error[1024] = {0};
	int iRet = ipcv_dnn_get_flops(static_cast<int>(round(*handleValue)),
		static_cast<int>(inputSize[0]), static_cast<int>(inputSize[1]),
		static_cast<int>(round(*channelsValue)), &flops, error, static_cast<int>(sizeof(error)));
	if (iRet)
	{
		Scierror(999, "%s: %s\n", fname, error);
		return iRet;
	}

	iRet = createScalarDouble(pvApiCtx, nbInputArgument(pvApiCtx) + 1, flops);
	if (iRet)
	{
		return iRet;
	}
	AssignOutputVariable(pvApiCtx, 1) = nbInputArgument(pvApiCtx) + 1;
	return 0;
}
