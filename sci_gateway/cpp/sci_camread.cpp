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
 *  Copyright (C) Trity Technologies - 2013 -
 * http://www.gnu.org/licenses/gpl-2.0.txt
 ***********************************************************************/

#include "common.h"

int sci_camread(char * fname,void* pvApiCtx)
{
  
  int mR1, nR1, lR1;
  int mR2, nR2, lR2;
  int mR3, nR3, lR3;
  int szd[] = {640,480};
  int *sz = &szd[0];
  int nFile;
  double *out = NULL;
  int iRows	= 0;
  int iCols	= 0;

  double tmp;

  CheckInputArgument(pvApiCtx, 1, 1);
  CheckOutputArgument(pvApiCtx, 0, 1);

  GetDouble(1,out,iRows,iCols,pvApiCtx);
  nFile =  round(*out);
  nFile -= 1;
 

  if (!(nFile >= 0 && nFile < MAX_AVI_FILE_NUM))
    {
      Scierror(999, "%s: The argument should >=1 and <= %d.\r\n", fname, MAX_AVI_FILE_NUM);
      return -1;
    }

  // Added 2018-10-16 
  if (OpenedCam[nFile].cap.isOpened())
  {
	  Mat dst;
	  OpenedCam[nFile].cap >> dst;
	  SetImage(1, dst, pvApiCtx);
	  dst.release();

  }
  else
  {
	  Scierror(999, "The %d'th camera is not opened.\r\n", nFile);
  }





  return 0;
}

