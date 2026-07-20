#ifndef IPCV_DICOM_H
#define IPCV_DICOM_H

#include "ipcv_volume.h"

#ifdef __cplusplus
extern "C" {
#endif

typedef struct IpcvDicomInfo
{
    int rows;
    int cols;
    int frames;
    int samples_per_pixel;
    int bits_allocated;
    int bits_stored;
    int high_bit;
    int pixel_representation;
    int planar_configuration;
    double rescale_slope;
    double rescale_intercept;
    double window_center;
    double window_width;
    double pixel_spacing_row;
    double pixel_spacing_col;
    double slice_thickness;
    double spacing_between_slices;
    double raw_minimum;
    double raw_maximum;
    int rescale_applied;
    char transfer_syntax_uid[128];
    char sop_class_uid[128];
    char modality[32];
    char photometric_interpretation[32];
    char patient_name[128];
    char patient_id[64];
    char study_date[32];
    char study_description[128];
    char series_description[128];
    char manufacturer[128];
    char study_instance_uid[128];
    char series_instance_uid[128];
} IpcvDicomInfo;

IPCV_CORE_API int ipcv_read_dicom(const char *filename, int apply_rescale,
    IpcvVolume *volume, IpcvDicomInfo *info);

#ifdef __cplusplus
}
#endif

#endif
