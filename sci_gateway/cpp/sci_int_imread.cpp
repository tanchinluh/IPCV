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
#include "ipcv_image_io.h"
#include <string.h>

extern "C" 
{
int sci_int_imread(char * fname,void* pvApiCtx);
}

static FILE *ipcv_open_debug_log()
{
	const char *enabled = getenv("IPCV_IMREAD_DEBUG");
	if (enabled == NULL || enabled[0] == 0)
	{
		return NULL;
	}

	return fopen("F:\\ScilabModules\\IPCV\\ipcv_imread_debug.log", "ab");
}

static size_t ipcv_depth_size(int depth)
{
	switch(depth)
	{
	case IPCV_DEPTH_8U:
	case IPCV_DEPTH_8S:
		return 1;
	case IPCV_DEPTH_16U:
	case IPCV_DEPTH_16S:
		return 2;
	case IPCV_DEPTH_32S:
	case IPCV_DEPTH_32F:
		return 4;
	case IPCV_DEPTH_64F:
		return 8;
	default:
		return 0;
	}
}

static int ipcv_set_decoded_image(int nPos, const IpcvDecodedImage& image, void* pvApiCtx, FILE *dbg)
{
	const int rows = image.rows;
	const int cols = image.cols;
	const int channels = image.channels;
	int dims[3] = {rows, cols, channels};
	const int outVar = nbInputArgument(pvApiCtx) + nPos;
	const size_t elemBytes = ipcv_depth_size(image.depth);
	const size_t expectedBytes = static_cast<size_t>(rows) * cols * channels * elemBytes;
	SciErr sciErr;

	if (rows <= 0 || cols <= 0 || channels <= 0 || image.data == NULL || elemBytes == 0 || image.byte_count != expectedBytes)
	{
		Scierror(999, "imread: Empty decoded image.\n");
		return -1;
	}

	if (dbg)
	{
		fprintf(dbg, "int_imread: before direct Scilab image create rows=%d cols=%d channels=%d depth=%d elemBytes=%zu\n",
			rows, cols, channels, image.depth, elemBytes);
		fflush(dbg);
	}

	switch(image.depth)
	{
	case IPCV_DEPTH_8U:
		if (channels >= 2)
		{
			sciErr = createHypermatOfUnsignedInteger8(pvApiCtx, outVar, dims, 3, image.data);
		}
		else
		{
			sciErr = createMatrixOfUnsignedInteger8(pvApiCtx, outVar, rows, cols, image.data);
		}
		break;
	case IPCV_DEPTH_8S:
		if (channels >= 2)
		{
			sciErr = createHypermatOfInteger8(pvApiCtx, outVar, dims, 3, reinterpret_cast<const char*>(image.data));
		}
		else
		{
			sciErr = createMatrixOfInteger8(pvApiCtx, outVar, rows, cols, reinterpret_cast<const char*>(image.data));
		}
		break;
	case IPCV_DEPTH_16U:
		if (channels >= 2)
		{
			sciErr = createHypermatOfUnsignedInteger16(pvApiCtx, outVar, dims, 3, reinterpret_cast<const unsigned short*>(image.data));
		}
		else
		{
			sciErr = createMatrixOfUnsignedInteger16(pvApiCtx, outVar, rows, cols, reinterpret_cast<const unsigned short*>(image.data));
		}
		break;
	case IPCV_DEPTH_16S:
		if (channels >= 2)
		{
			sciErr = createHypermatOfInteger16(pvApiCtx, outVar, dims, 3, reinterpret_cast<const short*>(image.data));
		}
		else
		{
			sciErr = createMatrixOfInteger16(pvApiCtx, outVar, rows, cols, reinterpret_cast<const short*>(image.data));
		}
		break;
	case IPCV_DEPTH_32S:
		if (channels >= 2)
		{
			sciErr = createHypermatOfInteger32(pvApiCtx, outVar, dims, 3, reinterpret_cast<const int*>(image.data));
		}
		else
		{
			sciErr = createMatrixOfInteger32(pvApiCtx, outVar, rows, cols, reinterpret_cast<const int*>(image.data));
		}
		break;
	case IPCV_DEPTH_64F:
		if (channels >= 2)
		{
			sciErr = createHypermatOfDouble(pvApiCtx, outVar, dims, 3, reinterpret_cast<const double*>(image.data));
		}
		else
		{
			sciErr = createMatrixOfDouble(pvApiCtx, outVar, rows, cols, reinterpret_cast<const double*>(image.data));
		}
		break;
	default:
		Scierror(999, "imread: Unsupported image depth %d.\n", image.depth);
		return -1;
	}

	if(sciErr.iErr)
	{
		printError(&sciErr, 0);
		if (dbg) { fprintf(dbg, "int_imread: direct Scilab image create SciErr %d\n", sciErr.iErr); fflush(dbg); }
		return sciErr.iErr;
	}

	AssignOutputVariable(pvApiCtx, nPos) = outVar;
	if (dbg) { fprintf(dbg, "int_imread: after direct Scilab image create outVar=%d\n", outVar); fflush(dbg); }
	return 0;
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
	//
	////pImage = cvLoadImage(cstk(lR), CV_LOAD_IMAGE_ANYDEPTH|CV_LOAD_IMAGE_ANYCOLOR);
	////pImage = imread(pstName,CV_LOAD_IMAGE_ANYDEPTH|CV_LOAD_IMAGE_ANYCOLOR);
	
	/*string str1(pstName);

	if ((str1.find(str2) != std::string::npos))
	{
		pImage = imread(pstName, IMREAD_LOAD_GDAL | IMREAD_ANYDEPTH | IMREAD_ANYCOLOR);
	}
	else
	{
		pImage = imread(pstName, IMREAD_ANYDEPTH | IMREAD_ANYCOLOR);
	}*/
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

	if (dbg) { fprintf(dbg, "int_imread: before ipcv_set_decoded_image\n"); fflush(dbg); }
	iRet = ipcv_set_decoded_image(1, decodedImage, pvApiCtx, dbg);
	if (dbg) { fprintf(dbg, "int_imread: after ipcv_set_decoded_image ret=%d\n", iRet); fflush(dbg); }
	freeAllocatedSingleString(pstName);
	ipcv_free_decoded_image(&decodedImage);
	if (iRet)
	{
		if (dbg) { fprintf(dbg, "int_imread: ipcv_set_decoded_image failed\n"); fclose(dbg); }
		return iRet;
	}

	if (dbg) { fprintf(dbg, "int_imread: before ReturnArguments\n"); fflush(dbg); }
	ReturnArguments(pvApiCtx);
	if (dbg) { fprintf(dbg, "int_imread: after ReturnArguments\n"); fclose(dbg); }


	return 0;
}
