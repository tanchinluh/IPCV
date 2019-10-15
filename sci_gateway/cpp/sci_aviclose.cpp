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

/* close an opened file */
int sci_aviclose(char *fname,void* pvApiCtx)
{
	int mR, nR, lR;
	int nFile;
	double *out = NULL;
	int iRows			= 0;
	int iCols			= 0;

	CheckInputArgument(pvApiCtx, 1, 1);
	CheckOutputArgument(pvApiCtx, 0, 1);

	//GetRhsVar(1, "i", &mR, &nR, &lR);
	//CheckDims(1, mR, nR, 1, 1);
	GetDouble(1,out,iRows,iCols,pvApiCtx);
	nFile = round(*out);

	//nFile = *((int *)(istk(lR)));
	nFile = nFile - 1;

	if (nFile >= 0 && nFile < MAX_AVI_FILE_NUM)
	{
		if(OpenedAvi[nFile].cap.isOpened() | OpenedAvi[nFile].writer.isOpened())
		{
			//if it is reader for video/camera
			if (!OpenedAvi[nFile].iswriter)
				OpenedAvi[nFile].cap.release();
			//if it is reader for video/camera
			else
				OpenedAvi[nFile].writer.release();

			memset(OpenedAvi[nFile].filename, 0, sizeof(OpenedAvi[nFile].filename) );
		}
		else
		{
			Scierror(999, "%s: The %d'th file is not opened.\r\n", fname, nFile+1);
		}
	}
	else
	{
		Scierror(999, "%s: The argument should >=1 and <= %d.\r\n", fname, MAX_AVI_FILE_NUM);
	}

	return 0;
}
