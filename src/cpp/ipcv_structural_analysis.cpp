#define IPCV_CORE_EXPORTS
#include "ipcv_structural_analysis.h"

#include <opencv2/core.hpp>
#include <opencv2/geometry/2d.hpp>
#include <opencv2/imgproc.hpp>

#include <cstdlib>
#include <cstring>
#include <exception>
#include <vector>

namespace
{
void set_error(IpcvContourList *list, const char *message)
{
    if (list == NULL)
    {
        return;
    }

    std::strncpy(list->error, message, sizeof(list->error) - 1);
    list->error[sizeof(list->error) - 1] = 0;
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

bool image_to_mat(const IpcvDecodedImage& image, cv::Mat& mat, char *error)
{
    const size_t elem_bytes = depth_size(image.depth);
    const size_t expected_bytes = static_cast<size_t>(image.rows) * image.cols * image.channels * elem_bytes;
    if (image.data == NULL || image.rows <= 0 || image.cols <= 0 || image.channels <= 0 || elem_bytes == 0 || image.byte_count != expected_bytes)
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

std::vector<std::vector<cv::Point>> list_to_contours(const IpcvContourList *list)
{
    std::vector<std::vector<cv::Point>> contours;
    if (list == NULL || list->count <= 0 || list->columns != 2 || list->rows == NULL || list->data == NULL)
    {
        return contours;
    }

    contours.resize(list->count);
    size_t offset = 0;
    for (int item = 0; item < list->count; item++)
    {
        const int rows = list->rows[item];
        contours[item].reserve(rows);
        for (int row = 0; row < rows; row++)
        {
            const double x = list->data[offset + row];
            const double y = list->data[offset + rows + row];
            contours[item].push_back(cv::Point(static_cast<int>(x) - 1, static_cast<int>(y) - 1));
        }
        offset += static_cast<size_t>(rows) * 2;
    }

    return contours;
}

std::vector<std::vector<int>> list_to_indices(const IpcvContourList *list)
{
    std::vector<std::vector<int>> indices;
    if (list == NULL || list->count <= 0 || list->columns != 1 || list->rows == NULL || list->data == NULL)
    {
        return indices;
    }

    indices.resize(list->count);
    size_t offset = 0;
    for (int item = 0; item < list->count; item++)
    {
        const int rows = list->rows[item];
        indices[item].reserve(rows);
        for (int row = 0; row < rows; row++)
        {
            indices[item].push_back(static_cast<int>(list->data[offset + row]) - 1);
        }
        offset += rows;
    }

    return indices;
}

bool allocate_list(IpcvContourList *list, int count, int columns, const std::vector<int>& rows)
{
    if (list == NULL || count < 0 || columns <= 0 || static_cast<int>(rows.size()) != count)
    {
        return false;
    }

    std::memset(list, 0, sizeof(*list));
    list->count = count;
    list->columns = columns;
    list->rows = static_cast<int*>(std::calloc(static_cast<size_t>(count), sizeof(int)));
    if (count > 0 && list->rows == NULL)
    {
        set_error(list, "out of memory");
        return false;
    }

    size_t total = 0;
    for (int i = 0; i < count; i++)
    {
        list->rows[i] = rows[i];
        total += static_cast<size_t>(rows[i]) * columns;
    }

    list->data = static_cast<double*>(std::calloc(total == 0 ? 1 : total, sizeof(double)));
    if (list->data == NULL)
    {
        ipcv_free_contour_list(list);
        set_error(list, "out of memory");
        return false;
    }

    return true;
}
}

extern "C" IPCV_CORE_API int ipcv_find_contours(const IpcvDecodedImage *source, int mode, int method, IpcvContourList *contours)
{
    if (contours == NULL)
    {
        return -1;
    }

    std::memset(contours, 0, sizeof(*contours));
    if (source == NULL)
    {
        set_error(contours, "missing contour image input");
        return -1;
    }

    try
    {
        cv::setNumThreads(1);
        cv::setUseOptimized(false);

        cv::Mat source_mat;
        char error[256] = {0};
        if (!image_to_mat(*source, source_mat, error))
        {
            set_error(contours, error);
            return -1;
        }
        if (source_mat.channels() != 1)
        {
            set_error(contours, "contour detection requires a single-channel image");
            return -1;
        }

        cv::Mat mask;
        cv::compare(source_mat, cv::Scalar(0), mask, cv::CMP_NE);

        std::vector<std::vector<cv::Point>> found;
        std::vector<cv::Vec4i> hierarchy;
        cv::findContours(mask, found, hierarchy, mode, method);

        std::vector<int> rows(found.size());
        for (size_t i = 0; i < found.size(); i++)
        {
            rows[i] = static_cast<int>(found[i].size());
        }
        if (!allocate_list(contours, static_cast<int>(found.size()), 2, rows))
        {
            return -1;
        }

        size_t offset = 0;
        for (size_t item = 0; item < found.size(); item++)
        {
            const int item_rows = rows[item];
            for (int row = 0; row < item_rows; row++)
            {
                contours->data[offset + row] = found[item][row].x + 1;
                contours->data[offset + item_rows + row] = found[item][row].y + 1;
            }
            offset += static_cast<size_t>(item_rows) * 2;
        }

        return 0;
    }
    catch (const cv::Exception& e)
    {
        ipcv_free_contour_list(contours);
        set_error(contours, e.what());
        return -1;
    }
    catch (const std::exception& e)
    {
        ipcv_free_contour_list(contours);
        set_error(contours, e.what());
        return -1;
    }
    catch (...)
    {
        ipcv_free_contour_list(contours);
        set_error(contours, "unknown contour detection failure");
        return -1;
    }
}

extern "C" IPCV_CORE_API int ipcv_convex_hull(const IpcvContourList *contours, int clockwise, int return_indices, IpcvContourList *hulls)
{
    if (hulls == NULL)
    {
        return -1;
    }

    std::memset(hulls, 0, sizeof(*hulls));
    try
    {
        std::vector<std::vector<cv::Point>> contour_points = list_to_contours(contours);
        if (contours == NULL || contours->count < 0 || (contours->count > 0 && static_cast<int>(contour_points.size()) != contours->count))
        {
            set_error(hulls, "invalid contour list");
            return -1;
        }

        std::vector<int> rows(contour_points.size());
        if (return_indices)
        {
            std::vector<std::vector<int>> hull_indices(contour_points.size());
            for (size_t i = 0; i < contour_points.size(); i++)
            {
                cv::convexHull(contour_points[i], hull_indices[i], clockwise != 0, true);
                rows[i] = static_cast<int>(hull_indices[i].size());
            }
            if (!allocate_list(hulls, static_cast<int>(hull_indices.size()), 1, rows))
            {
                return -1;
            }
            size_t offset = 0;
            for (size_t item = 0; item < hull_indices.size(); item++)
            {
                for (size_t row = 0; row < hull_indices[item].size(); row++)
                {
                    hulls->data[offset + row] = hull_indices[item][row] + 1;
                }
                offset += hull_indices[item].size();
            }
        }
        else
        {
            std::vector<std::vector<cv::Point>> hull_points(contour_points.size());
            for (size_t i = 0; i < contour_points.size(); i++)
            {
                cv::convexHull(contour_points[i], hull_points[i], clockwise != 0, true);
                rows[i] = static_cast<int>(hull_points[i].size());
            }
            if (!allocate_list(hulls, static_cast<int>(hull_points.size()), 2, rows))
            {
                return -1;
            }
            size_t offset = 0;
            for (size_t item = 0; item < hull_points.size(); item++)
            {
                const int item_rows = rows[item];
                for (int row = 0; row < item_rows; row++)
                {
                    hulls->data[offset + row] = hull_points[item][row].x + 1;
                    hulls->data[offset + item_rows + row] = hull_points[item][row].y + 1;
                }
                offset += static_cast<size_t>(item_rows) * 2;
            }
        }

        return 0;
    }
    catch (const cv::Exception& e)
    {
        ipcv_free_contour_list(hulls);
        set_error(hulls, e.what());
        return -1;
    }
    catch (const std::exception& e)
    {
        ipcv_free_contour_list(hulls);
        set_error(hulls, e.what());
        return -1;
    }
    catch (...)
    {
        ipcv_free_contour_list(hulls);
        set_error(hulls, "unknown convex hull failure");
        return -1;
    }
}

extern "C" IPCV_CORE_API int ipcv_convexity_defects(const IpcvContourList *contours, const IpcvContourList *hull_indices, IpcvContourList *defects)
{
    if (defects == NULL)
    {
        return -1;
    }

    std::memset(defects, 0, sizeof(*defects));
    try
    {
        std::vector<std::vector<cv::Point>> contour_points = list_to_contours(contours);
        std::vector<std::vector<int>> indices = list_to_indices(hull_indices);
        if (contours == NULL || hull_indices == NULL || contour_points.size() != indices.size())
        {
            set_error(defects, "contour and hull-index lists must have the same number of entries");
            return -1;
        }

        std::vector<std::vector<cv::Vec4i>> defect_values(contour_points.size());
        std::vector<int> rows(contour_points.size());
        for (size_t i = 0; i < contour_points.size(); i++)
        {
            if (contour_points[i].size() >= 3 && indices[i].size() >= 3)
            {
                cv::convexityDefects(contour_points[i], indices[i], defect_values[i]);
            }
            rows[i] = static_cast<int>(defect_values[i].size());
        }

        if (!allocate_list(defects, static_cast<int>(defect_values.size()), 4, rows))
        {
            return -1;
        }

        size_t offset = 0;
        for (size_t item = 0; item < defect_values.size(); item++)
        {
            const int item_rows = rows[item];
            for (int row = 0; row < item_rows; row++)
            {
                defects->data[offset + row] = defect_values[item][row][0] + 1;
                defects->data[offset + item_rows + row] = defect_values[item][row][1] + 1;
                defects->data[offset + item_rows * 2 + row] = defect_values[item][row][2] + 1;
                defects->data[offset + item_rows * 3 + row] = defect_values[item][row][3];
            }
            offset += static_cast<size_t>(item_rows) * 4;
        }

        return 0;
    }
    catch (const cv::Exception& e)
    {
        ipcv_free_contour_list(defects);
        set_error(defects, e.what());
        return -1;
    }
    catch (const std::exception& e)
    {
        ipcv_free_contour_list(defects);
        set_error(defects, e.what());
        return -1;
    }
    catch (...)
    {
        ipcv_free_contour_list(defects);
        set_error(defects, "unknown convexity defects failure");
        return -1;
    }
}

extern "C" IPCV_CORE_API int ipcv_bounding_rect(const IpcvDecodedImage *source, double rect[4], char *error, int error_size)
{
    if (rect == NULL)
    {
        return -1;
    }

    rect[0] = 0;
    rect[1] = 0;
    rect[2] = 0;
    rect[3] = 0;
    if (source == NULL)
    {
        if (error != NULL && error_size > 0)
        {
            std::strncpy(error, "missing bounding rectangle image input", error_size - 1);
            error[error_size - 1] = 0;
        }
        return -1;
    }

    try
    {
        cv::setNumThreads(1);
        cv::setUseOptimized(false);

        cv::Mat source_mat;
        char local_error[256] = {0};
        if (!image_to_mat(*source, source_mat, local_error))
        {
            if (error != NULL && error_size > 0)
            {
                std::strncpy(error, local_error, error_size - 1);
                error[error_size - 1] = 0;
            }
            return -1;
        }

        cv::Rect bounds = cv::boundingRect(source_mat);
        rect[0] = bounds.x;
        rect[1] = bounds.y;
        rect[2] = bounds.width;
        rect[3] = bounds.height;
        return 0;
    }
    catch (const cv::Exception& e)
    {
        if (error != NULL && error_size > 0)
        {
            std::strncpy(error, e.what(), error_size - 1);
            error[error_size - 1] = 0;
        }
        return -1;
    }
    catch (const std::exception& e)
    {
        if (error != NULL && error_size > 0)
        {
            std::strncpy(error, e.what(), error_size - 1);
            error[error_size - 1] = 0;
        }
        return -1;
    }
    catch (...)
    {
        if (error != NULL && error_size > 0)
        {
            std::strncpy(error, "unknown bounding rectangle failure", error_size - 1);
            error[error_size - 1] = 0;
        }
        return -1;
    }
}

extern "C" IPCV_CORE_API void ipcv_free_contour_list(IpcvContourList *contours)
{
    if (contours == NULL)
    {
        return;
    }

    std::free(contours->rows);
    std::free(contours->data);
    contours->rows = NULL;
    contours->data = NULL;
    contours->count = 0;
    contours->columns = 0;
}
