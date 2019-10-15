/***********************************************************************
 * IPCV - Scilab Image Processing and Computer Vision toolbox
 * Copyright (C) 2017  Tan Chin Luh
***********************************************************************/

#include "common.h"

/************************************************************
* sci_int_dnn_list(char * fname,void* pvApiCtx)
************************************************************/


int sci_int_dnn_list(char * fname,void* pvApiCtx)
{
	int One = 1;
	int i;
	SciErr sciErr;
	int count = 0;
	int offset = 0;

	double dIndices[MAX_DL_NUM];
	double * dIdx = dIndices;
	

	CheckInputArgument(pvApiCtx, 0, 0);
	CheckOutputArgument(pvApiCtx, 1, 1);

	for (i = 0; i < MAX_DL_NUM; i++)
	{
		if (!(DeepNet[i].net.empty()))
		{
			dIndices[count] = i + 1;
			count++;
		}
	}

	// ToDo : To be replaced with cleaner SetDouble.
	sciErr = createMatrixOfDouble(pvApiCtx, nbInputArgument(pvApiCtx) + 1, count, One, dIdx);
	AssignOutputVariable(pvApiCtx, 1) = nbInputArgument(pvApiCtx) + 1;

	return 0;
}
