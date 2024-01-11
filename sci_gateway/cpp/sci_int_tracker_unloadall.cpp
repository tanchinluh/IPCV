/***********************************************************************
 * IPCV - Scilab Image Processing and Computer Vision toolbox
 * Copyright (C) 2017  Tan Chin Luh
***********************************************************************/

#include "common.h"

/************************************************************
* sci_int_tracker_unloadall(char * fname,void* pvApiCtx)
************************************************************/


int sci_int_tracker_unloadall(char * fname,void* pvApiCtx)
{
	int i;
	//((ObjTrack[nCurrFile].trackobj.empty()))
	CheckInputArgument(pvApiCtx, 0, 0);
	CheckOutputArgument(pvApiCtx, 0, 1);

	for (i = 0; i < MAX_TRACK_NUM; i++)
	{
		if (!(ObjTrack[i].trackobj.empty())) //OpenedVideoCapture[nCurrFile].cap
		{
			//~ObjTrack[i].trackobj;
			ObjTrack[i].trackobj = Ptr<cv::legacy::Tracker>();

			//DeepNet[i].net = dnn::Net();
			//~DeepNet[i].net;

		}
	}

	return 0;

	
}

