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

/* close all opened files */
int sci_camcloseall(char *fname,void* pvApiCtx)
{
	int i;

	//CheckRhs(0, 0);
	//CheckLhs(0, 1);
  CheckInputArgument(pvApiCtx, 0, 0);
  CheckOutputArgument(pvApiCtx, 0, 1);

	for (i = 0; i < MAX_AVI_FILE_NUM; i++)
	{
		if(OpenedCam[i].cap.isOpened()) //OpenedVideoCapture[nCurrFile].cap
		{
			//if it is reader for video/camera
			if (!OpenedCam[i].iswriter)
				OpenedCam[i].cap.release();
				//cvReleaseCapture( &(OpenedAviCap[i].video.cap) );
			//if it is reader for video/camera
			else
				OpenedCam[i].cap.release();
				//cvReleaseVideoWriter(&(OpenedAviCap[i].video.writer));

			memset(OpenedCam[i].filename, 0, sizeof(OpenedCam[i].filename) );
		}
	}

	return 0;
}
