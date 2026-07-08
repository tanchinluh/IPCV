#include "ipcv_gateway_common.h"
#include "ipcv_gateway_image.h"

#include <algorithm>
#include <stdlib.h>
#include <string.h>
#include <vector>

static std::vector<unsigned char*> ipcv_owned_input_buffers;

size_t ipcv_depth_size(int depth)
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

static int ipcv_fill_image_metadata(IpcvDecodedImage& image)
{
	const size_t elemBytes = ipcv_depth_size(image.depth);
	if (image.rows <= 0 || image.cols <= 0 || image.channels <= 0 || elemBytes == 0 || image.data == NULL)
	{
		return -1;
	}
	image.byte_count = static_cast<size_t>(image.rows) * image.cols * image.channels * elemBytes;
	return 0;
}

static int ipcv_set_boolean_image(IpcvDecodedImage& image, int rows, int cols, int channels, const int *source)
{
	const size_t count = static_cast<size_t>(rows) * cols * channels;
	unsigned char *data = static_cast<unsigned char*>(malloc(count));
	if (data == NULL)
	{
		return -1;
	}

	for (size_t i = 0; i < count; i++)
	{
		data[i] = source[i] ? 255 : 0;
	}

	image.rows = rows;
	image.cols = cols;
	image.channels = channels;
	image.depth = IPCV_DEPTH_8U;
	image.byte_count = count;
	image.data = data;
	ipcv_owned_input_buffers.push_back(data);
	return 0;
}

int ipcv_get_image_argument(void* pvApiCtx, int nPos, IpcvDecodedImage& image)
{
	SciErr sciErr;
	int *piAddr = NULL;
	int precision = 0;
	int *dims = NULL;
	int ndims = 0;
	int iRows = 0;
	int iCols = 0;

	memset(&image, 0, sizeof(image));
	sciErr = getVarAddressFromPosition(pvApiCtx, nPos, &piAddr);
	if (sciErr.iErr)
	{
		printError(&sciErr, 0);
		return sciErr.iErr;
	}

	if (isHypermatType(pvApiCtx, piAddr))
	{
		sciErr = getHypermatType(pvApiCtx, piAddr, &precision);
		if (sciErr.iErr)
		{
			printError(&sciErr, 0);
			return sciErr.iErr;
		}

		if (precision == sci_matrix)
		{
			double *data = NULL;
			sciErr = getHypermatOfDouble(pvApiCtx, piAddr, &dims, &ndims, &data);
			if (sciErr.iErr)
			{
				printError(&sciErr, 0);
				return sciErr.iErr;
			}
			image.data = reinterpret_cast<unsigned char*>(data);
			image.depth = IPCV_DEPTH_64F;
		}
		else if (precision == sci_boolean)
		{
			int *data = NULL;
			sciErr = getHypermatOfBoolean(pvApiCtx, piAddr, &dims, &ndims, &data);
			if (sciErr.iErr)
			{
				printError(&sciErr, 0);
				return sciErr.iErr;
			}
			if (ndims < 2 || ndims > 3)
			{
				return -1;
			}
			return ipcv_set_boolean_image(image, dims[0], dims[1], ndims == 3 ? dims[2] : 1, data);
		}
		else if (precision == sci_ints)
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
				image.data = data;
				image.depth = IPCV_DEPTH_8U;
			}
			else if (precision == SCI_INT8)
			{
				char *data = NULL;
				sciErr = getHypermatOfInteger8(pvApiCtx, piAddr, &dims, &ndims, &data);
				image.data = reinterpret_cast<unsigned char*>(data);
				image.depth = IPCV_DEPTH_8S;
			}
			else if (precision == SCI_UINT16)
			{
				unsigned short *data = NULL;
				sciErr = getHypermatOfUnsignedInteger16(pvApiCtx, piAddr, &dims, &ndims, &data);
				image.data = reinterpret_cast<unsigned char*>(data);
				image.depth = IPCV_DEPTH_16U;
			}
			else if (precision == SCI_INT16)
			{
				short *data = NULL;
				sciErr = getHypermatOfInteger16(pvApiCtx, piAddr, &dims, &ndims, &data);
				image.data = reinterpret_cast<unsigned char*>(data);
				image.depth = IPCV_DEPTH_16S;
			}
			else if (precision == SCI_INT32)
			{
				int *data = NULL;
				sciErr = getHypermatOfInteger32(pvApiCtx, piAddr, &dims, &ndims, &data);
				image.data = reinterpret_cast<unsigned char*>(data);
				image.depth = IPCV_DEPTH_32S;
			}
			else
			{
				return -1;
			}
			if (sciErr.iErr)
			{
				printError(&sciErr, 0);
				return sciErr.iErr;
			}
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
		image.channels = ndims == 3 ? dims[2] : 1;
		return ipcv_fill_image_metadata(image);
	}

	sciErr = getVarType(pvApiCtx, piAddr, &precision);
	if (sciErr.iErr)
	{
		printError(&sciErr, 0);
		return sciErr.iErr;
	}

	if (precision == sci_matrix)
	{
		double *data = NULL;
		sciErr = getMatrixOfDouble(pvApiCtx, piAddr, &iRows, &iCols, &data);
		if (sciErr.iErr)
		{
			printError(&sciErr, 0);
			return sciErr.iErr;
		}
		image.rows = iRows;
		image.cols = iCols;
		image.channels = 1;
		image.depth = IPCV_DEPTH_64F;
		image.data = reinterpret_cast<unsigned char*>(data);
		return ipcv_fill_image_metadata(image);
	}

	if (precision == sci_boolean)
	{
		int *data = NULL;
		sciErr = getMatrixOfBoolean(pvApiCtx, piAddr, &iRows, &iCols, &data);
		if (sciErr.iErr)
		{
			printError(&sciErr, 0);
			return sciErr.iErr;
		}
		return ipcv_set_boolean_image(image, iRows, iCols, 1, data);
	}

	if (precision != sci_ints)
	{
		return -1;
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
		sciErr = getMatrixOfUnsignedInteger8(pvApiCtx, piAddr, &iRows, &iCols, &data);
		image.data = data;
		image.depth = IPCV_DEPTH_8U;
	}
	else if (precision == SCI_INT8)
	{
		char *data = NULL;
		sciErr = getMatrixOfInteger8(pvApiCtx, piAddr, &iRows, &iCols, &data);
		image.data = reinterpret_cast<unsigned char*>(data);
		image.depth = IPCV_DEPTH_8S;
	}
	else if (precision == SCI_UINT16)
	{
		unsigned short *data = NULL;
		sciErr = getMatrixOfUnsignedInteger16(pvApiCtx, piAddr, &iRows, &iCols, &data);
		image.data = reinterpret_cast<unsigned char*>(data);
		image.depth = IPCV_DEPTH_16U;
	}
	else if (precision == SCI_INT16)
	{
		short *data = NULL;
		sciErr = getMatrixOfInteger16(pvApiCtx, piAddr, &iRows, &iCols, &data);
		image.data = reinterpret_cast<unsigned char*>(data);
		image.depth = IPCV_DEPTH_16S;
	}
	else if (precision == SCI_INT32)
	{
		int *data = NULL;
		sciErr = getMatrixOfInteger32(pvApiCtx, piAddr, &iRows, &iCols, &data);
		image.data = reinterpret_cast<unsigned char*>(data);
		image.depth = IPCV_DEPTH_32S;
	}
	else
	{
		return -1;
	}

	if (sciErr.iErr)
	{
		printError(&sciErr, 0);
		return sciErr.iErr;
	}
	image.rows = iRows;
	image.cols = iCols;
	image.channels = 1;
	return ipcv_fill_image_metadata(image);
}

void ipcv_release_image_argument(IpcvDecodedImage& image)
{
	std::vector<unsigned char*>::iterator it = std::find(ipcv_owned_input_buffers.begin(), ipcv_owned_input_buffers.end(), image.data);
	if (it != ipcv_owned_input_buffers.end())
	{
		free(image.data);
		ipcv_owned_input_buffers.erase(it);
	}
	image.data = NULL;
	image.byte_count = 0;
}

int ipcv_set_image_argument(void* pvApiCtx, int nPos, const IpcvDecodedImage& image)
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
		Scierror(999, "IPCV: Invalid image returned from C++ implementation.\n");
		return -1;
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
		Scierror(999, "IPCV: Unsupported image depth %d.\n", image.depth);
		return -1;
	}

	if (sciErr.iErr)
	{
		printError(&sciErr, 0);
		return sciErr.iErr;
	}

	AssignOutputVariable(pvApiCtx, nPos) = outVar;
	return 0;
}

int ipcv_set_image_stack_argument(void* pvApiCtx, int nPos, const IpcvDecodedImageStack& stack)
{
	int dims[4] = {stack.rows, stack.cols, stack.channels, stack.pages};
	const int outVar = nbInputArgument(pvApiCtx) + nPos;
	const size_t elemBytes = ipcv_depth_size(stack.depth);
	const size_t expectedBytes = static_cast<size_t>(stack.rows) * stack.cols * stack.channels * stack.pages * elemBytes;
	SciErr sciErr;

	if (stack.rows <= 0 || stack.cols <= 0 || stack.channels <= 0 || stack.pages <= 0 || stack.data == NULL || elemBytes == 0 || stack.byte_count != expectedBytes)
	{
		Scierror(999, "IPCV: Invalid multipage image returned from C++ implementation.\n");
		return -1;
	}

	switch(stack.depth)
	{
	case IPCV_DEPTH_8U:
		sciErr = createHypermatOfUnsignedInteger8(pvApiCtx, outVar, dims, 4, stack.data);
		break;
	case IPCV_DEPTH_8S:
		sciErr = createHypermatOfInteger8(pvApiCtx, outVar, dims, 4, reinterpret_cast<const char*>(stack.data));
		break;
	case IPCV_DEPTH_16U:
		sciErr = createHypermatOfUnsignedInteger16(pvApiCtx, outVar, dims, 4, reinterpret_cast<const unsigned short*>(stack.data));
		break;
	case IPCV_DEPTH_16S:
		sciErr = createHypermatOfInteger16(pvApiCtx, outVar, dims, 4, reinterpret_cast<const short*>(stack.data));
		break;
	case IPCV_DEPTH_32S:
		sciErr = createHypermatOfInteger32(pvApiCtx, outVar, dims, 4, reinterpret_cast<const int*>(stack.data));
		break;
	case IPCV_DEPTH_64F:
		sciErr = createHypermatOfDouble(pvApiCtx, outVar, dims, 4, reinterpret_cast<const double*>(stack.data));
		break;
	default:
		Scierror(999, "IPCV: Unsupported multipage image depth %d.\n", stack.depth);
		return -1;
	}

	if (sciErr.iErr)
	{
		printError(&sciErr, 0);
		return sciErr.iErr;
	}

	AssignOutputVariable(pvApiCtx, nPos) = outVar;
	return 0;
}

static int ipcv_get_image_from_address(void* pvApiCtx, int *piAddr, IpcvDecodedImage& image)
{
	SciErr sciErr;
	int precision = 0;
	int *dims = NULL;
	int ndims = 0;
	int iRows = 0;
	int iCols = 0;

	memset(&image, 0, sizeof(image));
	if (isHypermatType(pvApiCtx, piAddr))
	{
		sciErr = getHypermatType(pvApiCtx, piAddr, &precision);
		if (sciErr.iErr)
		{
			printError(&sciErr, 0);
			return sciErr.iErr;
		}

		if (precision == sci_matrix)
		{
			double *data = NULL;
			sciErr = getHypermatOfDouble(pvApiCtx, piAddr, &dims, &ndims, &data);
			if (sciErr.iErr)
			{
				printError(&sciErr, 0);
				return sciErr.iErr;
			}
			image.data = reinterpret_cast<unsigned char*>(data);
			image.depth = IPCV_DEPTH_64F;
		}
		else if (precision == sci_boolean)
		{
			int *data = NULL;
			sciErr = getHypermatOfBoolean(pvApiCtx, piAddr, &dims, &ndims, &data);
			if (sciErr.iErr)
			{
				printError(&sciErr, 0);
				return sciErr.iErr;
			}
			if (ndims < 2 || ndims > 3)
			{
				return -1;
			}
			return ipcv_set_boolean_image(image, dims[0], dims[1], ndims == 3 ? dims[2] : 1, data);
		}
		else if (precision == sci_ints)
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
				image.data = data;
				image.depth = IPCV_DEPTH_8U;
			}
			else if (precision == SCI_INT8)
			{
				char *data = NULL;
				sciErr = getHypermatOfInteger8(pvApiCtx, piAddr, &dims, &ndims, &data);
				image.data = reinterpret_cast<unsigned char*>(data);
				image.depth = IPCV_DEPTH_8S;
			}
			else if (precision == SCI_UINT16)
			{
				unsigned short *data = NULL;
				sciErr = getHypermatOfUnsignedInteger16(pvApiCtx, piAddr, &dims, &ndims, &data);
				image.data = reinterpret_cast<unsigned char*>(data);
				image.depth = IPCV_DEPTH_16U;
			}
			else if (precision == SCI_INT16)
			{
				short *data = NULL;
				sciErr = getHypermatOfInteger16(pvApiCtx, piAddr, &dims, &ndims, &data);
				image.data = reinterpret_cast<unsigned char*>(data);
				image.depth = IPCV_DEPTH_16S;
			}
			else if (precision == SCI_INT32)
			{
				int *data = NULL;
				sciErr = getHypermatOfInteger32(pvApiCtx, piAddr, &dims, &ndims, &data);
				image.data = reinterpret_cast<unsigned char*>(data);
				image.depth = IPCV_DEPTH_32S;
			}
			else
			{
				return -1;
			}
			if (sciErr.iErr)
			{
				printError(&sciErr, 0);
				return sciErr.iErr;
			}
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
		image.channels = ndims == 3 ? dims[2] : 1;
		return ipcv_fill_image_metadata(image);
	}

	sciErr = getVarType(pvApiCtx, piAddr, &precision);
	if (sciErr.iErr)
	{
		printError(&sciErr, 0);
		return sciErr.iErr;
	}

	if (precision == sci_matrix)
	{
		double *data = NULL;
		sciErr = getMatrixOfDouble(pvApiCtx, piAddr, &iRows, &iCols, &data);
		if (sciErr.iErr)
		{
			printError(&sciErr, 0);
			return sciErr.iErr;
		}
		image.rows = iRows;
		image.cols = iCols;
		image.channels = 1;
		image.depth = IPCV_DEPTH_64F;
		image.data = reinterpret_cast<unsigned char*>(data);
		return ipcv_fill_image_metadata(image);
	}

	if (precision == sci_boolean)
	{
		int *data = NULL;
		sciErr = getMatrixOfBoolean(pvApiCtx, piAddr, &iRows, &iCols, &data);
		if (sciErr.iErr)
		{
			printError(&sciErr, 0);
			return sciErr.iErr;
		}
		return ipcv_set_boolean_image(image, iRows, iCols, 1, data);
	}

	if (precision != sci_ints)
	{
		return -1;
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
		sciErr = getMatrixOfUnsignedInteger8(pvApiCtx, piAddr, &iRows, &iCols, &data);
		image.data = data;
		image.depth = IPCV_DEPTH_8U;
	}
	else if (precision == SCI_INT8)
	{
		char *data = NULL;
		sciErr = getMatrixOfInteger8(pvApiCtx, piAddr, &iRows, &iCols, &data);
		image.data = reinterpret_cast<unsigned char*>(data);
		image.depth = IPCV_DEPTH_8S;
	}
	else if (precision == SCI_UINT16)
	{
		unsigned short *data = NULL;
		sciErr = getMatrixOfUnsignedInteger16(pvApiCtx, piAddr, &iRows, &iCols, &data);
		image.data = reinterpret_cast<unsigned char*>(data);
		image.depth = IPCV_DEPTH_16U;
	}
	else if (precision == SCI_INT16)
	{
		short *data = NULL;
		sciErr = getMatrixOfInteger16(pvApiCtx, piAddr, &iRows, &iCols, &data);
		image.data = reinterpret_cast<unsigned char*>(data);
		image.depth = IPCV_DEPTH_16S;
	}
	else if (precision == SCI_INT32)
	{
		int *data = NULL;
		sciErr = getMatrixOfInteger32(pvApiCtx, piAddr, &iRows, &iCols, &data);
		image.data = reinterpret_cast<unsigned char*>(data);
		image.depth = IPCV_DEPTH_32S;
	}
	else
	{
		return -1;
	}

	if (sciErr.iErr)
	{
		printError(&sciErr, 0);
		return sciErr.iErr;
	}
	image.rows = iRows;
	image.cols = iCols;
	image.channels = 1;
	return ipcv_fill_image_metadata(image);
}

int ipcv_get_image_list_argument(void* pvApiCtx, int nPos, IpcvImageList& list)
{
	SciErr sciErr;
	int *listAddr = NULL;
	int itemCount = 0;

	memset(&list, 0, sizeof(list));
	sciErr = getVarAddressFromPosition(pvApiCtx, nPos, &listAddr);
	if (sciErr.iErr)
	{
		printError(&sciErr, 0);
		return sciErr.iErr;
	}

	sciErr = getListItemNumber(pvApiCtx, listAddr, &itemCount);
	if (sciErr.iErr)
	{
		printError(&sciErr, 0);
		return sciErr.iErr;
	}
	if (itemCount <= 0)
	{
		return -1;
	}

	list.count = itemCount;
	list.images = static_cast<IpcvDecodedImage*>(calloc(static_cast<size_t>(itemCount), sizeof(IpcvDecodedImage)));
	if (list.images == NULL)
	{
		strncpy(list.error, "out of memory", sizeof(list.error) - 1);
		return -1;
	}

	for (int item = 0; item < itemCount; item++)
	{
		int *itemAddr = NULL;
		sciErr = getListItemAddress(pvApiCtx, listAddr, item + 1, &itemAddr);
		if (sciErr.iErr)
		{
			printError(&sciErr, 0);
			ipcv_release_image_list_argument(list);
			return sciErr.iErr;
		}

		int iRet = ipcv_get_image_from_address(pvApiCtx, itemAddr, list.images[item]);
		if (iRet)
		{
			strncpy(list.error, "list item is not an image", sizeof(list.error) - 1);
			ipcv_release_image_list_argument(list);
			return iRet;
		}
	}

	return 0;
}

void ipcv_release_image_list_argument(IpcvImageList& list)
{
	if (list.images != NULL)
	{
		for (int item = 0; item < list.count; item++)
		{
			ipcv_release_image_argument(list.images[item]);
		}
		free(list.images);
	}
	list.images = NULL;
	list.count = 0;
}

int ipcv_get_contour_list_argument(void* pvApiCtx, int nPos, IpcvContourList& list)
{
	SciErr sciErr;
	int *listAddr = NULL;
	int itemCount = 0;
	int columns = -1;
	size_t totalValues = 0;
	std::vector<int> rowCounts;
	std::vector<std::vector<double>> items;

	memset(&list, 0, sizeof(list));
	sciErr = getVarAddressFromPosition(pvApiCtx, nPos, &listAddr);
	if (sciErr.iErr)
	{
		printError(&sciErr, 0);
		return sciErr.iErr;
	}

	sciErr = getListItemNumber(pvApiCtx, listAddr, &itemCount);
	if (sciErr.iErr)
	{
		printError(&sciErr, 0);
		return sciErr.iErr;
	}

	rowCounts.resize(itemCount);
	items.resize(itemCount);
	for (int item = 0; item < itemCount; item++)
	{
		int *itemAddr = NULL;
		int rows = 0;
		int cols = 0;
		double *data = NULL;

		sciErr = getListItemAddress(pvApiCtx, listAddr, item + 1, &itemAddr);
		if (sciErr.iErr)
		{
			printError(&sciErr, 0);
			return sciErr.iErr;
		}
		sciErr = getMatrixOfDoubleInList(pvApiCtx, listAddr, item + 1, &rows, &cols, &data);
		if (sciErr.iErr)
		{
			printError(&sciErr, 0);
			return sciErr.iErr;
		}
		if (columns < 0)
		{
			columns = cols;
		}
		if (cols != columns || rows < 0)
		{
			return -1;
		}

		rowCounts[item] = rows;
		items[item].assign(data, data + static_cast<size_t>(rows) * cols);
		totalValues += static_cast<size_t>(rows) * cols;
	}

	list.count = itemCount;
	list.columns = columns < 0 ? 0 : columns;
	list.rows = static_cast<int*>(calloc(static_cast<size_t>(itemCount), sizeof(int)));
	list.data = static_cast<double*>(calloc(totalValues == 0 ? 1 : totalValues, sizeof(double)));
	if ((itemCount > 0 && list.rows == NULL) || list.data == NULL)
	{
		ipcv_release_contour_list_argument(list);
		return -1;
	}

	size_t offset = 0;
	for (int item = 0; item < itemCount; item++)
	{
		list.rows[item] = rowCounts[item];
		const size_t itemValues = static_cast<size_t>(rowCounts[item]) * list.columns;
		if (itemValues > 0)
		{
			memcpy(list.data + offset, items[item].data(), itemValues * sizeof(double));
		}
		offset += itemValues;
	}

	return 0;
}

void ipcv_release_contour_list_argument(IpcvContourList& list)
{
	free(list.rows);
	free(list.data);
	list.rows = NULL;
	list.data = NULL;
	list.count = 0;
	list.columns = 0;
}

int ipcv_set_contour_list_argument(void* pvApiCtx, int nPos, const IpcvContourList& list)
{
	SciErr sciErr;
	int *listAddr = NULL;
	const int outVar = nbInputArgument(pvApiCtx) + nPos;

	if (list.count < 0 || list.columns <= 0 || list.rows == NULL || list.data == NULL)
	{
		Scierror(999, "IPCV: Invalid contour list returned from C++ implementation.\n");
		return -1;
	}

	sciErr = createList(pvApiCtx, outVar, list.count, &listAddr);
	if (sciErr.iErr)
	{
		printError(&sciErr, 0);
		return sciErr.iErr;
	}

	size_t offset = 0;
	for (int item = 0; item < list.count; item++)
	{
		const int rows = list.rows[item];
		sciErr = createMatrixOfDoubleInList(pvApiCtx, outVar, listAddr, item + 1, rows, list.columns, list.data + offset);
		if (sciErr.iErr)
		{
			printError(&sciErr, 0);
			return sciErr.iErr;
		}
		offset += static_cast<size_t>(rows) * list.columns;
	}

	AssignOutputVariable(pvApiCtx, nPos) = outVar;
	return 0;
}

int ipcv_get_keypoint_matrix_argument(void* pvApiCtx, int nPos, IpcvKeypointMatrix& keypoints)
{
	SciErr sciErr;
	int *piAddr = NULL;
	int rows = 0;
	int cols = 0;
	double *data = NULL;

	memset(&keypoints, 0, sizeof(keypoints));
	sciErr = getVarAddressFromPosition(pvApiCtx, nPos, &piAddr);
	if (sciErr.iErr)
	{
		printError(&sciErr, 0);
		return sciErr.iErr;
	}

	sciErr = getMatrixOfDouble(pvApiCtx, piAddr, &rows, &cols, &data);
	if (sciErr.iErr)
	{
		printError(&sciErr, 0);
		return sciErr.iErr;
	}

	if (rows != 7 || cols < 0 || data == NULL)
	{
		return -1;
	}

	keypoints.rows = rows;
	keypoints.cols = cols;
	keypoints.data = data;
	return 0;
}

int ipcv_set_keypoint_matrix_argument(void* pvApiCtx, int nPos, const IpcvKeypointMatrix& keypoints)
{
	SciErr sciErr;
	const int outVar = nbInputArgument(pvApiCtx) + nPos;

	if (keypoints.rows != 7 || keypoints.cols < 0 || keypoints.data == NULL)
	{
		Scierror(999, "IPCV: Invalid keypoint matrix returned from C++ implementation.\n");
		return -1;
	}

	sciErr = createMatrixOfDouble(pvApiCtx, outVar, keypoints.rows, keypoints.cols, keypoints.data);
	if (sciErr.iErr)
	{
		printError(&sciErr, 0);
		return sciErr.iErr;
	}

	AssignOutputVariable(pvApiCtx, nPos) = outVar;
	return 0;
}

int ipcv_get_match_matrix_argument(void* pvApiCtx, int nPos, IpcvMatchMatrix& matches)
{
	SciErr sciErr;
	int *piAddr = NULL;
	int rows = 0;
	int cols = 0;
	double *data = NULL;

	memset(&matches, 0, sizeof(matches));
	sciErr = getVarAddressFromPosition(pvApiCtx, nPos, &piAddr);
	if (sciErr.iErr)
	{
		printError(&sciErr, 0);
		return sciErr.iErr;
	}

	sciErr = getMatrixOfDouble(pvApiCtx, piAddr, &rows, &cols, &data);
	if (sciErr.iErr)
	{
		printError(&sciErr, 0);
		return sciErr.iErr;
	}

	if (rows != 4 || cols < 0 || data == NULL)
	{
		return -1;
	}

	matches.rows = rows;
	matches.cols = cols;
	matches.data = data;
	return 0;
}

int ipcv_run_binary_arithmetic(char *fname, void* pvApiCtx, int operation)
{
	IpcvDecodedImage left;
	IpcvDecodedImage right;
	IpcvDecodedImage output;
	memset(&output, 0, sizeof(output));

	CheckInputArgument(pvApiCtx, 2, 2);
	CheckOutputArgument(pvApiCtx, 1, 1);

	int iRet = ipcv_get_image_argument(pvApiCtx, 1, left);
	if (iRet)
	{
		Scierror(999, "%s: Wrong type for input argument #%d: Image or scalar expected.\n", fname, 1);
		return iRet;
	}

	iRet = ipcv_get_image_argument(pvApiCtx, 2, right);
	if (iRet)
	{
		Scierror(999, "%s: Wrong type for input argument #%d: Image or scalar expected.\n", fname, 2);
		ipcv_release_image_argument(left);
		return iRet;
	}

	iRet = ipcv_binary_arithmetic(&left, &right, operation, &output);
	ipcv_release_image_argument(left);
	ipcv_release_image_argument(right);
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
