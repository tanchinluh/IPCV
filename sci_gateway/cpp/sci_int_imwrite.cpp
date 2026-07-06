/***********************************************************************
 * IPCV - Scilab Image Processing and Computer Vision toolbox
 * Copyright (C) 2017  Tan Chin Luh
 ***********************************************************************/

#include "common.h"
#include "ipcv_image_io.h"
#include <string.h>

struct IpcvScilabImageView
{
	const unsigned char *data;
	int rows;
	int cols;
	int channels;
	int depth;
};

static FILE *ipcv_open_imwrite_debug_log()
{
	const char *enabled = getenv("IPCV_IMWRITE_DEBUG");
	if (enabled == NULL || enabled[0] == 0)
	{
		return NULL;
	}

	return fopen("F:\\ScilabModules\\IPCV\\ipcv_imwrite_debug.log", "ab");
}

static int ipcv_get_scilab_uint_image(void* pvApiCtx, int nPos, IpcvScilabImageView& image)
{
	SciErr sciErr;
	int *piAddr = NULL;
	int precision = 0;
	int *dims = NULL;
	int ndims = 0;

	memset(&image, 0, sizeof(image));
	sciErr = getVarAddressFromPosition(pvApiCtx, nPos, &piAddr);
	if (sciErr.iErr)
	{
		printError(&sciErr, 0);
		return sciErr.iErr;
	}

	if (isHypermatType(pvApiCtx, piAddr))
	{
		sciErr = getHypermatOfIntegerPrecision(pvApiCtx, piAddr, &precision);
		if (sciErr.iErr)
		{
			printError(&sciErr, 0);
			return sciErr.iErr;
		}

		if (precision == SCI_UINT8)
		{
			unsigned char *data = NULL;
			sciErr = getHypermatOfUnsignedInteger8(pvApiCtx, piAddr, &dims, &ndims, &data);
			if (sciErr.iErr)
			{
				printError(&sciErr, 0);
				return sciErr.iErr;
			}
			image.data = data;
			image.depth = IPCV_DEPTH_8U;
		}
		else if (precision == SCI_UINT16)
		{
			unsigned short *data = NULL;
			sciErr = getHypermatOfUnsignedInteger16(pvApiCtx, piAddr, &dims, &ndims, &data);
			if (sciErr.iErr)
			{
				printError(&sciErr, 0);
				return sciErr.iErr;
			}
			image.data = reinterpret_cast<const unsigned char*>(data);
			image.depth = IPCV_DEPTH_16U;
		}
		else
		{
			return -1;
		}

		if (ndims < 2 || ndims > 3)
		{
			return -1;
		}
		image.rows = dims[0];
		image.cols = dims[1];
		image.channels = ndims >= 3 ? dims[2] : 1;
		return 0;
	}

	sciErr = getMatrixOfIntegerPrecision(pvApiCtx, piAddr, &precision);
	if (sciErr.iErr)
	{
		printError(&sciErr, 0);
		return sciErr.iErr;
	}

	if (precision == SCI_UINT8)
	{
		unsigned char *data = NULL;
		sciErr = getMatrixOfUnsignedInteger8(pvApiCtx, piAddr, &image.rows, &image.cols, &data);
		if (sciErr.iErr)
		{
			printError(&sciErr, 0);
			return sciErr.iErr;
		}
		image.data = data;
		image.channels = 1;
		image.depth = IPCV_DEPTH_8U;
		return 0;
	}
	if (precision == SCI_UINT16)
	{
		unsigned short *data = NULL;
		sciErr = getMatrixOfUnsignedInteger16(pvApiCtx, piAddr, &image.rows, &image.cols, &data);
		if (sciErr.iErr)
		{
			printError(&sciErr, 0);
			return sciErr.iErr;
		}
		image.data = reinterpret_cast<const unsigned char*>(data);
		image.channels = 1;
		image.depth = IPCV_DEPTH_16U;
		return 0;
	}

	return -1;
}

/**********************************************************************
* This function is using the OpenCV highgui function for plotting image
* imdisplay(imin);
**********************************************************************/
int sci_int_imwrite(char * fname,void* pvApiCtx)
{
	SciErr sciErr;
	FILE *dbg = ipcv_open_imwrite_debug_log();
	if (dbg) { fprintf(dbg, "int_imwrite: enter\n"); fflush(dbg); }

	CheckInputArgument(pvApiCtx, 3, 3);
	CheckOutputArgument(pvApiCtx, 0, 1);

	/////////////////
	// First Input //
	/////////////////
	IpcvScilabImageView image;
	int* piAddr = NULL;
	char* pstData = NULL;
	int iRet    = 0;
	if (dbg) { fprintf(dbg, "int_imwrite: before ipcv_get_scilab_uint_image\n"); fflush(dbg); }
	iRet = ipcv_get_scilab_uint_image(pvApiCtx, 1, image);
	if (dbg) { fprintf(dbg, "int_imwrite: after ipcv_get_scilab_uint_image ret=%d rows=%d cols=%d channels=%d depth=%d data=%p\n", iRet, image.rows, image.cols, image.channels, image.depth, image.data); fflush(dbg); }
	if (iRet)
	{
		Scierror(999, "%s: Wrong type for input argument #%d: uint8 or uint16 image expected.\n", fname, 1);
		if (dbg) { fclose(dbg); }
		return iRet;
	}
	// sciprint(".");
	sciErr = getVarAddressFromPosition(pvApiCtx, 2, &piAddr);
	iRet = getAllocatedSingleString(pvApiCtx, piAddr, &pstData);
		if(iRet)
		{
			freeAllocatedSingleString(pstData);
			if (dbg) { fprintf(dbg, "int_imwrite: get filename failed %d\n", iRet); fclose(dbg); }
			return iRet;
		}
	if (dbg) { fprintf(dbg, "int_imwrite: filename=%s\n", pstData); fflush(dbg); }
    
	// Second Input - Rotation angle
	int *piAddr2 = NULL;
	double compression_ratio = 0;
	getVarAddressFromPosition(pvApiCtx, 3, &piAddr2);
	getScalarDouble(pvApiCtx, piAddr2, &compression_ratio);
	if (dbg) { fprintf(dbg, "int_imwrite: quality=%f\n", compression_ratio); fflush(dbg); }

	char error[1024] = {0};
	if (dbg) { fprintf(dbg, "int_imwrite: before ipcv_write_image rows=%d cols=%d channels=%d depth=%d data=%p\n", image.rows, image.cols, image.channels, image.depth, image.data); fflush(dbg); }
	int retval = ipcv_write_image(pstData, image.data, image.rows, image.cols, image.channels, image.depth, int(compression_ratio), error, sizeof(error));
	if (dbg) { fprintf(dbg, "int_imwrite: after ipcv_write_image ret=%d error=%s\n", retval, error); fflush(dbg); }
	freeAllocatedSingleString(pstData);
	if (retval < 0)
	{
		Scierror(999, "%s: Could not write image: %s\r\n", fname, error);
		if (dbg) { fclose(dbg); }
		return -1;
	}
	int iRows1 = 1;
	int iCols1 = 1;
	double pdblReal1;
	pdblReal1 = double(retval);

	//SetDouble(1, pdblReal1, iRows1, iCols1, pvApiCtx);
	iRet = createScalarDouble(pvApiCtx, nbInputArgument(pvApiCtx) + 1, pdblReal1);
	AssignOutputVariable(pvApiCtx, 1) = nbInputArgument(pvApiCtx) + 1;
	if (dbg) { fprintf(dbg, "int_imwrite: exit\n"); fclose(dbg); }

	return 0;

}
