#define IPCV_CORE_EXPORTS
#include "ipcv_binary_analysis.h"

#include <opencv2/core.hpp>
#include <opencv2/imgproc.hpp>

#include <cstdlib>
#include <cstring>
#include <exception>
#include <vector>

namespace
{
void set_error(IpcvDecodedImage *image, const char *message)
{
    if (image == NULL)
    {
        return;
    }

    std::strncpy(image->error, message, sizeof(image->error) - 1);
    image->error[sizeof(image->error) - 1] = 0;
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
    const size_t elemBytes = destination.elemSize1();

    for (int ch = 0; ch < channels; ch++)
    {
        int dstCh = ch;
        if ((channels == 3 || channels == 4) && ch < 3)
        {
            dstCh = 2 - ch;
        }

        for (int col = 0; col < cols; col++)
        {
            for (int row = 0; row < rows; row++)
            {
                const size_t srcOffset = (static_cast<size_t>(ch) * rows * cols + static_cast<size_t>(col) * rows + row) * elemBytes;
                unsigned char *dst = destination.ptr<unsigned char>(row) + ((col * channels + dstCh) * elemBytes);
                std::memcpy(dst, source + srcOffset, elemBytes);
            }
        }
    }
}

void copy_to_scilab_layout(const cv::Mat& source, unsigned char *destination)
{
    const int rows = source.rows;
    const int cols = source.cols;
    const int channels = source.channels();
    const size_t elemBytes = source.elemSize1();

    for (int ch = 0; ch < channels; ch++)
    {
        int srcCh = ch;
        if ((channels == 3 || channels == 4) && ch < 3)
        {
            srcCh = 2 - ch;
        }

        for (int col = 0; col < cols; col++)
        {
            for (int row = 0; row < rows; row++)
            {
                const unsigned char *src = source.ptr<unsigned char>(row) + ((col * channels + srcCh) * elemBytes);
                const size_t dstOffset = (static_cast<size_t>(ch) * rows * cols + static_cast<size_t>(col) * rows + row) * elemBytes;
                std::memcpy(destination + dstOffset, src, elemBytes);
            }
        }
    }
}

void copy_float_to_double_scilab_layout(const cv::Mat& source, double *destination)
{
    const int rows = source.rows;
    const int cols = source.cols;
    const int channels = source.channels();

    for (int ch = 0; ch < channels; ch++)
    {
        int srcCh = ch;
        if ((channels == 3 || channels == 4) && ch < 3)
        {
            srcCh = 2 - ch;
        }

        for (int col = 0; col < cols; col++)
        {
            for (int row = 0; row < rows; row++)
            {
                const float *src = source.ptr<float>(row) + (col * channels + srcCh);
                const size_t dstOffset = static_cast<size_t>(ch) * rows * cols + static_cast<size_t>(col) * rows + row;
                destination[dstOffset] = static_cast<double>(*src);
            }
        }
    }
}

bool image_to_mat(const IpcvDecodedImage& image, cv::Mat& mat, char *error)
{
    const size_t elemBytes = depth_size(image.depth);
    const size_t expectedBytes = static_cast<size_t>(image.rows) * image.cols * image.channels * elemBytes;
    if (image.data == NULL || image.rows <= 0 || image.cols <= 0 || image.channels <= 0 || elemBytes == 0 || image.byte_count != expectedBytes)
    {
        if (error != NULL)
        {
            std::strcpy(error, "invalid image input");
        }
        return false;
    }

    mat.create(image.rows, image.cols, CV_MAKETYPE(image.depth, image.channels));
    copy_scilab_layout_to_mat(image.data, mat);
    return true;
}

bool mat_to_image(const cv::Mat& mat, IpcvDecodedImage *image)
{
    if (image == NULL || mat.empty())
    {
        return false;
    }

    std::memset(image, 0, sizeof(*image));
    image->rows = mat.rows;
    image->cols = mat.cols;
    image->channels = mat.channels();
    image->depth = mat.depth() == CV_32F ? IPCV_DEPTH_64F : mat.depth();
    image->byte_count = mat.depth() == CV_32F ? mat.total() * mat.channels() * sizeof(double) : mat.total() * mat.elemSize();
    image->data = static_cast<unsigned char*>(std::malloc(image->byte_count));
    if (image->data == NULL)
    {
        set_error(image, "out of memory");
        return false;
    }

    if (mat.depth() == CV_32F)
    {
        copy_float_to_double_scilab_layout(mat, reinterpret_cast<double*>(image->data));
    }
    else
    {
        copy_to_scilab_layout(mat, image->data);
    }
    return true;
}

bool make_binary_mask(const IpcvDecodedImage *source, cv::Mat& mask, IpcvDecodedImage *output)
{
    cv::Mat sourceMat;
    char error[256] = {0};
    if (!image_to_mat(*source, sourceMat, error))
    {
        set_error(output, error);
        return false;
    }
    if (sourceMat.channels() != 1)
    {
        set_error(output, "binary analysis requires a single-channel image");
        return false;
    }

    cv::compare(sourceMat, cv::Scalar(0), mask, cv::CMP_NE);
    return true;
}

int validate_distance_method(int method)
{
    switch (method)
    {
    case 1:
    case 2:
    case 3:
        return method;
    default:
        return -1;
    }
}

int to_opencv_threshold_mode(int mode)
{
    switch (mode)
    {
    case 0:
        return cv::THRESH_BINARY;
    case 1:
        return cv::THRESH_BINARY_INV;
    case 2:
        return cv::THRESH_TRUNC;
    case 3:
        return cv::THRESH_TOZERO;
    case 4:
        return cv::THRESH_TOZERO_INV;
    case 8:
        return cv::THRESH_BINARY | cv::THRESH_OTSU;
    case 16:
        return cv::THRESH_BINARY | cv::THRESH_TRIANGLE;
    default:
        return -1;
    }
}

bool allocate_double_matrix(IpcvDoubleMatrix *matrix, int rows, int cols)
{
    if (matrix == NULL || rows < 0 || cols <= 0)
    {
        return false;
    }

    std::memset(matrix, 0, sizeof(*matrix));
    matrix->rows = rows;
    matrix->cols = cols;
    const size_t count = rows == 0 ? 1 : static_cast<size_t>(rows) * cols;
    matrix->data = static_cast<double*>(std::calloc(count, sizeof(double)));
    return matrix->data != NULL;
}
}

extern "C" IPCV_CORE_API int ipcv_distance_l1_image(const IpcvDecodedImage *source, IpcvDecodedImage *output)
{
    if (output == NULL)
    {
        return -1;
    }

    std::memset(output, 0, sizeof(*output));
    if (source == NULL)
    {
        set_error(output, "missing image input");
        return -1;
    }

    try
    {
        cv::setNumThreads(1);
        cv::setUseOptimized(false);

        cv::Mat mask;
        cv::Mat dist;
        if (!make_binary_mask(source, mask, output))
        {
            return -1;
        }

        cv::distanceTransform(mask, dist, 1, 3);
        if (!mat_to_image(dist, output))
        {
            if (output->error[0] == 0)
            {
                set_error(output, "could not convert distance result");
            }
            return -1;
        }
        return 0;
    }
    catch (const cv::Exception& e)
    {
        set_error(output, e.what());
        return -1;
    }
    catch (const std::exception& e)
    {
        set_error(output, e.what());
        return -1;
    }
    catch (...)
    {
        set_error(output, "unknown distance transform failure");
        return -1;
    }
}

extern "C" IPCV_CORE_API int ipcv_distance_transform_image(const IpcvDecodedImage *source, int method, IpcvDecodedImage *output)
{
    if (output == NULL)
    {
        return -1;
    }

    std::memset(output, 0, sizeof(*output));
    if (source == NULL)
    {
        set_error(output, "missing image input");
        return -1;
    }

    const int distanceType = validate_distance_method(method);
    if (distanceType < 0)
    {
        set_error(output, "distance method must be 1, 2, or 3");
        return -1;
    }

    try
    {
        cv::setNumThreads(1);
        cv::setUseOptimized(false);

        cv::Mat mask;
        cv::Mat dist;
        if (!make_binary_mask(source, mask, output))
        {
            return -1;
        }

        cv::distanceTransform(mask, dist, distanceType, 3);
        cv::normalize(dist, dist, 0, 1.0, cv::NORM_MINMAX);
        if (!mat_to_image(dist, output))
        {
            if (output->error[0] == 0)
            {
                set_error(output, "could not convert distance transform result");
            }
            return -1;
        }
        return 0;
    }
    catch (const cv::Exception& e)
    {
        set_error(output, e.what());
        return -1;
    }
    catch (const std::exception& e)
    {
        set_error(output, e.what());
        return -1;
    }
    catch (...)
    {
        set_error(output, "unknown distance transform failure");
        return -1;
    }
}

extern "C" IPCV_CORE_API int ipcv_fill_binary_image(const IpcvDecodedImage *source, IpcvDecodedImage *output)
{
    if (output == NULL)
    {
        return -1;
    }

    std::memset(output, 0, sizeof(*output));
    if (source == NULL)
    {
        set_error(output, "missing image input");
        return -1;
    }

    try
    {
        cv::setNumThreads(1);
        cv::setUseOptimized(false);

        cv::Mat mask;
        cv::Mat filled;
        std::vector<std::vector<cv::Point> > contours;
        std::vector<cv::Vec4i> hierarchy;
        if (!make_binary_mask(source, mask, output))
        {
            return -1;
        }

        cv::findContours(mask, contours, hierarchy, cv::RETR_CCOMP, cv::CHAIN_APPROX_SIMPLE, cv::Point(0, 0));
        filled = cv::Mat::zeros(mask.size(), CV_8UC1);
        for (size_t i = 0; i < contours.size(); i++)
        {
            cv::drawContours(filled, contours, static_cast<int>(i), cv::Scalar(255), -1, 8, hierarchy, 0, cv::Point());
        }

        if (!mat_to_image(filled, output))
        {
            if (output->error[0] == 0)
            {
                set_error(output, "could not convert filled binary image");
            }
            return -1;
        }
        return 0;
    }
    catch (const cv::Exception& e)
    {
        set_error(output, e.what());
        return -1;
    }
    catch (const std::exception& e)
    {
        set_error(output, e.what());
        return -1;
    }
    catch (...)
    {
        set_error(output, "unknown binary fill failure");
        return -1;
    }
}

extern "C" IPCV_CORE_API int ipcv_label_binary_image(const IpcvDecodedImage *source, IpcvDecodedImage *output)
{
    if (output == NULL)
    {
        return -1;
    }

    std::memset(output, 0, sizeof(*output));
    if (source == NULL)
    {
        set_error(output, "missing image input");
        return -1;
    }

    try
    {
        cv::setNumThreads(1);
        cv::setUseOptimized(false);

        cv::Mat mask;
        cv::Mat labels;
        cv::Mat labels64;
        if (!make_binary_mask(source, mask, output))
        {
            return -1;
        }

        cv::connectedComponents(mask, labels, 4, CV_32S);
        labels.convertTo(labels64, CV_64F);
        if (!mat_to_image(labels64, output))
        {
            if (output->error[0] == 0)
            {
                set_error(output, "could not convert label image");
            }
            return -1;
        }
        return 0;
    }
    catch (const cv::Exception& e)
    {
        set_error(output, e.what());
        return -1;
    }
    catch (const std::exception& e)
    {
        set_error(output, e.what());
        return -1;
    }
    catch (...)
    {
        set_error(output, "unknown binary label failure");
        return -1;
    }
}

extern "C" IPCV_CORE_API int ipcv_threshold_image(const IpcvDecodedImage *source, double threshold, double max_value, int mode, IpcvDecodedImage *output, double *used_threshold)
{
    if (output == NULL || used_threshold == NULL)
    {
        return -1;
    }

    std::memset(output, 0, sizeof(*output));
    *used_threshold = 0.0;
    if (source == NULL)
    {
        set_error(output, "missing threshold image input");
        return -1;
    }

    const int thresholdMode = to_opencv_threshold_mode(mode);
    if (thresholdMode < 0)
    {
        set_error(output, "unsupported threshold mode");
        return -1;
    }
    if (max_value < 0.0 || max_value > 255.0)
    {
        set_error(output, "maximum threshold value must be in the range 0 to 255");
        return -1;
    }

    try
    {
        cv::setNumThreads(1);
        cv::setUseOptimized(false);

        cv::Mat sourceMat;
        cv::Mat thresholded;
        char error[256] = {0};
        if (!image_to_mat(*source, sourceMat, error))
        {
            set_error(output, error);
            return -1;
        }
        if (sourceMat.channels() != 1)
        {
            set_error(output, "thresholding requires a single-channel image");
            return -1;
        }
        if (sourceMat.depth() != CV_8U)
        {
            set_error(output, "thresholding requires a uint8 image");
            return -1;
        }

        *used_threshold = cv::threshold(sourceMat, thresholded, threshold, max_value, thresholdMode);
        if (!mat_to_image(thresholded, output))
        {
            if (output->error[0] == 0)
            {
                set_error(output, "could not convert threshold result");
            }
            return -1;
        }
        return 0;
    }
    catch (const cv::Exception& e)
    {
        set_error(output, e.what());
        return -1;
    }
    catch (const std::exception& e)
    {
        set_error(output, e.what());
        return -1;
    }
    catch (...)
    {
        set_error(output, "unknown threshold failure");
        return -1;
    }
}

extern "C" IPCV_CORE_API int ipcv_connected_components(const IpcvDecodedImage *source, int connectivity, IpcvDecodedImage *labels, int *component_count, IpcvDoubleMatrix *stats, IpcvDoubleMatrix *centroids)
{
    if (labels == NULL || component_count == NULL || stats == NULL || centroids == NULL)
    {
        return -1;
    }

    std::memset(labels, 0, sizeof(*labels));
    std::memset(stats, 0, sizeof(*stats));
    std::memset(centroids, 0, sizeof(*centroids));
    *component_count = 0;
    if (source == NULL)
    {
        set_error(labels, "missing connected-components image input");
        return -1;
    }
    if (connectivity != 4 && connectivity != 8)
    {
        set_error(labels, "connectivity must be 4 or 8");
        return -1;
    }

    try
    {
        cv::setNumThreads(1);
        cv::setUseOptimized(false);

        cv::Mat mask;
        cv::Mat labelMat;
        cv::Mat labelMat64;
        cv::Mat statsMat;
        cv::Mat centroidMat;
        if (!make_binary_mask(source, mask, labels))
        {
            return -1;
        }

        const int labelCount = cv::connectedComponentsWithStats(mask, labelMat, statsMat, centroidMat, connectivity, CV_32S);
        *component_count = std::max(0, labelCount - 1);
        labelMat.convertTo(labelMat64, CV_64F);
        if (!mat_to_image(labelMat64, labels))
        {
            if (labels->error[0] == 0)
            {
                set_error(labels, "could not convert connected-components labels");
            }
            return -1;
        }

        if (!allocate_double_matrix(stats, *component_count, 5) || !allocate_double_matrix(centroids, *component_count, 2))
        {
            ipcv_free_decoded_image(labels);
            ipcv_free_double_matrix(stats);
            ipcv_free_double_matrix(centroids);
            set_error(labels, "out of memory");
            return -1;
        }

        for (int component = 0; component < *component_count; component++)
        {
            const int label = component + 1;
            stats->data[component] = static_cast<double>(statsMat.at<int>(label, cv::CC_STAT_LEFT) + 1);
            stats->data[*component_count + component] = static_cast<double>(statsMat.at<int>(label, cv::CC_STAT_TOP) + 1);
            stats->data[2 * *component_count + component] = static_cast<double>(statsMat.at<int>(label, cv::CC_STAT_WIDTH));
            stats->data[3 * *component_count + component] = static_cast<double>(statsMat.at<int>(label, cv::CC_STAT_HEIGHT));
            stats->data[4 * *component_count + component] = static_cast<double>(statsMat.at<int>(label, cv::CC_STAT_AREA));
            centroids->data[component] = centroidMat.at<double>(label, 0) + 1.0;
            centroids->data[*component_count + component] = centroidMat.at<double>(label, 1) + 1.0;
        }
        return 0;
    }
    catch (const cv::Exception& e)
    {
        ipcv_free_decoded_image(labels);
        ipcv_free_double_matrix(stats);
        ipcv_free_double_matrix(centroids);
        set_error(labels, e.what());
        return -1;
    }
    catch (const std::exception& e)
    {
        ipcv_free_decoded_image(labels);
        ipcv_free_double_matrix(stats);
        ipcv_free_double_matrix(centroids);
        set_error(labels, e.what());
        return -1;
    }
    catch (...)
    {
        ipcv_free_decoded_image(labels);
        ipcv_free_double_matrix(stats);
        ipcv_free_double_matrix(centroids);
        set_error(labels, "unknown connected-components failure");
        return -1;
    }
}
