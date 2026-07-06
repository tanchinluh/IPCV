/***********************************************************************
*  Copyright (C) Trity Technologies - 2012 -
* http://www.gnu.org/licenses/gpl-2.0.txt
***********************************************************************/

#include "common.h"
#include "ipcv_gateway_image.h"

int sci_int_imdrawmatches(char * fname,void* pvApiCtx)
{

	CheckInputArgument(pvApiCtx, 5, 5);
	CheckOutputArgument(pvApiCtx, 0, 1);

	IpcvDecodedImage leftImage;
	IpcvDecodedImage rightImage;
	IpcvKeypointMatrix leftKeypoints;
	IpcvKeypointMatrix rightKeypoints;
	IpcvMatchMatrix matches;
	IpcvDecodedImage output;
	memset(&output, 0, sizeof(output));

	int iRet = ipcv_get_image_argument(pvApiCtx, 1, leftImage);
	if (iRet)
	{
		Scierror(999, "%s: Wrong type for input argument #%d: Image expected.\n", fname, 1);
		return iRet;
	}

	iRet = ipcv_get_image_argument(pvApiCtx, 2, rightImage);
	if (iRet)
	{
		ipcv_release_image_argument(leftImage);
		Scierror(999, "%s: Wrong type for input argument #%d: Image expected.\n", fname, 2);
		return iRet;
	}

	iRet = ipcv_get_keypoint_matrix_argument(pvApiCtx, 3, leftKeypoints);
	if (iRet)
	{
		ipcv_release_image_argument(leftImage);
		ipcv_release_image_argument(rightImage);
		Scierror(999, "%s: Wrong type for input argument #%d: 7-row keypoint matrix expected.\n", fname, 3);
		return iRet;
	}

	iRet = ipcv_get_keypoint_matrix_argument(pvApiCtx, 4, rightKeypoints);
	if (iRet)
	{
		ipcv_release_image_argument(leftImage);
		ipcv_release_image_argument(rightImage);
		Scierror(999, "%s: Wrong type for input argument #%d: 7-row keypoint matrix expected.\n", fname, 4);
		return iRet;
	}

	iRet = ipcv_get_match_matrix_argument(pvApiCtx, 5, matches);
	if (iRet)
	{
		ipcv_release_image_argument(leftImage);
		ipcv_release_image_argument(rightImage);
		Scierror(999, "%s: Wrong type for input argument #%d: 4-row match matrix expected.\n", fname, 5);
		return iRet;
	}

	iRet = ipcv_draw_matches(&leftImage, &rightImage, &leftKeypoints, &rightKeypoints, &matches, &output);
	ipcv_release_image_argument(leftImage);
	ipcv_release_image_argument(rightImage);
	if (iRet)
	{
		Scierror(999, "%s: %s\n", fname, output.error);
		ipcv_free_decoded_image(&output);
		return iRet;
	}

	iRet = ipcv_set_image_argument(pvApiCtx, 1, output);
	ipcv_free_decoded_image(&output);
	return iRet;
}
