#define IPCV_CORE_EXPORTS
#include "ipcv_dicom.h"

#include <algorithm>
#include <cerrno>
#include <cmath>
#include <cstdlib>
#include <cstring>
#include <fstream>
#include <limits>
#include <string>
#include <vector>

namespace
{
const unsigned int UNDEFINED_LENGTH = 0xffffffffU;

struct Syntax
{
    bool explicit_vr;
    bool little_endian;
};

struct Element
{
    unsigned short group;
    unsigned short element;
    char vr[3];
    unsigned int length;
    size_t value_offset;
    size_t next_offset;
};

void set_error(IpcvVolume *volume, const std::string& message)
{
    if (volume == NULL) return;
    std::strncpy(volume->error, message.c_str(), sizeof(volume->error) - 1);
    volume->error[sizeof(volume->error) - 1] = 0;
}

unsigned short read_u16(const std::vector<unsigned char>& data,
    size_t offset, bool little_endian)
{
    if (little_endian)
        return static_cast<unsigned short>(data[offset] |
            (static_cast<unsigned short>(data[offset + 1]) << 8));
    return static_cast<unsigned short>(
        (static_cast<unsigned short>(data[offset]) << 8) | data[offset + 1]);
}

unsigned int read_u32(const std::vector<unsigned char>& data,
    size_t offset, bool little_endian)
{
    if (little_endian)
        return static_cast<unsigned int>(data[offset]) |
            (static_cast<unsigned int>(data[offset + 1]) << 8) |
            (static_cast<unsigned int>(data[offset + 2]) << 16) |
            (static_cast<unsigned int>(data[offset + 3]) << 24);
    return (static_cast<unsigned int>(data[offset]) << 24) |
        (static_cast<unsigned int>(data[offset + 1]) << 16) |
        (static_cast<unsigned int>(data[offset + 2]) << 8) |
        static_cast<unsigned int>(data[offset + 3]);
}

bool uses_long_explicit_length(const char vr[3])
{
    return std::strcmp(vr, "OB") == 0 || std::strcmp(vr, "OD") == 0 ||
        std::strcmp(vr, "OF") == 0 || std::strcmp(vr, "OL") == 0 ||
        std::strcmp(vr, "OV") == 0 || std::strcmp(vr, "OW") == 0 ||
        std::strcmp(vr, "SQ") == 0 || std::strcmp(vr, "UC") == 0 ||
        std::strcmp(vr, "UN") == 0 || std::strcmp(vr, "UR") == 0 ||
        std::strcmp(vr, "UT") == 0 || std::strcmp(vr, "SV") == 0 ||
        std::strcmp(vr, "UV") == 0;
}

bool parse_element(const std::vector<unsigned char>& data, size_t offset,
    const Syntax& syntax, Element& output)
{
    if (offset > data.size() || data.size() - offset < 8) return false;
    std::memset(&output, 0, sizeof(output));
    output.group = read_u16(data, offset, syntax.little_endian);
    output.element = read_u16(data, offset + 2, syntax.little_endian);

    if (output.group == 0xfffe || !syntax.explicit_vr)
    {
        output.length = read_u32(data, offset + 4, syntax.little_endian);
        output.value_offset = offset + 8;
    }
    else
    {
        output.vr[0] = static_cast<char>(data[offset + 4]);
        output.vr[1] = static_cast<char>(data[offset + 5]);
        output.vr[2] = 0;
        if (uses_long_explicit_length(output.vr))
        {
            if (data.size() - offset < 12) return false;
            output.length = read_u32(data, offset + 8, syntax.little_endian);
            output.value_offset = offset + 12;
        }
        else
        {
            output.length = read_u16(data, offset + 6, syntax.little_endian);
            output.value_offset = offset + 8;
        }
    }

    if (output.length == UNDEFINED_LENGTH)
    {
        output.next_offset = output.value_offset;
        return true;
    }
    if (output.value_offset > data.size() ||
        output.length > data.size() - output.value_offset)
        return false;
    output.next_offset = output.value_offset + output.length;
    return true;
}

bool skip_undefined_container(const std::vector<unsigned char>& data,
    size_t offset, const Syntax& syntax, unsigned short delimiter,
    size_t& next_offset)
{
    size_t cursor = offset;
    while (cursor < data.size())
    {
        Element nested;
        if (!parse_element(data, cursor, syntax, nested)) return false;
        if (nested.group == 0xfffe && nested.element == delimiter)
        {
            next_offset = nested.length == UNDEFINED_LENGTH ?
                nested.value_offset : nested.next_offset;
            return true;
        }
        if (nested.length == UNDEFINED_LENGTH)
        {
            const unsigned short nested_delimiter =
                nested.group == 0xfffe && nested.element == 0xe000 ?
                0xe00d : 0xe0dd;
            if (!skip_undefined_container(data, nested.value_offset, syntax,
                nested_delimiter, cursor))
                return false;
        }
        else
        {
            cursor = nested.next_offset;
        }
    }
    return false;
}

std::string text_value(const std::vector<unsigned char>& data,
    const Element& element)
{
    std::string value(reinterpret_cast<const char*>(&data[element.value_offset]),
        element.length);
    while (!value.empty() &&
        (value[value.size() - 1] == 0 || value[value.size() - 1] == ' '))
        value.erase(value.size() - 1);
    size_t first = 0;
    while (first < value.size() && value[first] == ' ') ++first;
    return value.substr(first);
}

double first_decimal(const std::string& value, double fallback)
{
    const size_t separator = value.find('\\');
    const std::string first = value.substr(0, separator);
    char *end = NULL;
    errno = 0;
    const double parsed = std::strtod(first.c_str(), &end);
    return errno == 0 && end != first.c_str() ? parsed : fallback;
}

int first_integer(const std::string& value, int fallback)
{
    char *end = NULL;
    errno = 0;
    const long parsed = std::strtol(value.c_str(), &end, 10);
    if (errno != 0 || end == value.c_str() ||
        parsed < std::numeric_limits<int>::min() ||
        parsed > std::numeric_limits<int>::max())
        return fallback;
    return static_cast<int>(parsed);
}

void decimal_pair(const std::string& value, double& first, double& second)
{
    const size_t separator = value.find('\\');
    first = first_decimal(value, first);
    if (separator != std::string::npos)
        second = first_decimal(value.substr(separator + 1), second);
}

void copy_text(char *destination, size_t capacity, const std::string& value)
{
    if (destination == NULL || capacity == 0) return;
    std::strncpy(destination, value.c_str(), capacity - 1);
    destination[capacity - 1] = 0;
}

bool is_supported_transfer_syntax(const std::string& uid, Syntax& syntax)
{
    if (uid.empty() || uid == "1.2.840.10008.1.2")
    {
        syntax.explicit_vr = false;
        syntax.little_endian = true;
        return true;
    }
    if (uid == "1.2.840.10008.1.2.1")
    {
        syntax.explicit_vr = true;
        syntax.little_endian = true;
        return true;
    }
    if (uid == "1.2.840.10008.1.2.2")
    {
        syntax.explicit_vr = true;
        syntax.little_endian = false;
        return true;
    }
    return false;
}

bool multiply_would_overflow(size_t left, size_t right)
{
    return right != 0 && left > std::numeric_limits<size_t>::max() / right;
}

double decode_stored_value(unsigned int encoded, int bits_stored,
    int high_bit, bool signed_pixels)
{
    const int shift = high_bit + 1 - bits_stored;
    const unsigned int shifted = shift > 0 ? encoded >> shift : encoded;
    const unsigned int mask = bits_stored == 32 ?
        0xffffffffU : ((1U << bits_stored) - 1U);
    const unsigned int stored = shifted & mask;
    if (!signed_pixels) return static_cast<double>(stored);
    const unsigned int sign = 1U << (bits_stored - 1);
    if ((stored & sign) == 0) return static_cast<double>(stored);
    return static_cast<double>(static_cast<long long>(stored) -
        (static_cast<long long>(1) << bits_stored));
}
}

extern "C" IPCV_CORE_API int ipcv_read_dicom(const char *filename,
    int apply_rescale, IpcvVolume *volume, IpcvDicomInfo *info)
{
    if (volume == NULL || info == NULL) return -1;
    std::memset(volume, 0, sizeof(*volume));
    std::memset(info, 0, sizeof(*info));
    info->frames = 1;
    info->samples_per_pixel = 1;
    info->rescale_slope = 1.0;
    info->window_center = std::numeric_limits<double>::quiet_NaN();
    info->window_width = std::numeric_limits<double>::quiet_NaN();
    info->pixel_spacing_row = std::numeric_limits<double>::quiet_NaN();
    info->pixel_spacing_col = std::numeric_limits<double>::quiet_NaN();
    info->slice_thickness = std::numeric_limits<double>::quiet_NaN();
    info->spacing_between_slices = std::numeric_limits<double>::quiet_NaN();

    if (filename == NULL || filename[0] == 0)
    {
        set_error(volume, "a DICOM filename is required");
        return -1;
    }

    std::ifstream stream(filename, std::ios::binary | std::ios::ate);
    if (!stream)
    {
        set_error(volume, std::string("cannot open DICOM file: ") + filename);
        return -1;
    }
    const std::streamoff file_size = stream.tellg();
    if (file_size <= 0 ||
        static_cast<unsigned long long>(file_size) >
            static_cast<unsigned long long>(std::numeric_limits<size_t>::max()))
    {
        set_error(volume, "invalid DICOM file size");
        return -1;
    }
    std::vector<unsigned char> data(static_cast<size_t>(file_size));
    stream.seekg(0, std::ios::beg);
    if (!stream.read(reinterpret_cast<char*>(data.data()), file_size))
    {
        set_error(volume, "could not read complete DICOM file");
        return -1;
    }

    const bool has_preamble = data.size() >= 132 &&
        std::memcmp(data.data() + 128, "DICM", 4) == 0;
    size_t dataset_offset = has_preamble ? 132 : 0;
    std::string transfer_syntax;
    if (has_preamble)
    {
        const Syntax meta_syntax = {true, true};
        size_t cursor = dataset_offset;
        while (cursor < data.size())
        {
            Element element;
            if (!parse_element(data, cursor, meta_syntax, element))
            {
                set_error(volume, "invalid DICOM file-meta element");
                return -1;
            }
            if (element.group != 0x0002)
            {
                dataset_offset = cursor;
                break;
            }
            if (element.element == 0x0010)
                transfer_syntax = text_value(data, element);
            cursor = element.next_offset;
            dataset_offset = cursor;
        }
        if (transfer_syntax.empty())
        {
            set_error(volume, "DICOM file meta does not contain Transfer Syntax UID");
            return -1;
        }
    }
    else
    {
        transfer_syntax = "1.2.840.10008.1.2";
    }
    copy_text(info->transfer_syntax_uid,
        sizeof(info->transfer_syntax_uid), transfer_syntax);

    Syntax syntax;
    if (!is_supported_transfer_syntax(transfer_syntax, syntax))
    {
        set_error(volume, std::string("unsupported compressed or deflated DICOM transfer syntax: ") +
            transfer_syntax);
        return -1;
    }

    size_t pixel_offset = 0;
    size_t pixel_length = 0;
    size_t cursor = dataset_offset;
    while (cursor < data.size())
    {
        Element element;
        if (!parse_element(data, cursor, syntax, element))
        {
            set_error(volume, "invalid DICOM dataset element");
            return -1;
        }
        const unsigned int tag =
            (static_cast<unsigned int>(element.group) << 16) | element.element;
        if (tag == 0x7fe00010U)
        {
            if (element.length == UNDEFINED_LENGTH)
            {
                set_error(volume, "encapsulated DICOM Pixel Data is not supported");
                return -1;
            }
            pixel_offset = element.value_offset;
            pixel_length = element.length;
            break;
        }

        if (element.length != UNDEFINED_LENGTH)
        {
            switch (tag)
            {
            case 0x00080016U:
                copy_text(info->sop_class_uid, sizeof(info->sop_class_uid),
                    text_value(data, element)); break;
            case 0x00080020U:
                copy_text(info->study_date, sizeof(info->study_date),
                    text_value(data, element)); break;
            case 0x00080060U:
                copy_text(info->modality, sizeof(info->modality),
                    text_value(data, element)); break;
            case 0x00080070U:
                copy_text(info->manufacturer, sizeof(info->manufacturer),
                    text_value(data, element)); break;
            case 0x00081030U:
                copy_text(info->study_description, sizeof(info->study_description),
                    text_value(data, element)); break;
            case 0x0008103eU:
                copy_text(info->series_description, sizeof(info->series_description),
                    text_value(data, element)); break;
            case 0x00100010U:
                copy_text(info->patient_name, sizeof(info->patient_name),
                    text_value(data, element)); break;
            case 0x00100020U:
                copy_text(info->patient_id, sizeof(info->patient_id),
                    text_value(data, element)); break;
            case 0x00180050U:
                info->slice_thickness = first_decimal(text_value(data, element),
                    info->slice_thickness); break;
            case 0x00180088U:
                info->spacing_between_slices = first_decimal(
                    text_value(data, element), info->spacing_between_slices); break;
            case 0x0020000dU:
                copy_text(info->study_instance_uid, sizeof(info->study_instance_uid),
                    text_value(data, element)); break;
            case 0x0020000eU:
                copy_text(info->series_instance_uid, sizeof(info->series_instance_uid),
                    text_value(data, element)); break;
            case 0x00280002U:
                if (element.length >= 2)
                    info->samples_per_pixel = read_u16(data, element.value_offset,
                        syntax.little_endian);
                break;
            case 0x00280004U:
                copy_text(info->photometric_interpretation,
                    sizeof(info->photometric_interpretation),
                    text_value(data, element)); break;
            case 0x00280006U:
                if (element.length >= 2)
                    info->planar_configuration = read_u16(data, element.value_offset,
                        syntax.little_endian);
                break;
            case 0x00280008U:
                info->frames = first_integer(text_value(data, element), 1); break;
            case 0x00280010U:
                if (element.length >= 2)
                    info->rows = read_u16(data, element.value_offset,
                        syntax.little_endian);
                break;
            case 0x00280011U:
                if (element.length >= 2)
                    info->cols = read_u16(data, element.value_offset,
                        syntax.little_endian);
                break;
            case 0x00280030U:
                decimal_pair(text_value(data, element), info->pixel_spacing_row,
                    info->pixel_spacing_col); break;
            case 0x00280100U:
                if (element.length >= 2)
                    info->bits_allocated = read_u16(data, element.value_offset,
                        syntax.little_endian);
                break;
            case 0x00280101U:
                if (element.length >= 2)
                    info->bits_stored = read_u16(data, element.value_offset,
                        syntax.little_endian);
                break;
            case 0x00280102U:
                if (element.length >= 2)
                    info->high_bit = read_u16(data, element.value_offset,
                        syntax.little_endian);
                break;
            case 0x00280103U:
                if (element.length >= 2)
                    info->pixel_representation = read_u16(data, element.value_offset,
                        syntax.little_endian);
                break;
            case 0x00281050U:
                info->window_center = first_decimal(text_value(data, element),
                    info->window_center); break;
            case 0x00281051U:
                info->window_width = first_decimal(text_value(data, element),
                    info->window_width); break;
            case 0x00281052U:
                info->rescale_intercept = first_decimal(text_value(data, element),
                    0.0); break;
            case 0x00281053U:
                info->rescale_slope = first_decimal(text_value(data, element),
                    1.0); break;
            default: break;
            }
            cursor = element.next_offset;
        }
        else
        {
            if (!skip_undefined_container(data, element.value_offset, syntax,
                0xe0dd, cursor))
            {
                set_error(volume, "unterminated undefined-length DICOM sequence");
                return -1;
            }
        }
    }

    if (pixel_offset == 0)
    {
        set_error(volume, "DICOM file does not contain uncompressed Pixel Data");
        return -1;
    }
    if (info->rows <= 0 || info->cols <= 0 || info->frames <= 0)
    {
        set_error(volume, "DICOM Rows, Columns, or Number of Frames is invalid");
        return -1;
    }
    if (info->samples_per_pixel != 1)
    {
        set_error(volume, "only single-sample grayscale DICOM images are supported");
        return -1;
    }
    const std::string photometric(info->photometric_interpretation);
    if (photometric != "MONOCHROME1" && photometric != "MONOCHROME2")
    {
        set_error(volume, std::string("unsupported DICOM photometric interpretation: ") +
            photometric);
        return -1;
    }
    if (info->bits_allocated != 8 && info->bits_allocated != 16)
    {
        set_error(volume, "only 8-bit and 16-bit DICOM pixels are supported");
        return -1;
    }
    if (info->bits_stored <= 0 ||
        info->bits_stored > info->bits_allocated ||
        info->high_bit < info->bits_stored - 1 ||
        info->high_bit >= info->bits_allocated)
    {
        set_error(volume, "invalid DICOM stored-bit metadata");
        return -1;
    }

    size_t voxel_count = static_cast<size_t>(info->rows);
    if (multiply_would_overflow(voxel_count, static_cast<size_t>(info->cols)) ||
        multiply_would_overflow(voxel_count * info->cols,
            static_cast<size_t>(info->frames)))
    {
        set_error(volume, "DICOM dimensions are too large");
        return -1;
    }
    voxel_count *= static_cast<size_t>(info->cols);
    voxel_count *= static_cast<size_t>(info->frames);
    const size_t bytes_per_pixel = static_cast<size_t>(info->bits_allocated / 8);
    if (multiply_would_overflow(voxel_count, bytes_per_pixel) ||
        voxel_count * bytes_per_pixel > pixel_length)
    {
        set_error(volume, "DICOM Pixel Data is shorter than its declared dimensions");
        return -1;
    }
    if (multiply_would_overflow(voxel_count, sizeof(double)))
    {
        set_error(volume, "DICOM output volume is too large");
        return -1;
    }

    volume->rows = info->rows;
    volume->cols = info->cols;
    volume->slices = info->frames;
    volume->depth = IPCV_DEPTH_64F;
    volume->byte_count = voxel_count * sizeof(double);
    volume->data = static_cast<unsigned char*>(std::malloc(volume->byte_count));
    if (volume->data == NULL)
    {
        set_error(volume, "out of memory while decoding DICOM Pixel Data");
        return -1;
    }
    volume->owns_data = 1;
    double *output = reinterpret_cast<double*>(volume->data);
    info->raw_minimum = std::numeric_limits<double>::infinity();
    info->raw_maximum = -std::numeric_limits<double>::infinity();

    const bool signed_pixels = info->pixel_representation != 0;
    const size_t frame_pixels =
        static_cast<size_t>(info->rows) * info->cols;
    for (int frame = 0; frame < info->frames; ++frame)
        for (int row = 0; row < info->rows; ++row)
            for (int col = 0; col < info->cols; ++col)
            {
                const size_t source_index =
                    static_cast<size_t>(frame) * frame_pixels +
                    static_cast<size_t>(row) * info->cols + col;
                const size_t byte_offset =
                    pixel_offset + source_index * bytes_per_pixel;
                const unsigned int encoded = info->bits_allocated == 8 ?
                    data[byte_offset] :
                    read_u16(data, byte_offset, syntax.little_endian);
                const double raw = decode_stored_value(encoded,
                    info->bits_stored, info->high_bit, signed_pixels);
                info->raw_minimum = std::min(info->raw_minimum, raw);
                info->raw_maximum = std::max(info->raw_maximum, raw);
                const double value = apply_rescale ?
                    raw * info->rescale_slope + info->rescale_intercept : raw;
                const size_t destination_index =
                    static_cast<size_t>(row) +
                    static_cast<size_t>(info->rows) *
                        (col + static_cast<size_t>(info->cols) * frame);
                output[destination_index] = value;
            }

    info->rescale_applied = apply_rescale ? 1 : 0;
    return 0;
}
