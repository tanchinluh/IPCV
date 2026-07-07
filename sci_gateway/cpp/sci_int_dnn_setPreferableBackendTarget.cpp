/***********************************************************************
 * IPCV - Scilab Image Processing and Computer Vision toolbox
 ***********************************************************************/

#include "ipcv_gateway_common.h"
#include "ipcv_gateway_image.h"

int sci_int_dnn_setPreferableBackendTarget(char * fname, void* pvApiCtx)
{
	CheckInputArgument(pvApiCtx, 3, 3);
	CheckOutputArgument(pvApiCtx, 0, 1);

	double *handleValue = NULL;
	double *backendValue = NULL;
	double *targetValue = NULL;
	int iRows = 0;
	int iCols = 0;

	GetDouble(1, handleValue, iRows, iCols, pvApiCtx);
	GetDouble(2, backendValue, iRows, iCols, pvApiCtx);
	GetDouble(3, targetValue, iRows, iCols, pvApiCtx);

	char error[1024] = {0};
	int iRet = ipcv_dnn_set_preferable_backend_target(static_cast<int>(round(*handleValue)),
		static_cast<int>(round(*backendValue)), static_cast<int>(round(*targetValue)),
		error, static_cast<int>(sizeof(error)));
	if (iRet)
	{
		Scierror(999, "%s: %s\n", fname, error);
		return iRet;
	}

	iRet = createScalarDouble(pvApiCtx, nbInputArgument(pvApiCtx) + 1, 1.0);
	if (iRet)
	{
		return iRet;
	}
	AssignOutputVariable(pvApiCtx, 1) = nbInputArgument(pvApiCtx) + 1;
	return 0;
}
