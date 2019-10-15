/***********************************************************************
 * IPCV - Scilab Image Processing and Computer Vision toolbox
 * Copyright (C) 2017  Tan Chin Luh
 ***********************************************************************/

#include "common.h"

/**********************************************************************
* This function is used to close the windows created using highgui
* imdestroyall();
**********************************************************************/
int sci_imdestroyall(char * fname,void* pvApiCtx)
{
	CheckInputArgument(pvApiCtx, 0, 0);
	CheckOutputArgument(pvApiCtx, 0, 1);
	

	destroyAllWindows();
	
	return 0;
}
