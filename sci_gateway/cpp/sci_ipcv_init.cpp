/***********************************************************************
 * SIVP - Scilab Image and Video Processing toolbox
 * Copyright (C) 2005  Vincent Etienne
 * Copyright (C) 2012 - DIGITEO - Allan CORNET
 *
 * IPCV - Scilab Image Processing and Computer Vision toolbox
 * Copyright (C) 2017  Tan Chin Luh
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
 ***********************************************************************/

#include "common.h"
OpenedAviFile OpenedAvi[MAX_AVI_FILE_NUM];
//OpenedVideoCamCapture OpenedVideoCapture[MAX_AVI_FILE_NUM];
OpenedCamCapture OpenedCam[MAX_AVI_FILE_NUM];
DeepNetwork DeepNet[MAX_DL_NUM];
ObjectTracker ObjTrack[MAX_TRACK_NUM];

//extern "C" 
//{
//int sci_ipcv_init(char * fname,void* pvApiCtx);
//}

/*--------------------------------------------------------------------------*/
char sIPCV_PATH[MAX_FILENAME_LENGTH];
/*--------------------------------------------------------------------------*/
/***************************************************
* this function should be called when IPCV is loaded
***************************************************/
int sci_ipcv_init(char * fname,void* pvApiCtx)
{
	SciErr sciErr;
	int *piAddressVarOne = NULL;
	char *pStr = NULL;

	CheckRhs(1, 1);
	CheckLhs(0, 1);

	sciErr = getVarAddressFromPosition(pvApiCtx, 1, &piAddressVarOne);
	if(sciErr.iErr)
	{
		printError(&sciErr, 0);
		Scierror(999, ("%s: Can not read input argument #%d.\n"), fname, 1);
		return 0;
	}

	if (!isStringType(pvApiCtx, piAddressVarOne))
	{
		Scierror(999,("%s: Wrong type for input argument #%d: A matrix of string expected.\n"), fname, 1);
		return 0;
	}

	if (!isScalar(pvApiCtx, piAddressVarOne))
	{
		Scierror(999,("%s: Wrong size for input argument #%d.\n"), fname, 1);
		return 0;
	}

	//get the directory where IPCV is intalled
	if (getAllocatedSingleString(pvApiCtx, piAddressVarOne, &pStr) != 0)
	{
		Scierror(999, ("%s: No more memory.\n"), fname);
		return 0;
	}

	if (pStr)
	{
		size_t len = strlen(pStr);
		strncpy(sIPCV_PATH, pStr, MAX_FILENAME_LENGTH);
		if (len > 0)
		{
			sIPCV_PATH[strlen(pStr)] = 0;
		}
		freeAllocatedSingleString(pStr);
		pStr = NULL;
	}

	//cvSetErrMode(CV_ErrModeParent);
	//memset(OpenedAviCap, 0, sizeof(OpenedAvifileCap));
	//memset(OpenedCam, 0, sizeof(OpenedCamCapture));
	//memset(OpenedVideoCapture, 0, sizeof(OpenedVideoCamCapture));
	return 0;

}
/*--------------------------------------------------------------------------*/

