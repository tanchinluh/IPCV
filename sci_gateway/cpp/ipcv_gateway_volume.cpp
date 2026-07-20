#include "ipcv_gateway_volume.h"

#include <cstring>
#include <vector>

namespace
{
size_t volume_depth_size(int depth)
{
    switch (depth)
    {
    case IPCV_DEPTH_8U:
    case IPCV_DEPTH_8S: return 1;
    case IPCV_DEPTH_16U:
    case IPCV_DEPTH_16S: return 2;
    case IPCV_DEPTH_32S:
    case IPCV_DEPTH_32F: return 4;
    case IPCV_DEPTH_64F: return 8;
    default: return 0;
    }
}

int set_metadata(IpcvVolume& volume, int *dims, int ndims)
{
    if (dims == NULL || ndims != 3 || dims[0] <= 0 || dims[1] <= 0 || dims[2] <= 0)
        return -1;
    volume.rows = dims[0];
    volume.cols = dims[1];
    volume.slices = dims[2];
    const size_t element_size = volume_depth_size(volume.depth);
    if (element_size == 0 || volume.data == NULL) return -1;
    volume.byte_count = static_cast<size_t>(volume.rows) * volume.cols *
        volume.slices * element_size;
    return 0;
}
}

int ipcv_get_volume_argument(void *pvApiCtx, int position, IpcvVolume& volume)
{
    std::memset(&volume, 0, sizeof(volume));
    int *address = NULL;
    SciErr error = getVarAddressFromPosition(pvApiCtx, position, &address);
    if (error.iErr)
    {
        printError(&error, 0);
        return error.iErr;
    }
    if (!isHypermatType(pvApiCtx, address)) return -1;

    int type = 0;
    error = getHypermatType(pvApiCtx, address, &type);
    if (error.iErr)
    {
        printError(&error, 0);
        return error.iErr;
    }

    int *dims = NULL;
    int ndims = 0;
    if (type == sci_matrix)
    {
        double *data = NULL;
        error = getHypermatOfDouble(pvApiCtx, address, &dims, &ndims, &data);
        volume.depth = IPCV_DEPTH_64F;
        volume.data = reinterpret_cast<unsigned char*>(data);
    }
    else if (type == sci_boolean)
    {
        int *data = NULL;
        error = getHypermatOfBoolean(pvApiCtx, address, &dims, &ndims, &data);
        if (!error.iErr && ndims == 3)
        {
            const size_t count = static_cast<size_t>(dims[0]) * dims[1] * dims[2];
            volume.data = static_cast<unsigned char*>(std::malloc(count));
            if (volume.data == NULL) return -1;
            for (size_t i = 0; i < count; ++i) volume.data[i] = data[i] ? 1 : 0;
            volume.depth = IPCV_DEPTH_8U;
            volume.owns_data = 1;
        }
    }
    else if (type == sci_ints)
    {
        int precision = 0;
        error = getHypermatOfIntegerPrecision(pvApiCtx, address, &precision);
        if (error.iErr)
        {
            printError(&error, 0);
            return error.iErr;
        }
        if (precision == SCI_UINT8)
        {
            unsigned char *data = NULL;
            error = getHypermatOfUnsignedInteger8(pvApiCtx, address, &dims, &ndims, &data);
            volume.depth = IPCV_DEPTH_8U;
            volume.data = data;
        }
        else if (precision == SCI_INT8)
        {
            char *data = NULL;
            error = getHypermatOfInteger8(pvApiCtx, address, &dims, &ndims, &data);
            volume.depth = IPCV_DEPTH_8S;
            volume.data = reinterpret_cast<unsigned char*>(data);
        }
        else if (precision == SCI_UINT16)
        {
            unsigned short *data = NULL;
            error = getHypermatOfUnsignedInteger16(pvApiCtx, address, &dims, &ndims, &data);
            volume.depth = IPCV_DEPTH_16U;
            volume.data = reinterpret_cast<unsigned char*>(data);
        }
        else if (precision == SCI_INT16)
        {
            short *data = NULL;
            error = getHypermatOfInteger16(pvApiCtx, address, &dims, &ndims, &data);
            volume.depth = IPCV_DEPTH_16S;
            volume.data = reinterpret_cast<unsigned char*>(data);
        }
        else if (precision == SCI_INT32)
        {
            int *data = NULL;
            error = getHypermatOfInteger32(pvApiCtx, address, &dims, &ndims, &data);
            volume.depth = IPCV_DEPTH_32S;
            volume.data = reinterpret_cast<unsigned char*>(data);
        }
        else if (precision == SCI_UINT32)
        {
            unsigned int *data = NULL;
            error = getHypermatOfUnsignedInteger32(pvApiCtx, address, &dims, &ndims, &data);
            if (!error.iErr && ndims == 3)
            {
                const size_t count = static_cast<size_t>(dims[0]) * dims[1] * dims[2];
                int *converted = static_cast<int*>(std::malloc(count * sizeof(int)));
                if (converted == NULL) return -1;
                for (size_t i = 0; i < count; ++i)
                    converted[i] = data[i] > 2147483647U ? 2147483647 : static_cast<int>(data[i]);
                volume.depth = IPCV_DEPTH_32S;
                volume.data = reinterpret_cast<unsigned char*>(converted);
                volume.owns_data = 1;
            }
        }
        else
        {
            return -1;
        }
    }
    else
    {
        return -1;
    }

    if (error.iErr)
    {
        printError(&error, 0);
        ipcv_release_volume_argument(volume);
        return error.iErr;
    }
    if (set_metadata(volume, dims, ndims))
    {
        ipcv_release_volume_argument(volume);
        return -1;
    }
    return 0;
}

void ipcv_release_volume_argument(IpcvVolume& volume)
{
    if (volume.owns_data && volume.data != NULL) std::free(volume.data);
    std::memset(&volume, 0, sizeof(volume));
}

int ipcv_set_volume_argument(void *pvApiCtx, int position,
    const IpcvVolume& volume, int as_boolean)
{
    if (volume.rows <= 0 || volume.cols <= 0 || volume.slices <= 0 ||
        volume.data == NULL)
    {
        Scierror(999, "IPCV: Invalid volume returned from C++ implementation.\n");
        return -1;
    }

    int dims[3] = {volume.rows, volume.cols, volume.slices};
    const int output = nbInputArgument(pvApiCtx) + position;
    SciErr error;
    if (as_boolean)
    {
        const size_t count = static_cast<size_t>(volume.rows) * volume.cols * volume.slices;
        std::vector<int> values(count);
        for (size_t i = 0; i < count; ++i) values[i] = volume.data[i] != 0;
        error = createHypermatOfBoolean(pvApiCtx, output, dims, 3, values.data());
    }
    else if (volume.depth == IPCV_DEPTH_64F)
    {
        error = createHypermatOfDouble(pvApiCtx, output, dims, 3,
            reinterpret_cast<const double*>(volume.data));
    }
    else if (volume.depth == IPCV_DEPTH_8U)
    {
        error = createHypermatOfUnsignedInteger8(pvApiCtx, output, dims, 3, volume.data);
    }
    else
    {
        Scierror(999, "IPCV: Unsupported volume output depth %d.\n", volume.depth);
        return -1;
    }
    if (error.iErr)
    {
        printError(&error, 0);
        return error.iErr;
    }
    AssignOutputVariable(pvApiCtx, position) = output;
    return 0;
}
