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

#include "common.h"

int sci_aviinfo(char *fname,void* pvApiCtx)
{
	int mL, nL;
	int mR, nR, lR;
	int nCurrFile = 0;
	int *pret = &nCurrFile;
	char *fn = NULL;
	int iRet    = 0;

	CheckInputArgument(pvApiCtx, 1, 1);
	CheckOutputArgument(pvApiCtx, 0, 4);

	GetString(1, fn, pvApiCtx);
	
	VideoCapture cap(fn);
	if(!cap.isOpened())
	{
		Scierror(999, "%s: Can not open video file %s. \nMaybe the codec of the video can not be handled or the file does not exist.\r\n", fname, fn);
		return -1;
	}
	// sciprint("Size : [%i\,%i]\n", nWidth, nHeight); 
	// sciprint("Frame Count : %.0f\n", cap.get(CAP_PROP_FRAME_COUNT));
	// sciprint("Frame Width : %.0f\n", cap.get(CAP_PROP_FRAME_WIDTH));
	// sciprint("Frame Height : %.0f\n", cap.get(CAP_PROP_FRAME_HEIGHT));
	// sciprint("Frame Rate : %.0f\n", cap.get(CAP_PROP_FPS));
	

	int iRows1 = 1;
	int iCols1 = 1;
	double* pdblReal1 = NULL;
	pdblReal1 = new double[iRows1*iCols1];

	*pdblReal1 = cap.get(CAP_PROP_FRAME_COUNT);
	SetDouble(1, pdblReal1, iRows1, iCols1, pvApiCtx);

	*pdblReal1 = cap.get(CAP_PROP_FRAME_WIDTH);
	SetDouble(2, pdblReal1, iRows1, iCols1, pvApiCtx);

	*pdblReal1 = cap.get(CAP_PROP_FRAME_HEIGHT);
	SetDouble(3, pdblReal1, iRows1, iCols1, pvApiCtx);

	*pdblReal1 = cap.get(CAP_PROP_FPS);
	SetDouble(4, pdblReal1, iRows1, iCols1, pvApiCtx);

	delete[] pdblReal1;

	return 0;
}