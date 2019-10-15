/***********************************************************************
 * IPCV - Scilab Image Processing and Computer Vision toolbox
 * Copyright (C) 2017  Tan Chin Luh
 ***********************************************************************/

#include "common.h"

/**********************************************************************
* This function is used to close the windows created using highgui
* imdestroy("name");
**********************************************************************/
int sci_imdestroy(char * fname,void* pvApiCtx)
{

	CheckInputArgument(pvApiCtx, 1, 1);
	CheckOutputArgument(pvApiCtx, 0, 1);

	char *pstName = NULL;
	GetString(1, pstName,pvApiCtx);

	destroyWindow(pstName);

	return 0;
}
