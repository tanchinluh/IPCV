/***********************************************************************
 * IPCV - Scilab Image Processing and Computer Vision toolbox
 * Copyright (C) 2017  Tan Chin Luh
***********************************************************************/

#include "ipcv_gateway_common.h"
#include "ipcv_gateway_image.h"

int sci_avilistopened(char * fname, void* pvApiCtx)
{
	CheckInputArgument(pvApiCtx, 0, 0);
	CheckOutputArgument(pvApiCtx, 1, 1);

	IpcvVideoIndexList list;
	ipcv_avi_list_opened(&list);

	SciErr sciErr = createMatrixOfDouble(pvApiCtx, nbInputArgument(pvApiCtx) + 1, list.count, 1, list.indices);
	if (sciErr.iErr)
	{
		printError(&sciErr, 0);
		return sciErr.iErr;
	}

	AssignOutputVariable(pvApiCtx, 1) = nbInputArgument(pvApiCtx) + 1;
	return 0;
}
