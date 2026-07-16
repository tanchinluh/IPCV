/***********************************************************************
 * IPCV - Scilab Image Processing and Computer Vision toolbox
 * Browser imtool rendered-frame recorder.
 ***********************************************************************/

#include "ipcv_gateway_common.h"

#include <cctype>

namespace
{
struct ImtoolRecorder
{
    cv::VideoWriter writer;
    std::string filename;
    double fps = 0;
    int width = 0;
    int height = 0;
    int frames = 0;
    bool armed = false;
};

ImtoolRecorder recorder;

void reset_recorder()
{
    if (recorder.writer.isOpened())
    {
        recorder.writer.release();
    }
    recorder = ImtoolRecorder();
}

std::string lowercase_extension(const std::string& filename)
{
    const size_t dot = filename.find_last_of('.');
    std::string extension = dot == std::string::npos ? std::string() : filename.substr(dot);
    std::transform(extension.begin(), extension.end(), extension.begin(), [](unsigned char value) {
        return static_cast<char>(std::tolower(value));
    });
    return extension;
}

bool decode_base64(const char *text, std::vector<unsigned char>& bytes)
{
    if (text == NULL)
    {
        return false;
    }
    const char *payload = std::strchr(text, ',');
    payload = payload == NULL ? text : payload + 1;

    int table[256];
    std::fill(table, table + 256, -1);
    const char alphabet[] = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";
    for (int index = 0; index < 64; index++)
    {
        table[static_cast<unsigned char>(alphabet[index])] = index;
    }

    unsigned int accumulator = 0;
    int bits = -8;
    bytes.clear();
    bytes.reserve(std::strlen(payload) * 3 / 4);
    for (const unsigned char *cursor = reinterpret_cast<const unsigned char*>(payload); *cursor != 0; cursor++)
    {
        if (*cursor == '=')
        {
            break;
        }
        if (std::isspace(*cursor))
        {
            continue;
        }
        const int value = table[*cursor];
        if (value < 0)
        {
            return false;
        }
        accumulator = (accumulator << 6) | static_cast<unsigned int>(value);
        bits += 6;
        if (bits >= 0)
        {
            bytes.push_back(static_cast<unsigned char>((accumulator >> bits) & 0xff));
            bits -= 8;
        }
    }
    return !bytes.empty();
}

bool open_writer(const cv::Mat& image, std::string& error)
{
    recorder.width = image.cols + (image.cols % 2);
    recorder.height = image.rows + (image.rows % 2);
    const std::string extension = lowercase_extension(recorder.filename);
    const int fourcc = extension == ".avi"
        ? cv::VideoWriter::fourcc('M', 'J', 'P', 'G')
        : cv::VideoWriter::fourcc('m', 'p', '4', 'v');
    recorder.writer.open(
        recorder.filename,
        fourcc,
        recorder.fps,
        cv::Size(recorder.width, recorder.height),
        true);
    if (!recorder.writer.isOpened())
    {
        error = "OpenCV could not create the recording; use an MP4 or AVI filename supported by this build";
        return false;
    }
    return true;
}

int set_frame_count_output(void *pvApiCtx)
{
    const int out_var = nbInputArgument(pvApiCtx) + 1;
    const int status = createScalarDouble(pvApiCtx, out_var, static_cast<double>(recorder.frames));
    if (status)
    {
        return status;
    }
    AssignOutputVariable(pvApiCtx, 1) = out_var;
    ReturnArguments(pvApiCtx);
    return 0;
}
}

int sci_int_imtoolrecord(char *fname, void *pvApiCtx)
{
    CheckInputArgument(pvApiCtx, 1, 3);
    CheckOutputArgument(pvApiCtx, 0, 1);

    char *command_value = NULL;
    if (GetString(1, command_value, pvApiCtx) != 0)
    {
        Scierror(999, "%s: Command must be a scalar string.\n", fname);
        return -1;
    }
    const std::string command(command_value);
    freeAllocatedSingleString(command_value);

    if (command == "start")
    {
        if (nbInputArgument(pvApiCtx) != 3)
        {
            Scierror(999, "%s: start requires filename and frame rate.\n", fname);
            return -1;
        }
        char *filename_value = NULL;
        double *fps_value = NULL;
        int rows = 0;
        int columns = 0;
        if (GetString(2, filename_value, pvApiCtx) != 0 ||
            GetDouble(3, fps_value, rows, columns, pvApiCtx) != 0)
        {
            if (filename_value != NULL)
            {
                freeAllocatedSingleString(filename_value);
            }
            Scierror(999, "%s: Invalid recording filename or frame rate.\n", fname);
            return -1;
        }
        if (*fps_value <= 0)
        {
            freeAllocatedSingleString(filename_value);
            Scierror(999, "%s: Frame rate must be greater than zero.\n", fname);
            return -1;
        }
        reset_recorder();
        recorder.filename = filename_value;
        recorder.fps = *fps_value;
        recorder.armed = true;
        freeAllocatedSingleString(filename_value);
        return set_frame_count_output(pvApiCtx);
    }

    if (command == "frame")
    {
        if (nbInputArgument(pvApiCtx) != 2 || !recorder.armed)
        {
            Scierror(999, "%s: No imtool recording is active.\n", fname);
            return -1;
        }
        char *data_value = NULL;
        if (GetString(2, data_value, pvApiCtx) != 0)
        {
            Scierror(999, "%s: Rendered frame must be a PNG data URL.\n", fname);
            return -1;
        }
        std::vector<unsigned char> encoded;
        const bool decoded = decode_base64(data_value, encoded);
        freeAllocatedSingleString(data_value);
        if (!decoded)
        {
            Scierror(999, "%s: Could not decode the rendered frame data.\n", fname);
            return -1;
        }

        cv::Mat image = cv::imdecode(encoded, cv::IMREAD_COLOR);
        if (image.empty())
        {
            Scierror(999, "%s: OpenCV could not decode the rendered PNG frame.\n", fname);
            return -1;
        }
        if (!recorder.writer.isOpened())
        {
            std::string error;
            if (!open_writer(image, error))
            {
                reset_recorder();
                Scierror(999, "%s: %s.\n", fname, error.c_str());
                return -1;
            }
        }

        cv::Mat output;
        if (image.cols != recorder.width || image.rows != recorder.height)
        {
            cv::resize(image, output, cv::Size(recorder.width, recorder.height), 0, 0, cv::INTER_LINEAR);
        }
        else
        {
            output = image;
        }
        recorder.writer.write(output);
        recorder.frames++;
        return set_frame_count_output(pvApiCtx);
    }

    if (command == "stop")
    {
        const int frames = recorder.frames;
        if (recorder.writer.isOpened())
        {
            recorder.writer.release();
        }
        recorder.armed = false;
        recorder.frames = frames;
        const int status = set_frame_count_output(pvApiCtx);
        reset_recorder();
        return status;
    }

    Scierror(999, "%s: Unknown recording command '%s'.\n", fname, command.c_str());
    return -1;
}
