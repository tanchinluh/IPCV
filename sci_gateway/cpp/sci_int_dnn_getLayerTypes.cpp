/***********************************************************************
 * IPCV - Scilab Image Processing and Computer Vision toolbox
 ***********************************************************************/

#include "ipcv_gateway_common.h"
#include "ipcv_gateway_image.h"

int sci_int_dnn_getLayerTypes(char * fname, void* pvApiCtx)
{
	CheckInputArgument(pvApiCtx, 1, 1);
	CheckOutputArgument(pvApiCtx, 0, 1);

	double *handleValue = NULL;
	int iRows = 0;
	int iCols = 0;
	GetDouble(1, handleValue, iRows, iCols, pvApiCtx);

	IpcvStringList types;
	memset(&types, 0, sizeof(types));
	int iRet = ipcv_dnn_get_layer_types(static_cast<int>(round(*handleValue)), &types);
	if (iRet)
	{
		Scierror(999, "%s: %s\n", fname, types.error);
		ipcv_free_string_list(&types);
		return iRet;
	}

	const int outVar = nbInputArgument(pvApiCtx) + 1;
	SciErr sciErr = createMatrixOfString(pvApiCtx, outVar, types.count, 1, types.items);
	if (sciErr.iErr)
	{
		printError(&sciErr, 0);
		ipcv_free_string_list(&types);
		return sciErr.iErr;
	}

	AssignOutputVariable(pvApiCtx, 1) = outVar;
	ipcv_free_string_list(&types);
	return 0;
}
