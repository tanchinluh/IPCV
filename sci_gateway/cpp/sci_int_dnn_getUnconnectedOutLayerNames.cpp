/***********************************************************************
 * IPCV - Scilab Image Processing and Computer Vision toolbox
 ***********************************************************************/

#include "ipcv_gateway_common.h"
#include "ipcv_gateway_image.h"

int sci_int_dnn_getUnconnectedOutLayerNames(char * fname, void* pvApiCtx)
{
	CheckInputArgument(pvApiCtx, 1, 1);
	CheckOutputArgument(pvApiCtx, 0, 1);

	double *handleValue = NULL;
	int iRows = 0;
	int iCols = 0;
	GetDouble(1, handleValue, iRows, iCols, pvApiCtx);

	IpcvStringList names;
	memset(&names, 0, sizeof(names));
	int iRet = ipcv_dnn_get_unconnected_output_names(static_cast<int>(round(*handleValue)), &names);
	if (iRet)
	{
		Scierror(999, "%s: %s\n", fname, names.error);
		ipcv_free_string_list(&names);
		return iRet;
	}

	const int outVar = nbInputArgument(pvApiCtx) + 1;
	SciErr sciErr = createMatrixOfString(pvApiCtx, outVar, names.count, 1, names.items);
	if (sciErr.iErr)
	{
		printError(&sciErr, 0);
		ipcv_free_string_list(&names);
		return sciErr.iErr;
	}

	AssignOutputVariable(pvApiCtx, 1) = outVar;
	ipcv_free_string_list(&names);
	return 0;
}
