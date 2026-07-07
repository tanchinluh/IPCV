#define IPCV_CORE_EXPORTS
#include "ipcv_dnn.h"

#include <opencv2/core.hpp>
#include <opencv2/dnn.hpp>
#include <opencv2/dnn_superres.hpp>
#include <opencv2/imgproc.hpp>

#include <cstdlib>
#include <cstring>
#include <exception>
#include <limits>
#include <string>
#include <vector>

namespace
{
const int kMaxDnnModels = 3;

cv::dnn::Net g_nets[kMaxDnnModels];
cv::dnn_superres::DnnSuperResImpl g_superres[kMaxDnnModels];
bool g_superres_loaded[kMaxDnnModels] = {false, false, false};

void copy_error(char *destination, int destination_size, const char *message)
{
    if (destination == NULL || destination_size <= 0)
    {
        return;
    }
    std::strncpy(destination, message == NULL ? "" : message, static_cast<size_t>(destination_size) - 1);
    destination[destination_size - 1] = 0;
}

void set_tensor_error(IpcvDnnTensor *tensor, const char *message)
{
    if (tensor != NULL)
    {
        copy_error(tensor->error, static_cast<int>(sizeof(tensor->error)), message);
    }
}

void set_image_error(IpcvDecodedImage *image, const char *message)
{
    if (image != NULL)
    {
        copy_error(image->error, static_cast<int>(sizeof(image->error)), message);
    }
}

size_t depth_size(int depth)
{
    switch (depth)
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

void copy_scilab_layout_to_mat(const unsigned char *source, cv::Mat& destination)
{
    const int rows = destination.rows;
    const int cols = destination.cols;
    const int channels = destination.channels();
    const size_t elem_bytes = destination.elemSize1();

    for (int ch = 0; ch < channels; ch++)
    {
        int dst_ch = ch;
        if ((channels == 3 || channels == 4) && ch < 3)
        {
            dst_ch = 2 - ch;
        }

        for (int col = 0; col < cols; col++)
        {
            for (int row = 0; row < rows; row++)
            {
                const size_t src_offset = (static_cast<size_t>(ch) * rows * cols + static_cast<size_t>(col) * rows + row) * elem_bytes;
                unsigned char *dst = destination.ptr<unsigned char>(row) + ((col * channels + dst_ch) * elem_bytes);
                std::memcpy(dst, source + src_offset, elem_bytes);
            }
        }
    }
}

void copy_mat_to_scilab_layout(const cv::Mat& source, unsigned char *destination)
{
    const int rows = source.rows;
    const int cols = source.cols;
    const int channels = source.channels();
    const size_t elem_bytes = source.elemSize1();

    for (int ch = 0; ch < channels; ch++)
    {
        int src_ch = ch;
        if ((channels == 3 || channels == 4) && ch < 3)
        {
            src_ch = 2 - ch;
        }

        for (int col = 0; col < cols; col++)
        {
            for (int row = 0; row < rows; row++)
            {
                const unsigned char *src = source.ptr<unsigned char>(row) + ((col * channels + src_ch) * elem_bytes);
                const size_t dst_offset = (static_cast<size_t>(ch) * rows * cols + static_cast<size_t>(col) * rows + row) * elem_bytes;
                std::memcpy(destination + dst_offset, src, elem_bytes);
            }
        }
    }
}

bool image_to_mat(const IpcvDecodedImage& image, cv::Mat& mat, char *error, int error_size)
{
    const size_t elem_bytes = depth_size(image.depth);
    const size_t expected_bytes = static_cast<size_t>(image.rows) * image.cols * image.channels * elem_bytes;
    if (image.data == NULL || image.rows <= 0 || image.cols <= 0 || image.channels <= 0 || elem_bytes == 0 || image.byte_count != expected_bytes)
    {
        copy_error(error, error_size, "invalid image input");
        return false;
    }

    mat.create(image.rows, image.cols, CV_MAKETYPE(image.depth, image.channels));
    copy_scilab_layout_to_mat(image.data, mat);
    return true;
}

bool mat_to_image(const cv::Mat& mat, IpcvDecodedImage *image)
{
    if (image == NULL)
    {
        return false;
    }

    std::memset(image, 0, sizeof(*image));
    if (mat.empty() || mat.dims != 2)
    {
        set_image_error(image, "empty or unsupported image output");
        return false;
    }

    const size_t elem_bytes = depth_size(mat.depth());
    if (elem_bytes == 0)
    {
        set_image_error(image, "unsupported image depth");
        return false;
    }

    image->rows = mat.rows;
    image->cols = mat.cols;
    image->channels = mat.channels();
    image->depth = mat.depth();
    image->byte_count = mat.total() * mat.channels() * elem_bytes;
    image->data = static_cast<unsigned char*>(std::malloc(image->byte_count == 0 ? 1 : image->byte_count));
    if (image->data == NULL)
    {
        set_image_error(image, "out of memory");
        return false;
    }

    copy_mat_to_scilab_layout(mat, image->data);
    return true;
}

bool valid_handle(int handle)
{
    return handle >= 1 && handle <= kMaxDnnModels;
}

int first_free_net()
{
    for (int i = 0; i < kMaxDnnModels; i++)
    {
        if (g_nets[i].empty())
        {
            return i;
        }
    }
    return -1;
}

int first_free_superres()
{
    for (int i = 0; i < kMaxDnnModels; i++)
    {
        if (!g_superres_loaded[i])
        {
            return i;
        }
    }
    return -1;
}

bool fill_string_list(const std::vector<cv::String>& source, IpcvStringList *list)
{
    if (list == NULL)
    {
        return false;
    }

    std::memset(list, 0, sizeof(*list));
    if (source.empty())
    {
        return true;
    }

    list->items = static_cast<char**>(std::calloc(source.size(), sizeof(char*)));
    if (list->items == NULL)
    {
        copy_error(list->error, static_cast<int>(sizeof(list->error)), "out of memory");
        return false;
    }
    list->count = static_cast<int>(source.size());

    for (int i = 0; i < list->count; i++)
    {
        const size_t length = source[i].size();
        list->items[i] = static_cast<char*>(std::malloc(length + 1));
        if (list->items[i] == NULL)
        {
            ipcv_free_string_list(list);
            copy_error(list->error, static_cast<int>(sizeof(list->error)), "out of memory");
            return false;
        }
        std::memcpy(list->items[i], source[i].c_str(), length + 1);
    }

    return true;
}

const char *superres_algorithm(int algorithm_type)
{
    switch (algorithm_type)
    {
    case 1:
        return "edsr";
    case 2:
        return "espcn";
    case 3:
        return "fsrcnn";
    case 4:
        return "lapsrn";
    default:
        return NULL;
    }
}

bool tensor_from_mat(const cv::Mat& source, IpcvDnnTensor *tensor)
{
    if (tensor == NULL)
    {
        return false;
    }

    std::memset(tensor, 0, sizeof(*tensor));
    if (source.empty())
    {
        set_tensor_error(tensor, "empty DNN tensor");
        return false;
    }
    if (source.dims > IPCV_DNN_MAX_DIMS)
    {
        set_tensor_error(tensor, "DNN tensor has too many dimensions");
        return false;
    }

    cv::Mat converted;
    source.convertTo(converted, CV_64F);
    if (!converted.isContinuous())
    {
        converted = converted.clone();
    }

    const size_t total = converted.total() * converted.channels();
    if (total > static_cast<size_t>(std::numeric_limits<int>::max()))
    {
        set_tensor_error(tensor, "DNN tensor is too large");
        return false;
    }

    tensor->ndims = converted.dims;
    for (int i = 0; i < tensor->ndims; i++)
    {
        tensor->dims[i] = converted.size[tensor->ndims - 1 - i];
    }
    tensor->count = static_cast<int>(total);
    tensor->data = static_cast<double*>(std::malloc(total * sizeof(double)));
    if (tensor->data == NULL)
    {
        set_tensor_error(tensor, "out of memory");
        return false;
    }

    std::memcpy(tensor->data, converted.ptr<double>(), total * sizeof(double));
    return true;
}
}

extern "C" IPCV_CORE_API int ipcv_dnn_load(const char *model, const char *config, int model_type, int *handle, char *error, int error_size)
{
    if (handle != NULL)
    {
        *handle = -1;
    }
    if (model == NULL || model[0] == 0)
    {
        copy_error(error, error_size, "missing DNN model file");
        return -1;
    }

    const int slot = first_free_net();
    if (slot < 0)
    {
        copy_error(error, error_size, "too many DNN models loaded");
        return -1;
    }

    try
    {
        const cv::String model_file(model);
        const cv::String config_file(config == NULL ? "" : config);
        cv::String framework;
        switch (model_type)
        {
        case 0:
            framework = "";
            break;
        case 1:
            framework = "caffe";
            break;
        case 2:
            framework = "tensorflow";
            break;
        case 3:
            framework = "darknet";
            break;
        case 4:
            framework = "onnx";
            break;
        case 5:
            framework = "torch";
            break;
        case 6:
            framework = "tflite";
            break;
        default:
            copy_error(error, error_size, "unsupported DNN model type");
            return -1;
        }

        g_nets[slot] = cv::dnn::readNet(model_file, config_file, framework, cv::dnn::ENGINE_CLASSIC);

        if (g_nets[slot].empty())
        {
            copy_error(error, error_size, "OpenCV returned an empty DNN model");
            return -1;
        }

        if (handle != NULL)
        {
            *handle = slot + 1;
        }
        return 0;
    }
    catch (const cv::Exception& e)
    {
        g_nets[slot] = cv::dnn::Net();
        copy_error(error, error_size, e.what());
        return -1;
    }
    catch (const std::exception& e)
    {
        g_nets[slot] = cv::dnn::Net();
        copy_error(error, error_size, e.what());
        return -1;
    }
}

extern "C" IPCV_CORE_API int ipcv_dnn_forward(int handle, const IpcvDecodedImage *source, int width, int height, const char *layer_name, double scale_factor, const double mean[3], int swap_rb, int crop, IpcvDnnTensor *output)
{
    if (output != NULL)
    {
        std::memset(output, 0, sizeof(*output));
    }
    if (!valid_handle(handle) || g_nets[handle - 1].empty())
    {
        set_tensor_error(output, "invalid DNN handle");
        return -1;
    }
    if (source == NULL)
    {
        set_tensor_error(output, "missing DNN input image");
        return -1;
    }

    try
    {
        char error[256] = {0};
        cv::Mat image;
        if (!image_to_mat(*source, image, error, static_cast<int>(sizeof(error))))
        {
            set_tensor_error(output, error);
            return -1;
        }
        if (image.depth() == CV_64F)
        {
            image.convertTo(image, CV_32F);
        }

        const double local_mean[3] = {mean == NULL ? 0.0 : mean[0], mean == NULL ? 0.0 : mean[1], mean == NULL ? 0.0 : mean[2]};
        cv::Mat input_blob = cv::dnn::blobFromImage(image, scale_factor, cv::Size(width, height), cv::Scalar(local_mean[0], local_mean[1], local_mean[2]), swap_rb != 0, crop != 0);
        cv::dnn::Net& net = g_nets[handle - 1];
        net.setInput(input_blob);

        cv::Mat result;
        if (layer_name == NULL || layer_name[0] == 0)
        {
            result = net.forward();
        }
        else
        {
            result = net.forward(cv::String(layer_name));
        }

        if (!tensor_from_mat(result, output))
        {
            return -1;
        }
        return 0;
    }
    catch (const cv::Exception& e)
    {
        set_tensor_error(output, e.what());
        return -1;
    }
    catch (const std::exception& e)
    {
        set_tensor_error(output, e.what());
        return -1;
    }
}

extern "C" IPCV_CORE_API int ipcv_dnn_get_layer_names(int handle, IpcvStringList *names)
{
    if (names != NULL)
    {
        std::memset(names, 0, sizeof(*names));
    }
    if (!valid_handle(handle) || g_nets[handle - 1].empty())
    {
        if (names != NULL)
        {
            copy_error(names->error, static_cast<int>(sizeof(names->error)), "invalid DNN handle");
        }
        return -1;
    }

    try
    {
        return fill_string_list(g_nets[handle - 1].getLayerNames(), names) ? 0 : -1;
    }
    catch (const cv::Exception& e)
    {
        copy_error(names->error, static_cast<int>(sizeof(names->error)), e.what());
        return -1;
    }
}

extern "C" IPCV_CORE_API int ipcv_dnn_get_unconnected_output_names(int handle, IpcvStringList *names)
{
    if (names != NULL)
    {
        std::memset(names, 0, sizeof(*names));
    }
    if (!valid_handle(handle) || g_nets[handle - 1].empty())
    {
        if (names != NULL)
        {
            copy_error(names->error, static_cast<int>(sizeof(names->error)), "invalid DNN handle");
        }
        return -1;
    }

    try
    {
        return fill_string_list(g_nets[handle - 1].getUnconnectedOutLayersNames(), names) ? 0 : -1;
    }
    catch (const cv::Exception& e)
    {
        copy_error(names->error, static_cast<int>(sizeof(names->error)), e.what());
        return -1;
    }
}

extern "C" IPCV_CORE_API int ipcv_dnn_get_layer_types(int handle, IpcvStringList *types)
{
    if (types != NULL)
    {
        std::memset(types, 0, sizeof(*types));
    }
    if (!valid_handle(handle) || g_nets[handle - 1].empty())
    {
        if (types != NULL)
        {
            copy_error(types->error, static_cast<int>(sizeof(types->error)), "invalid DNN handle");
        }
        return -1;
    }

    try
    {
        std::vector<cv::String> layer_types;
        g_nets[handle - 1].getLayerTypes(layer_types);
        return fill_string_list(layer_types, types) ? 0 : -1;
    }
    catch (const cv::Exception& e)
    {
        copy_error(types->error, static_cast<int>(sizeof(types->error)), e.what());
        return -1;
    }
}

extern "C" IPCV_CORE_API int ipcv_dnn_get_layer_count(int handle, int *count, char *error, int error_size)
{
    if (count != NULL)
    {
        *count = 0;
    }
    if (!valid_handle(handle) || g_nets[handle - 1].empty())
    {
        copy_error(error, error_size, "invalid DNN handle");
        return -1;
    }

    try
    {
        if (count != NULL)
        {
            *count = static_cast<int>(g_nets[handle - 1].getLayerNames().size());
        }
        return 0;
    }
    catch (const cv::Exception& e)
    {
        copy_error(error, error_size, e.what());
        return -1;
    }
}

extern "C" IPCV_CORE_API int ipcv_dnn_get_flops(int handle, int width, int height, int channels, double *flops, char *error, int error_size)
{
    if (flops != NULL)
    {
        *flops = 0.0;
    }
    if (!valid_handle(handle) || g_nets[handle - 1].empty())
    {
        copy_error(error, error_size, "invalid DNN handle");
        return -1;
    }
    if (width <= 0 || height <= 0 || channels <= 0)
    {
        copy_error(error, error_size, "DNN input width, height, and channels must be positive");
        return -1;
    }

    try
    {
        std::vector<cv::MatShape> input_shapes(1);
        input_shapes[0].push_back(1);
        input_shapes[0].push_back(channels);
        input_shapes[0].push_back(height);
        input_shapes[0].push_back(width);

        std::vector<int> input_types(1, CV_32F);
        const double flops_value = static_cast<double>(g_nets[handle - 1].getFLOPS(input_shapes, input_types));
        if (flops != NULL)
        {
            *flops = flops_value;
        }
        return 0;
    }
    catch (const cv::Exception& e)
    {
        copy_error(error, error_size, e.what());
        return -1;
    }
}

extern "C" IPCV_CORE_API int ipcv_dnn_set_preferable_backend_target(int handle, int backend, int target, char *error, int error_size)
{
    if (!valid_handle(handle) || g_nets[handle - 1].empty())
    {
        copy_error(error, error_size, "invalid DNN handle");
        return -1;
    }

    try
    {
        cv::dnn::Net& net = g_nets[handle - 1];
        net.setPreferableBackend(backend);
        net.setPreferableTarget(target);
        net.finalizeNet();
        return 0;
    }
    catch (const cv::Exception& e)
    {
        copy_error(error, error_size, e.what());
        return -1;
    }
}

extern "C" IPCV_CORE_API int ipcv_dnn_get_param(int handle, const char *layer_name, int param_index, IpcvDnnTensor *output)
{
    if (output != NULL)
    {
        std::memset(output, 0, sizeof(*output));
    }
    if (!valid_handle(handle) || g_nets[handle - 1].empty())
    {
        set_tensor_error(output, "invalid DNN handle");
        return -1;
    }
    if (layer_name == NULL || layer_name[0] == 0)
    {
        set_tensor_error(output, "missing DNN layer name");
        return -1;
    }

    try
    {
        cv::dnn::Net& net = g_nets[handle - 1];
        const int layer_id = net.getLayerId(cv::String(layer_name));
        if (layer_id < 0)
        {
            set_tensor_error(output, "DNN layer name not found");
            return -1;
        }

        cv::Mat param = net.getParam(layer_id, param_index);
        if (!tensor_from_mat(param, output))
        {
            return -1;
        }
        return 0;
    }
    catch (const cv::Exception& e)
    {
        set_tensor_error(output, e.what());
        return -1;
    }
}

extern "C" IPCV_CORE_API int ipcv_dnn_list(double *handles, int max_handles, int *count)
{
    int local_count = 0;
    for (int i = 0; i < kMaxDnnModels; i++)
    {
        if (!g_nets[i].empty())
        {
            if (handles != NULL && local_count < max_handles)
            {
                handles[local_count] = static_cast<double>(i + 1);
            }
            local_count++;
        }
    }

    if (count != NULL)
    {
        *count = local_count;
    }
    return 0;
}

extern "C" IPCV_CORE_API int ipcv_dnn_unload(int handle, char *error, int error_size)
{
    if (!valid_handle(handle))
    {
        copy_error(error, error_size, "DNN handle out of range");
        return -1;
    }

    const int index = handle - 1;
    if (g_nets[index].empty() && !g_superres_loaded[index])
    {
        copy_error(error, error_size, "DNN model is not loaded");
        return -1;
    }

    if (!g_nets[index].empty())
    {
        g_nets[index] = cv::dnn::Net();
    }
    if (g_superres_loaded[index])
    {
        g_superres[index] = cv::dnn_superres::DnnSuperResImpl();
        g_superres_loaded[index] = false;
    }
    return 0;
}

extern "C" IPCV_CORE_API void ipcv_dnn_unload_all(void)
{
    for (int i = 0; i < kMaxDnnModels; i++)
    {
        g_nets[i] = cv::dnn::Net();
        g_superres[i] = cv::dnn_superres::DnnSuperResImpl();
        g_superres_loaded[i] = false;
    }
}

extern "C" IPCV_CORE_API int ipcv_dnn_superres_load(const char *model, int scale, int algorithm_type, int *handle, char *error, int error_size)
{
    if (handle != NULL)
    {
        *handle = -1;
    }

    const char *algorithm = superres_algorithm(algorithm_type);
    if (model == NULL || model[0] == 0)
    {
        copy_error(error, error_size, "missing DNN superres model file");
        return -1;
    }
    if (algorithm == NULL)
    {
        copy_error(error, error_size, "unsupported DNN superres algorithm");
        return -1;
    }

    const int slot = first_free_superres();
    if (slot < 0)
    {
        copy_error(error, error_size, "too many DNN superres models loaded");
        return -1;
    }

    try
    {
        g_superres[slot] = cv::dnn_superres::DnnSuperResImpl();
        g_superres[slot].readModel(cv::String(model));
        g_superres[slot].setModel(cv::String(algorithm), scale);
        g_superres_loaded[slot] = true;
        if (handle != NULL)
        {
            *handle = slot + 1;
        }
        return 0;
    }
    catch (const cv::Exception& e)
    {
        g_superres[slot] = cv::dnn_superres::DnnSuperResImpl();
        g_superres_loaded[slot] = false;
        copy_error(error, error_size, e.what());
        return -1;
    }
}

extern "C" IPCV_CORE_API int ipcv_dnn_superres_upsample(int handle, const IpcvDecodedImage *source, IpcvDecodedImage *output)
{
    if (output != NULL)
    {
        std::memset(output, 0, sizeof(*output));
    }
    if (!valid_handle(handle) || !g_superres_loaded[handle - 1])
    {
        set_image_error(output, "invalid DNN superres handle");
        return -1;
    }
    if (source == NULL)
    {
        set_image_error(output, "missing DNN superres input image");
        return -1;
    }

    try
    {
        char error[256] = {0};
        cv::Mat image;
        if (!image_to_mat(*source, image, error, static_cast<int>(sizeof(error))))
        {
            set_image_error(output, error);
            return -1;
        }

        cv::Mat upsampled;
        g_superres[handle - 1].upsample(image, upsampled);
        if (!mat_to_image(upsampled, output))
        {
            return -1;
        }
        return 0;
    }
    catch (const cv::Exception& e)
    {
        set_image_error(output, e.what());
        return -1;
    }
}

extern "C" IPCV_CORE_API void ipcv_dnn_free_tensor(IpcvDnnTensor *tensor)
{
    if (tensor == NULL)
    {
        return;
    }
    std::free(tensor->data);
    tensor->data = NULL;
    tensor->count = 0;
    tensor->ndims = 0;
    tensor->error[0] = 0;
}

extern "C" IPCV_CORE_API void ipcv_free_string_list(IpcvStringList *list)
{
    if (list == NULL)
    {
        return;
    }
    for (int i = 0; i < list->count; i++)
    {
        std::free(list->items[i]);
    }
    std::free(list->items);
    list->items = NULL;
    list->count = 0;
    list->error[0] = 0;
}
