#define IPCV_CORE_EXPORTS
#include "ipcv_geometry.h"

#include <opencv2/calib3d.hpp>

#include <cmath>
#include <cstdlib>
#include <cstring>
#include <exception>

namespace
{
void set_error(IpcvDoubleMatrix *matrix, const char *message)
{
    if (matrix == NULL) return;
    std::strncpy(matrix->error, message, sizeof(matrix->error) - 1);
    matrix->error[sizeof(matrix->error) - 1] = 0;
}

cv::Mat input_matrix(const double *data, int rows, int cols)
{
    cv::Mat result(rows, cols, CV_64F);
    for (int col = 0; col < cols; col++)
        for (int row = 0; row < rows; row++)
            result.at<double>(row, col) = data[row + col * rows];
    return result;
}

bool output_matrix(const cv::Mat& source, IpcvDoubleMatrix *output)
{
    if (output == NULL || source.empty()) return false;
    output->rows = source.rows;
    output->cols = source.cols;
    const size_t count = static_cast<size_t>(source.rows) * source.cols;
    output->data = static_cast<double*>(std::calloc(count == 0 ? 1 : count, sizeof(double)));
    if (output->data == NULL) { set_error(output, "out of memory"); return false; }
    for (int col = 0; col < source.cols; col++)
        for (int row = 0; row < source.rows; row++)
            output->data[row + col * source.rows] = source.at<double>(row, col);
    return true;
}

bool valid_points(const double *data, int rows, int cols, int required_cols)
{
    return data != NULL && rows >= 1 && cols == required_cols;
}
}

extern "C" IPCV_CORE_API int ipcv_solve_pnp(const double *object_points, int object_rows, int object_cols,
    const double *image_points, int image_rows, int image_cols,
    const double *camera_matrix, int camera_rows, int camera_cols,
    const double *distortion, int distortion_rows, int distortion_cols,
    IpcvDoubleMatrix *rvec, IpcvDoubleMatrix *tvec)
{
    if (rvec == NULL || tvec == NULL) return -1;
    std::memset(rvec, 0, sizeof(*rvec)); std::memset(tvec, 0, sizeof(*tvec));
    try
    {
        if (!valid_points(object_points, object_rows, object_cols, 3) || !valid_points(image_points, image_rows, image_cols, 2) || object_rows != image_rows || camera_matrix == NULL || camera_rows != 3 || camera_cols != 3)
        { set_error(rvec, "object points must be N-by-3, image points N-by-2, and camera matrix 3-by-3"); return -1; }
        if (object_rows < 4) { set_error(rvec, "at least four point correspondences are required"); return -1; }
        cv::Mat object = input_matrix(object_points, object_rows, object_cols);
        cv::Mat image = input_matrix(image_points, image_rows, image_cols);
        cv::Mat camera = input_matrix(camera_matrix, camera_rows, camera_cols);
        cv::Mat dist = distortion != NULL && distortion_rows * distortion_cols > 0 ? input_matrix(distortion, distortion_rows, distortion_cols) : cv::Mat::zeros(1, 5, CV_64F);
        cv::Mat rotation, translation;
        if (!cv::solvePnP(object, image, camera, dist, rotation, translation)) { set_error(rvec, "OpenCV solvePnP could not estimate a pose"); return -1; }
        if (!output_matrix(rotation, rvec) || !output_matrix(translation, tvec)) { return -1; }
        return 0;
    }
    catch (const cv::Exception& e) { set_error(rvec, e.what()); return -1; }
    catch (const std::exception& e) { set_error(rvec, e.what()); return -1; }
}

extern "C" IPCV_CORE_API int ipcv_estimate_fundamental(const double *points1, int points1_rows, int points1_cols,
    const double *points2, int points2_rows, int points2_cols, IpcvDoubleMatrix *fundamental)
{
    if (fundamental == NULL) return -1;
    std::memset(fundamental, 0, sizeof(*fundamental));
    try
    {
        if (!valid_points(points1, points1_rows, points1_cols, 2) || !valid_points(points2, points2_rows, points2_cols, 2) || points1_rows != points2_rows || points1_rows < 8)
        { set_error(fundamental, "point inputs must be matching N-by-2 matrices with at least eight rows"); return -1; }
        cv::Mat p1 = input_matrix(points1, points1_rows, points1_cols);
        cv::Mat p2 = input_matrix(points2, points2_rows, points2_cols);
        cv::Mat result = cv::findFundamentalMat(p1, p2, cv::FM_8POINT);
        if (result.rows != 3 || result.cols != 3 || !output_matrix(result, fundamental)) { set_error(fundamental, "OpenCV could not estimate a 3-by-3 fundamental matrix"); return -1; }
        return 0;
    }
    catch (const cv::Exception& e) { set_error(fundamental, e.what()); return -1; }
    catch (const std::exception& e) { set_error(fundamental, e.what()); return -1; }
}

extern "C" IPCV_CORE_API int ipcv_triangulate(const double *points1, int points1_rows, int points1_cols,
    const double *points2, int points2_rows, int points2_cols,
    const double *projection1, int projection1_rows, int projection1_cols,
    const double *projection2, int projection2_rows, int projection2_cols,
    IpcvDoubleMatrix *points3d)
{
    if (points3d == NULL) return -1;
    std::memset(points3d, 0, sizeof(*points3d));
    try
    {
        if (!valid_points(points1, points1_rows, points1_cols, 2) || !valid_points(points2, points2_rows, points2_cols, 2) || points1_rows != points2_rows || projection1 == NULL || projection2 == NULL || projection1_rows != 3 || projection2_rows != 3 || projection1_cols != 4 || projection2_cols != 4)
        { set_error(points3d, "points must be matching N-by-2 matrices and projections must be 3-by-4"); return -1; }
        cv::Mat p1 = input_matrix(points1, points1_rows, points1_cols).t();
        cv::Mat p2 = input_matrix(points2, points2_rows, points2_cols).t();
        cv::Mat projectionMat1 = input_matrix(projection1, projection1_rows, projection1_cols);
        cv::Mat projectionMat2 = input_matrix(projection2, projection2_rows, projection2_cols);
        cv::Mat homogeneous;
        cv::triangulatePoints(projectionMat1, projectionMat2, p1, p2, homogeneous);
        cv::Mat result(points1_rows, 3, CV_64F);
        for (int row = 0; row < points1_rows; row++)
        {
            double w = homogeneous.at<double>(3, row);
            for (int col = 0; col < 3; col++) result.at<double>(row, col) = homogeneous.at<double>(col, row) / w;
        }
        if (!output_matrix(result, points3d)) { set_error(points3d, "out of memory"); return -1; }
        return 0;
    }
    catch (const cv::Exception& e) { set_error(points3d, e.what()); return -1; }
    catch (const std::exception& e) { set_error(points3d, e.what()); return -1; }
}
