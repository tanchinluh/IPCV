#define IPCV_CORE_EXPORTS
#include "ipcv_stitching.h"

#include <opencv2/core.hpp>
#include <opencv2/stitching.hpp>
#include <opencv2/stitching/detail/blenders.hpp>
#include <opencv2/stitching/detail/exposure_compensate.hpp>
#include <opencv2/stitching/detail/motion_estimators.hpp>

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

bool mat_to_image(const cv::Mat& image, IpcvDecodedImage *output)
{
    if (output == NULL || image.empty())
    {
        return false;
    }

    std::memset(output, 0, sizeof(*output));
    output->rows = image.rows;
    output->cols = image.cols;
    output->channels = image.channels();
    output->depth = image.depth();
    const size_t elem_bytes = image.elemSize1();
    output->byte_count = static_cast<size_t>(output->rows) * output->cols * output->channels * elem_bytes;
    output->data = static_cast<unsigned char*>(std::calloc(output->byte_count == 0 ? 1 : output->byte_count, 1));
    if (output->data == NULL)
    {
        set_error(output, "out of memory");
        return false;
    }

    copy_mat_to_scilab_layout(image, output->data);
    return true;
}

const char *stitch_status_message(cv::Stitcher::Status status)
{
    switch (status)
    {
    case cv::Stitcher::OK:
        return "stitching succeeded";
    case cv::Stitcher::ERR_NEED_MORE_IMGS:
        return "stitching failed: need more images";
    case cv::Stitcher::ERR_HOMOGRAPHY_EST_FAIL:
        return "stitching failed: homography estimation failed";
    case cv::Stitcher::ERR_CAMERA_PARAMS_ADJUST_FAIL:
        return "stitching failed: camera parameter adjustment failed";
    default:
        return "stitching failed";
    }
}
}

extern "C" IPCV_CORE_API int ipcv_stitch_images(const IpcvImageList *images, double registration_resol, double seam_estimation_resol, double compositing_resol, double pano_confidence_thresh, int wave_correction, int blender_bands, IpcvDecodedImage *output)
{
    if (output == NULL)
    {
        return -1;
    }

    std::memset(output, 0, sizeof(*output));
    if (images == NULL || images->count <= 0 || images->images == NULL)
    {
        set_error(output, "missing stitching image list");
        return -1;
    }

    try
    {
        std::vector<cv::Mat> mats;
        mats.reserve(images->count);
        for (int i = 0; i < images->count; i++)
        {
            cv::Mat mat;
            char error[256] = {0};
            if (!image_to_mat(images->images[i], mat, error))
            {
                set_error(output, error);
                return -1;
            }
            mats.push_back(mat);
        }

        cv::Ptr<cv::Stitcher> stitcher = cv::Stitcher::create(cv::Stitcher::PANORAMA);
        stitcher->setRegistrationResol(registration_resol);
        stitcher->setSeamEstimationResol(seam_estimation_resol);
        stitcher->setCompositingResol(compositing_resol);
        stitcher->setPanoConfidenceThresh(pano_confidence_thresh);
        stitcher->setWaveCorrection(wave_correction != 0);
        stitcher->setWaveCorrectKind(cv::detail::WAVE_CORRECT_HORIZ);
        stitcher->setExposureCompensator(cv::makePtr<cv::detail::GainCompensator>());
        stitcher->setBlender(cv::makePtr<cv::detail::MultiBandBlender>(false, blender_bands));

        cv::Mat pano;
        cv::Stitcher::Status status = stitcher->stitch(mats, pano);
        if (status != cv::Stitcher::OK)
        {
            set_error(output, stitch_status_message(status));
            return -1;
        }

        if (!mat_to_image(pano, output))
        {
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
        set_error(output, "unknown stitching failure");
        return -1;
    }
}
