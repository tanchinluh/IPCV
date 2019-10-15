/***********************************************************************
 * SIVP - Scilab Image and Video Processing toolbox
 * Copyright (C) 2005,2010  Shiqi Yu
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
/***********************************************************************
 *  Copyright (C) Trity Technologies - 2012-2013 -
 * http://www.gnu.org/licenses/gpl-2.0.txt
 ***********************************************************************/
#include "common.h"

int sci_camopen(char *fname,void* pvApiCtx)
{
	int mL1, nL1;
	int mR, nR, lR;
	int nCurrFile = 0;
	int *pret = &nCurrFile;
	int mR3, nR3, lR3;
	int szd[] = {640,480};
	int *sz = &szd[0];
	unsigned char ucData = 0;
	int nCamIdx = -1;
	int iRet        = 0;
	int* piAddr     = NULL;
	double dblReal	= 0;
	double *out = NULL;
	int iRows			= 0;
	int iCols			= 0;

	CheckInputArgument(pvApiCtx, 1, 2);
	CheckOutputArgument(pvApiCtx, 1, 1);

	// Get Camera ID, -1 for auto select
	GetDouble(1,out,iRows,iCols,pvApiCtx);
	nCamIdx = round(*out);


	// Check how many camera already opened, and continue after the last opened number
	for (nCurrFile = 0; nCurrFile < MAX_AVI_FILE_NUM; nCurrFile++)
	{
		if (!(OpenedCam[nCurrFile].cap.isOpened()))
			break;
	}

	// It should not more than defined number of camera/avifile open
	if (nCurrFile == MAX_AVI_FILE_NUM)
	{
		Scierror(999, "%s: Too many cameras opened. Use camclose or camcloseall to close some cameras.\r\n", fname);
		return -1;
	}

	OpenedCam[nCurrFile].cap = VideoCapture(nCamIdx);


	// Check whether the camera is opened
	if (!OpenedCam[nCurrFile].cap.isOpened())
	{
		Scierror(999, "%s, Can not open the camera.\r\n", fname);
		return -1;
	}


	// If any second arg passed in, set the frame size
	if (Rhs == 2)
	{
		GetDouble(2, out, iRows, iCols, pvApiCtx);
		int nWidth = int(*out);
		int nHeight = int(*(out + 1));
		OpenedCam[nCurrFile].cap.set(CAP_PROP_FRAME_WIDTH, nWidth);
		OpenedCam[nCurrFile].cap.set(CAP_PROP_FRAME_HEIGHT, nHeight);
		//sciprint("Size : [%i\,%i]\n", nWidth, nHeight);
	}
	sciprint("Camera %i opened with folllowing resolution\n", nCurrFile);
	sciprint("Size : [%.0f,%.0f]\n", OpenedCam[nCurrFile].cap.get(CAP_PROP_FRAME_WIDTH), OpenedCam[nCurrFile].cap.get(CAP_PROP_FRAME_HEIGHT));

	// ToDo: Accept more input from users
	//	cvSetCaptureProperty(OpenedAviCap[nCurrFile].video.cap, CV_CAP_PROP_FRAME_WIDTH, *sz);
	//	cvSetCaptureProperty(OpenedAviCap[nCurrFile].video.cap, CV_CAP_PROP_FRAME_HEIGHT, *(sz + 1));
	//	cvSetCaptureProperty(OpenedAviCap[nCurrFile].video.cap, CV_CAP_PROP_FPS, 30);
	//	cvSetCaptureProperty(OpenedAviCap[nCurrFile].video.cap, CV_CAP_PROP_BUFFERSIZE, 1);


	strncpy(OpenedCam[nCurrFile].filename, "camera", MAX_FILENAME_LENGTH);
	OpenedCam[nCurrFile].iswriter = 0;

	//the output is the opened index
	nCurrFile += 1;

	mL1 = 1;
	nL1 = 1;

	iRet = createScalarDouble(pvApiCtx, nbInputArgument(pvApiCtx) + 1, (double)*pret);			
	AssignOutputVariable(pvApiCtx, 1) = nbInputArgument(pvApiCtx) + 1;

	return 0;
}
