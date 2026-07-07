/***********************************************************************
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


#include "ipcv_gateway_common.h"
#include "ipcv_image_io.h"

int sci_int_imfinfo(char *fname, void* pvApiCtx)
{
	char *pstName = NULL;
	SciErr sciErr;
	int *piAddr = NULL;
	double pdblData1[] = {0,0};
	double pdb1_depth;
	double pdb1_channel;

	CheckInputArgument(pvApiCtx, 1, 1);
	CheckOutputArgument(pvApiCtx, 1, 1);

	GetString(1, pstName, pvApiCtx);

	IpcvImageInfo imageInfo;
	int iRet = ipcv_image_info(pstName, IMREAD_LOAD_GDAL, &imageInfo);
	if (iRet)
	{
		Scierror(999, "%s: Can not open image file %s: %s\r\n", fname, pstName, imageInfo.error);
		freeAllocatedSingleString(pstName);
		return -1;
	}
	freeAllocatedSingleString(pstName);

	sciErr = createList(pvApiCtx, nbInputArgument(pvApiCtx) + 1, 3, &piAddr);
	if (sciErr.iErr)
	{
		printError(&sciErr, 0);
		return 0;
	}
		
	pdblData1[0] = imageInfo.width;
	pdblData1[1] = imageInfo.height;
	pdb1_depth = imageInfo.depth & 0x0FFFFFFF;
	pdb1_channel = imageInfo.channels;

	sciErr = createMatrixOfDoubleInList(pvApiCtx, nbInputArgument(pvApiCtx) + 1, piAddr, 1, 1, 2, pdblData1);
	if (sciErr.iErr)
	{
		printError(&sciErr, 0);
		return 0;
	}

	sciErr = createMatrixOfDoubleInList(pvApiCtx, nbInputArgument(pvApiCtx) + 1, piAddr, 2, 1, 1, &pdb1_depth);
	if (sciErr.iErr)
	{
		printError(&sciErr, 0);
		return 0;
	}

	sciErr = createMatrixOfDoubleInList(pvApiCtx, nbInputArgument(pvApiCtx) + 1, piAddr, 3, 1, 1, &pdb1_channel);
	if (sciErr.iErr)
	{
		printError(&sciErr, 0);
		return 0;
	}

	AssignOutputVariable(pvApiCtx, 1) = nbInputArgument(pvApiCtx) + 1;

	return 0;
}
