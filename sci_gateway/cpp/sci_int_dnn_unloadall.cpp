/***********************************************************************
 * IPCV - Scilab Image Processing and Computer Vision toolbox
 * Copyright (C) 2017  Tan Chin Luh
***********************************************************************/

#include "common.h"

/************************************************************
* sci_int_dnn_unloadall(char * fname,void* pvApiCtx)
************************************************************/


int sci_int_dnn_unloadall(char * fname,void* pvApiCtx)
{
	int i;

	CheckInputArgument(pvApiCtx, 0, 0);
	CheckOutputArgument(pvApiCtx, 0, 1);

	for (i = 0; i < MAX_DL_NUM; i++)
	{
		if (!(DeepNet[i].net.empty())) //OpenedVideoCapture[nCurrFile].cap
		{
			DeepNet[i].net = dnn::Net();
			//~DeepNet[i].net;

		}
	}

	return 0;

	
}
