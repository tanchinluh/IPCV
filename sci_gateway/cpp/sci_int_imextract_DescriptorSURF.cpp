/***********************************************************************
 * IPCV - Scilab Image Processing and Computer Vision toolbox
 * Copyright (C) 2017  Tan Chin Luh
***********************************************************************/

#include "common.h"
#include "ipcv_gateway_image.h"

int sci_int_imextract_DescriptorSURF(char * fname,void* pvApiCtx)
{

	CheckInputArgument(pvApiCtx, 2, 2);
	CheckOutputArgument(pvApiCtx, 0, 1);

	IpcvDecodedImage image;
	IpcvKeypointMatrix keypoints;
	IpcvDecodedImage descriptors;
	memset(&descriptors, 0, sizeof(descriptors));

	int iRet = ipcv_get_image_argument(pvApiCtx, 1, image);
	if (iRet)
	{
		Scierror(999, "%s: Wrong type for input argument #%d: Image expected.\n", fname, 1);
		return iRet;
	}

	iRet = ipcv_get_keypoint_matrix_argument(pvApiCtx, 2, keypoints);
	if (iRet)
	{
		ipcv_release_image_argument(image);
		Scierror(999, "%s: Wrong type for input argument #%d: 7-row keypoint matrix expected.\n", fname, 2);
		return iRet;
	}

	iRet = ipcv_compute_surf_descriptors(&image, &keypoints, &descriptors);
	ipcv_release_image_argument(image);
	if (iRet)
	{
		sciprint("%s: %s\n", fname, descriptors.error);
		ipcv_free_decoded_image(&descriptors);
		SciErr sciErr;
		const int outVar = nbInputArgument(pvApiCtx) + 1;
		sciErr = createMatrixOfDouble(pvApiCtx, outVar, 0, 0, NULL);
		if (sciErr.iErr)
		{
			printError(&sciErr, 0);
			return sciErr.iErr;
		}
		AssignOutputVariable(pvApiCtx, 1) = outVar;
		return 0;
	}

	iRet = ipcv_set_image_argument(pvApiCtx, 1, descriptors);
	ipcv_free_decoded_image(&descriptors);
	return iRet;
}
