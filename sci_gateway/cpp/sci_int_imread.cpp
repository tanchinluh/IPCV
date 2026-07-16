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



#include "ipcv_gateway_common.h"
#include "ipcv_gateway_image.h"
#include "ipcv_image_io.h"
#include <string.h>

extern "C" 
{
int sci_int_imread(char * fname,void* pvApiCtx);
}

static FILE *ipcv_open_debug_log()
{
	const char *enabled = getenv("IPCV_IMREAD_DEBUG");
	if (enabled == NULL || enabled[0] == 0 || strcmp(enabled, "0") == 0)
	{
		return NULL;
	}

	const char *log_path = strcmp(enabled, "1") == 0 ? "ipcv_imread_debug.log" : enabled;
	return fopen(log_path, "ab");
}

int sci_int_imread(char * fname,void* pvApiCtx)
{

	char *pstName = NULL;
	IpcvDecodedImage decodedImage;
	memset(&decodedImage, 0, sizeof(decodedImage));
	FILE *dbg = ipcv_open_debug_log();
	if (dbg)
	{
		fprintf(dbg, "int_imread: enter\n");
		fflush(dbg);
	}

	CheckInputArgument(pvApiCtx, 2, 2);
	CheckOutputArgument(pvApiCtx, 1, 1);
	
	// First Input
	SciErr sciErr;
	int* piAddrName = NULL;
	sciErr = getVarAddressFromPosition(pvApiCtx, 1, &piAddrName);
	if (sciErr.iErr)
	{
		printError(&sciErr, 0);
		return sciErr.iErr;
	}

	if (!isStringType(pvApiCtx, piAddrName) || !isScalar(pvApiCtx, piAddrName))
	{
		Scierror(999, "%s: Wrong type for input argument #%d: A scalar string expected.\n", fname, 1);
		return -1;
	}

	int iRet = getAllocatedSingleString(pvApiCtx, piAddrName, &pstName);
	if (iRet || pstName == NULL)
	{
		Scierror(999, "%s: Can not read input argument #%d.\n", fname, 1);
		if (dbg) { fprintf(dbg, "int_imread: getAllocatedSingleString failed %d\n", iRet); fclose(dbg); }
		return iRet;
	}
	if (dbg)
	{
		fprintf(dbg, "int_imread: filename=%s\n", pstName);
		fflush(dbg);
	}
	
	// Second Input
	int* piAddr = NULL;
	sciErr = getVarAddressFromPosition(pvApiCtx, 2, &piAddr);
	if (sciErr.iErr)
	{
		printError(&sciErr, 0);
		freeAllocatedSingleString(pstName);
		return sciErr.iErr;
	}
	///

	char cData = 0;
	iRet = getScalarInteger8(pvApiCtx, piAddr, &cData);
	if (iRet)
	{
		freeAllocatedSingleString(pstName);
		if (dbg) { fprintf(dbg, "int_imread: getScalarInteger8 failed %d\n", iRet); fclose(dbg); }
		return iRet;
	}

	int flags = static_cast<int>(cData);
	if (flags < 0 && flags != IMREAD_UNCHANGED)
	{
		flags += 256;
	}
	if (dbg)
	{
		fprintf(dbg, "int_imread: flags=%d raw=%d\n", flags, static_cast<int>(cData));
		fflush(dbg);
	}

	if (dbg) { fprintf(dbg, "int_imread: before ipcv_decode_image\n"); fflush(dbg); }
	iRet = ipcv_decode_image(pstName, flags, &decodedImage);
	if (dbg)
	{
		fprintf(dbg, "int_imread: after decoder ret=%d rows=%d cols=%d channels=%d depth=%d bytes=%zu data=%p error=%s\n",
			iRet, decodedImage.rows, decodedImage.cols, decodedImage.channels, decodedImage.depth, decodedImage.byte_count, decodedImage.data, decodedImage.error);
		fflush(dbg);
	}
	if (iRet)
	{
		Scierror(999, "%s: Could not import decoded image %s: %s\r\n", fname, pstName, decodedImage.error);
		freeAllocatedSingleString(pstName);
		ipcv_free_decoded_image(&decodedImage);
		if (dbg) { fprintf(dbg, "int_imread: decoder failed\n"); fclose(dbg); }
		return iRet;
	}
	
	//pImage = imread(pstName,IMREAD_LOAD_GDAL|IMREAD_ANYDEPTH);

	/* if load image failed */
	if(decodedImage.rows <= 0 || decodedImage.cols <= 0 || decodedImage.data == NULL)
	{
		Scierror(999, "%s: Can not open file %s.\r\n", fname, pstName);
		freeAllocatedSingleString(pstName);
		ipcv_free_decoded_image(&decodedImage);
		if (dbg) { fprintf(dbg, "int_imread: image empty\n"); fclose(dbg); }
		return -1;
	}

	if (dbg) { fprintf(dbg, "int_imread: before ipcv_set_image_argument\n"); fflush(dbg); }
	iRet = ipcv_set_image_argument(pvApiCtx, 1, decodedImage);
	if (dbg) { fprintf(dbg, "int_imread: after ipcv_set_image_argument ret=%d\n", iRet); fflush(dbg); }
	freeAllocatedSingleString(pstName);
	ipcv_free_decoded_image(&decodedImage);
	if (iRet)
	{
		if (dbg) { fprintf(dbg, "int_imread: ipcv_set_image_argument failed\n"); fclose(dbg); }
		return iRet;
	}

	if (dbg) { fprintf(dbg, "int_imread: before ReturnArguments\n"); fflush(dbg); }
	ReturnArguments(pvApiCtx);
	if (dbg) { fprintf(dbg, "int_imread: after ReturnArguments\n"); fclose(dbg); }


	return 0;
}
