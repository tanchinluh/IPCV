/***********************************************************************
* SIVP - Scilab Image and Video Processing toolbox
* Copyright (C) 2005  Shiqi Yu
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


/**********************************************************************
* this function only supports UINT8, UINT16, INT32, SINGLE, DOUBLE
* imout=imresize(imin, scale);
* imout=imresize(imin, scale, interp);
* imout=imresize(imin, [mrows ncols]);
* imout=imresize(imin, [mrows ncols], interp);
*
* interp = 'nearest', 'bilinear', 'bicubic' or 'area'
**********************************************************************/
int sci_imresize(char * fname,void* pvApiCtx)
{

	SciErr sciErr;
	int* piAddr = NULL;
	int iType   = 0;
	int iRet    = 0;
	int Interpolation = INTER_NEAREST;
	Mat src,dst;
	double *out = NULL;
	int iRows			= 0;
	int iCols			= 0;

	CheckInputArgument(pvApiCtx, 2, 3);
	CheckOutputArgument(pvApiCtx, 0, 1);

	GetImage(1,src,pvApiCtx);

	GetDouble(2,out,iRows,iCols,pvApiCtx);
	//sciprint("%i\t%i\n",iRows,iCols);
	Size dsize;
	if(iRows == 1 && iCols == 1)
	{
		dsize = Size(round(src.cols * *out),round(src.rows * *out));
	}
	else if(iRows * iCols == 2)
	{
		dsize = Size(round(*(out+1)) ,round(*out) );
	}
	else
	{
		Scierror(999, "%s: The second parameter should be a double value or 1X2 vector.\r\n", fname);
		return -1;
	}

	if( *getNbInputArgument(pvApiCtx) == 3)
	{
		char *pstName = NULL;
		int ret = GetString(3, pstName,pvApiCtx);

		if (ret==0)
		{
			if( strcmp(pstName, "nearest") == 0)
				Interpolation = INTER_NEAREST;
			else if( strcmp(pstName, "bilinear") == 0)
				Interpolation = INTER_LINEAR;
			else if( strcmp(pstName, "bicubic") == 0)
				Interpolation = INTER_CUBIC;
			else if( strcmp(pstName, "area") == 0)
				Interpolation = INTER_AREA;
			else if( strcmp(pstName, "lanczos") == 0)
				Interpolation = INTER_LANCZOS4 ;
			else
			{
				Scierror(999, "%s: Interpolation method '%s' is not supported.\r\nSee the help page of %s for detailed information.\r\n", fname, pstName, fname);
				return -1;
			}
		}
		else
		{
			Scierror(999, "%s: Interpolation method '%d' is not supported.\r\nSee the help page of %s for detailed information.\r\n", fname, pstName, fname);
			return -1;
		}
	}

	resize(src, dst, dsize, 0, 0, Interpolation);
	//resize(src, dst, dsize, 0, 0, INTER_LINEAR);
	SetImage(1,dst,pvApiCtx);

	return 0;
}
