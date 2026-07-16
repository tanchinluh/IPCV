/***********************************************************************
 * IPCV - Scilab Image Processing and Computer Vision toolbox
 * Copyright (C) 2026  Tan Chin Luh
***********************************************************************/

#include "ipcv_gateway_common.h"
#include "ipcv_gateway_image.h"

#include <cstdio>
#include <fstream>
#include <iterator>
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
}

int sci_int_imvideoexportframe(char *fname, void* pvApiCtx)
{
    CheckInputArgument(pvApiCtx, 3, 3);
    CheckOutputArgument(pvApiCtx, 0, 1);

    double *handle_value = NULL;
    double *frame_value = NULL;
    char *filename = NULL;
    int rows = 0;
    int columns = 0;
    GetDouble(1, handle_value, rows, columns, pvApiCtx);
    GetDouble(2, frame_value, rows, columns, pvApiCtx);
    GetString(3, filename, pvApiCtx);

    char error[1024] = {0};
    const int result = ipcv_avi_export_frame(
        static_cast<int>(*handle_value),
        static_cast<int>(*frame_value),
        filename,
        error,
        static_cast<int>(sizeof(error)));
    if (result != 0)
    {
        Scierror(999, "%s: %s.\r\n", fname, error);
        return result;
    }

    std::ifstream stream(filename, std::ios::binary);
    if (!stream)
    {
        Scierror(999, "%s: Could not read the exported PNG frame.\r\n", fname);
        return -1;
    }
    const std::vector<unsigned char> bytes(
        (std::istreambuf_iterator<char>(stream)),
        std::istreambuf_iterator<char>());
    stream.close();
    std::remove(filename);
    if (bytes.empty())
    {
        Scierror(999, "%s: The exported PNG frame is empty.\r\n", fname);
        return -1;
    }

    const std::string uri = "data:image/png;base64," + encode_base64(bytes);
    const int out_var = nbInputArgument(pvApiCtx) + 1;
    const int output_status = createSingleString(pvApiCtx, out_var, uri.c_str());
    if (output_status)
    {
        Scierror(999, "%s: Could not create the encoded frame output.\r\n", fname);
        return output_status;
    }
    AssignOutputVariable(pvApiCtx, 1) = out_var;
    ReturnArguments(pvApiCtx);
    return 0;
}
