#include "ipcv_gateway_common.h"

int GetString(int nPos, char *&pstName, void* pvApiCtx)
{
	SciErr sciErr;
	int *piAddr = NULL;

	sciErr = getVarAddressFromPosition(pvApiCtx, nPos, &piAddr);
	if (sciErr.iErr)
	{
		printError(&sciErr, 0);
		return sciErr.iErr;
	}

	if (!isStringType(pvApiCtx, piAddr))
	{
		sciprint("Not String Type\n");
		return -1;
	}
	if (!isScalar(pvApiCtx, piAddr))
	{
		sciprint("Not Scalar Type\n");
		return -1;
	}

	char *value = NULL;
	int iRet = getAllocatedSingleString(pvApiCtx, piAddr, &value);
	if (iRet)
	{
		if (value != NULL)
		{
			freeAllocatedSingleString(value);
		}
		return iRet;
	}

	pstName = value;
	return 0;
}

int SetString(int nPos, char *&pstName, void* pvApiCtx)
{
	int iRet = createSingleString(pvApiCtx, nbInputArgument(pvApiCtx) + nPos, pstName);
	if (iRet)
	{
		return iRet;
	}

	AssignOutputVariable(pvApiCtx, nPos) = nbInputArgument(pvApiCtx) + nPos;
	ReturnArguments(pvApiCtx);
	return 0;
}

int GetDouble2(int nPos, double *&pstdata, int& iRows, int& iCols, void* pvApiCtx)
{
	return GetDouble(nPos, pstdata, iRows, iCols, pvApiCtx);
}

int GetDouble(int nPos, double *&pstdata, int& iRows, int& iCols, void* pvApiCtx)
{
	SciErr sciErr;
	int *piAddr = NULL;

	sciErr = getVarAddressFromPosition(pvApiCtx, nPos, &piAddr);
	if (sciErr.iErr)
	{
		printError(&sciErr, 0);
		return sciErr.iErr;
	}

	if (!isDoubleType(pvApiCtx, piAddr))
	{
		printError(&sciErr, 0);
		return -1;
	}

	double *data = NULL;
	sciErr = getMatrixOfDouble(pvApiCtx, piAddr, &iRows, &iCols, &data);
	if (sciErr.iErr)
	{
		printError(&sciErr, 0);
		return sciErr.iErr;
	}

	pstdata = data;
	ReturnArguments(pvApiCtx);
	return 0;
}

int SetDouble(int nPos, double *&pstdata, int& iRows, int& iCols, void* pvApiCtx)
{
	SciErr sciErr = createMatrixOfDouble(pvApiCtx, nbInputArgument(pvApiCtx) + nPos, iRows, iCols, pstdata);
	if (sciErr.iErr)
	{
		printError(&sciErr, 0);
		return sciErr.iErr;
	}

	AssignOutputVariable(pvApiCtx, nPos) = nbInputArgument(pvApiCtx) + nPos;
	ReturnArguments(pvApiCtx);
	return 0;
}

string type2str(int type)
{
	string result;
	uchar depth = type & CV_MAT_DEPTH_MASK;
	uchar channels = 1 + (type >> CV_CN_SHIFT);

	switch (depth)
	{
	case CV_8U:
		result = "8U";
		break;
	case CV_8S:
		result = "8S";
		break;
	case CV_16U:
		result = "16U";
		break;
	case CV_16S:
		result = "16S";
		break;
	case CV_32S:
		result = "32S";
		break;
	case CV_32F:
		result = "32F";
		break;
	case CV_64F:
		result = "64F";
		break;
	default:
		result = "User";
		break;
	}

	result += "C";
	result += (channels + '0');
	return result;
}

int is_binary_image(Mat& image)
{
	double zeroCount = sum(image == 0)[0] / 255;
	double fullCount = sum(image == 255)[0] / 255;
	double pixelCount = image.rows * image.cols;
	return pixelCount == (zeroCount + fullCount) ? 1 : 0;
}
