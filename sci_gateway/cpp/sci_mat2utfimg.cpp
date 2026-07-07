/***********************************************************************
* SIVP - Scilab Image and Video Processing toolbox
* Copyright (C) 2005  Vincent Etienne
*
* IPCV - Scilab Image Processing and Computer Vision toolbox
* Copyright (C) 2017  Tan Chin Luh
***********************************************************************/

#include "common.h"
#include "ipcv_gateway_image.h"

int sci_mat2utfimg(char * fname, void* pvApiCtx)
{
	CheckInputArgument(pvApiCtx, 1, 1);
	CheckOutputArgument(pvApiCtx, 1, 1);

	IpcvDecodedImage image;
	IpcvByteBuffer utf;
	memset(&utf, 0, sizeof(utf));

	int iRet = ipcv_get_image_argument(pvApiCtx, 1, image);
	if (iRet)
	{
		Scierror(999, "%s: Wrong type for input argument #%d: Image expected.\n", fname, 1);
		return iRet;
	}

	iRet = ipcv_image_to_utf(&image, &utf);
	ipcv_release_image_argument(image);
	if (iRet)
	{
		Scierror(999, "%s: %s.\r\n", fname, utf.error);
		ipcv_free_byte_buffer(&utf);
		return iRet;
	}

	SciErr sciErr = createMatrixOfUnsignedInteger8(pvApiCtx, nbInputArgument(pvApiCtx) + 1, 1, utf.count, utf.data);
	if (sciErr.iErr)
	{
		printError(&sciErr, 0);
		ipcv_free_byte_buffer(&utf);
		return sciErr.iErr;
	}

	AssignOutputVariable(pvApiCtx, 1) = nbInputArgument(pvApiCtx) + 1;
	ipcv_free_byte_buffer(&utf);
	return 0;
}
