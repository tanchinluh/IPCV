#include "ipcv_gateway_volume.h"

#include <algorithm>
#include <cmath>
#include <limits>
#include <string>
#include <vector>

namespace
{
std::string encode_base64(const std::vector<unsigned char>& bytes)
{
    static const char alphabet[] =
        "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";
    std::string encoded;
    encoded.reserve(((bytes.size() + 2) / 3) * 4);

    size_t offset = 0;
    while (offset + 3 <= bytes.size())
    {
        const unsigned int value =
            (static_cast<unsigned int>(bytes[offset]) << 16) |
            (static_cast<unsigned int>(bytes[offset + 1]) << 8) |
            static_cast<unsigned int>(bytes[offset + 2]);
        encoded.push_back(alphabet[(value >> 18) & 0x3f]);
        encoded.push_back(alphabet[(value >> 12) & 0x3f]);
        encoded.push_back(alphabet[(value >> 6) & 0x3f]);
        encoded.push_back(alphabet[value & 0x3f]);
        offset += 3;
    }

    const size_t remaining = bytes.size() - offset;
    if (remaining == 1)
    {
        const unsigned int value = static_cast<unsigned int>(bytes[offset]) << 16;
        encoded.push_back(alphabet[(value >> 18) & 0x3f]);
        encoded.push_back(alphabet[(value >> 12) & 0x3f]);
        encoded.append("==");
    }
    else if (remaining == 2)
    {
        const unsigned int value =
            (static_cast<unsigned int>(bytes[offset]) << 16) |
            (static_cast<unsigned int>(bytes[offset + 1]) << 8);
        encoded.push_back(alphabet[(value >> 18) & 0x3f]);
        encoded.push_back(alphabet[(value >> 12) & 0x3f]);
        encoded.push_back(alphabet[(value >> 6) & 0x3f]);
        encoded.push_back('=');
    }
    return encoded;
}

double voxel_value(const IpcvVolume& volume, size_t index)
{
    switch (volume.depth)
    {
    case IPCV_DEPTH_8U:
        return reinterpret_cast<const unsigned char*>(volume.data)[index];
    case IPCV_DEPTH_8S:
        return reinterpret_cast<const signed char*>(volume.data)[index];
    case IPCV_DEPTH_16U:
        return reinterpret_cast<const unsigned short*>(volume.data)[index];
    case IPCV_DEPTH_16S:
        return reinterpret_cast<const short*>(volume.data)[index];
    case IPCV_DEPTH_32S:
        return reinterpret_cast<const int*>(volume.data)[index];
    case IPCV_DEPTH_32F:
        return reinterpret_cast<const float*>(volume.data)[index];
    case IPCV_DEPTH_64F:
        return reinterpret_cast<const double*>(volume.data)[index];
    default:
        return std::numeric_limits<double>::quiet_NaN();
    }
}

int nearest_source_index(int output_index, int output_size, int source_size)
{
    const double coordinate =
        (static_cast<double>(output_index) + 0.5) * source_size / output_size - 0.5;
    return std::max(0, std::min(source_size - 1,
        static_cast<int>(std::floor(coordinate + 0.5))));
}
}

extern "C" int sci_int_volshowencode(char *fname, void *pvApiCtx)
{
    CheckInputArgument(pvApiCtx, 4, 4);
    CheckOutputArgument(pvApiCtx, 1, 3);

    IpcvVolume source;
    int result = ipcv_get_volume_argument(pvApiCtx, 1, source);
    if (result)
    {
        Scierror(999, "%s: input must be a supported 3-D scalar volume.\n", fname);
        return result;
    }

    int rows = 0;
    int columns = 0;
    double *quality_value = NULL;
    double *window_values = NULL;
    double *invert_value = NULL;
    GetDouble(2, quality_value, rows, columns, pvApiCtx);
    if (rows * columns != 1)
    {
        ipcv_release_volume_argument(source);
        Scierror(999, "%s: quality must be a scalar maximum texture dimension.\n", fname);
        return -1;
    }
    GetDouble(3, window_values, rows, columns, pvApiCtx);
    if (rows * columns != 2)
    {
        ipcv_release_volume_argument(source);
        Scierror(999, "%s: window must contain [low high].\n", fname);
        return -1;
    }
    GetDouble(4, invert_value, rows, columns, pvApiCtx);
    if (rows * columns != 1)
    {
        ipcv_release_volume_argument(source);
        Scierror(999, "%s: invert must be a scalar.\n", fname);
        return -1;
    }

    const int max_dimension = std::max(32, std::min(256,
        static_cast<int>(std::round(*quality_value))));
    const size_t source_count = static_cast<size_t>(source.rows) *
        source.cols * source.slices;
    double source_min = std::numeric_limits<double>::infinity();
    double source_max = -std::numeric_limits<double>::infinity();
    for (size_t index = 0; index < source_count; ++index)
    {
        const double value = voxel_value(source, index);
        if (std::isfinite(value))
        {
            source_min = std::min(source_min, value);
            source_max = std::max(source_max, value);
        }
    }
    if (!std::isfinite(source_min) || !std::isfinite(source_max))
    {
        ipcv_release_volume_argument(source);
        Scierror(999, "%s: volume has no finite intensity values.\n", fname);
        return -1;
    }

    double low = window_values[0];
    double high = window_values[1];
    if (!std::isfinite(low) || !std::isfinite(high) || high <= low)
    {
        low = source_min;
        high = source_max;
    }
    if (high <= low) high = low + 1.0;

    const int largest = std::max(source.rows, std::max(source.cols, source.slices));
    const double scale = largest > max_dimension
        ? static_cast<double>(max_dimension) / largest : 1.0;
    const int output_rows = std::max(1,
        static_cast<int>(std::round(source.rows * scale)));
    const int output_cols = std::max(1,
        static_cast<int>(std::round(source.cols * scale)));
    const int output_slices = std::max(1,
        static_cast<int>(std::round(source.slices * scale)));

    std::vector<unsigned char> voxels;
    voxels.reserve(static_cast<size_t>(output_rows) * output_cols * output_slices);
    const bool invert = *invert_value != 0.0;
    for (int z = 0; z < output_slices; ++z)
    {
        const int source_z = nearest_source_index(z, output_slices, source.slices);
        for (int row = 0; row < output_rows; ++row)
        {
            const int source_row = nearest_source_index(row, output_rows, source.rows);
            for (int col = 0; col < output_cols; ++col)
            {
                const int source_col = nearest_source_index(col, output_cols, source.cols);
                const size_t source_index = static_cast<size_t>(source_row) +
                    static_cast<size_t>(source_col) * source.rows +
                    static_cast<size_t>(source_z) * source.rows * source.cols;
                double value = voxel_value(source, source_index);
                if (!std::isfinite(value)) value = low;
                value = std::max(0.0, std::min(1.0, (value - low) / (high - low)));
                unsigned char encoded = static_cast<unsigned char>(std::round(value * 255.0));
                if (invert) encoded = static_cast<unsigned char>(255 - encoded);
                voxels.push_back(encoded);
            }
        }
    }
    ipcv_release_volume_argument(source);

    const std::string uri =
        "data:application/octet-stream;base64," + encode_base64(voxels);
    const int first_output = nbInputArgument(pvApiCtx) + 1;
    result = createSingleString(pvApiCtx, first_output, uri.c_str());
    if (result)
    {
        Scierror(999, "%s: could not create encoded volume output.\n", fname);
        return result;
    }

    double dimensions[3] = {
        static_cast<double>(output_rows),
        static_cast<double>(output_cols),
        static_cast<double>(output_slices)
    };
    SciErr error = createMatrixOfDouble(
        pvApiCtx, first_output + 1, 1, 3, dimensions);
    if (error.iErr)
    {
        printError(&error, 0);
        return error.iErr;
    }
    double ranges[4] = {source_min, source_max, low, high};
    error = createMatrixOfDouble(pvApiCtx, first_output + 2, 1, 4, ranges);
    if (error.iErr)
    {
        printError(&error, 0);
        return error.iErr;
    }

    AssignOutputVariable(pvApiCtx, 1) = first_output;
    AssignOutputVariable(pvApiCtx, 2) = first_output + 1;
    AssignOutputVariable(pvApiCtx, 3) = first_output + 2;
    ReturnArguments(pvApiCtx);
    return 0;
}
