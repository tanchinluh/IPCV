#include "ipcv_gateway_volume.h"
#include "ipcv_dicom.h"

extern "C" int sci_int_dicomread(char *fname, void *pvApiCtx)
{
    CheckInputArgument(pvApiCtx, 2, 2);
    CheckOutputArgument(pvApiCtx, 3, 3);

    int *filename_address = NULL;
    int *rescale_address = NULL;
    char *filename = NULL;
    double apply_rescale = 1.0;
    SciErr error = getVarAddressFromPosition(pvApiCtx, 1, &filename_address);
    if (error.iErr)
    {
        printError(&error, 0);
        return error.iErr;
    }
    if (!isStringType(pvApiCtx, filename_address) ||
        !isScalar(pvApiCtx, filename_address))
    {
        Scierror(999, "%s: A scalar filename string is required.\n", fname);
        return -1;
    }
    int result = getAllocatedSingleString(pvApiCtx, filename_address, &filename);
    if (result || filename == NULL)
    {
        Scierror(999, "%s: Could not read the DICOM filename.\n", fname);
        return result ? result : -1;
    }
    error = getVarAddressFromPosition(pvApiCtx, 2, &rescale_address);
    if (error.iErr)
    {
        printError(&error, 0);
        freeAllocatedSingleString(filename);
        return error.iErr;
    }
    result = getScalarDouble(pvApiCtx, rescale_address, &apply_rescale);
    if (result)
    {
        freeAllocatedSingleString(filename);
        return result;
    }

    IpcvVolume volume;
    IpcvDicomInfo info;
    std::memset(&volume, 0, sizeof(volume));
    std::memset(&info, 0, sizeof(info));
    result = ipcv_read_dicom(filename, apply_rescale != 0.0, &volume, &info);
    freeAllocatedSingleString(filename);
    if (result)
    {
        Scierror(999, "%s: %s\n", fname,
            volume.error[0] ? volume.error : "could not decode DICOM file");
        ipcv_free_volume(&volume);
        return result;
    }

    result = ipcv_set_volume_argument(pvApiCtx, 1, volume, 0);
    if (result)
    {
        ipcv_free_volume(&volume);
        return result;
    }

    double numeric[20] = {
        static_cast<double>(info.rows),
        static_cast<double>(info.cols),
        static_cast<double>(info.frames),
        static_cast<double>(info.samples_per_pixel),
        static_cast<double>(info.bits_allocated),
        static_cast<double>(info.bits_stored),
        static_cast<double>(info.high_bit),
        static_cast<double>(info.pixel_representation),
        static_cast<double>(info.planar_configuration),
        info.rescale_slope,
        info.rescale_intercept,
        info.window_center,
        info.window_width,
        info.pixel_spacing_row,
        info.pixel_spacing_col,
        info.slice_thickness,
        info.spacing_between_slices,
        info.raw_minimum,
        info.raw_maximum,
        static_cast<double>(info.rescale_applied)
    };
    const int numeric_output = nbInputArgument(pvApiCtx) + 2;
    error = createMatrixOfDouble(pvApiCtx, numeric_output, 20, 1, numeric);
    if (error.iErr)
    {
        printError(&error, 0);
        ipcv_free_volume(&volume);
        return error.iErr;
    }
    AssignOutputVariable(pvApiCtx, 2) = numeric_output;

    char *text[12] = {
        info.transfer_syntax_uid,
        info.sop_class_uid,
        info.modality,
        info.photometric_interpretation,
        info.patient_name,
        info.patient_id,
        info.study_date,
        info.study_description,
        info.series_description,
        info.manufacturer,
        info.study_instance_uid,
        info.series_instance_uid
    };
    const int text_output = nbInputArgument(pvApiCtx) + 3;
    error = createMatrixOfString(pvApiCtx, text_output, 12, 1, text);
    ipcv_free_volume(&volume);
    if (error.iErr)
    {
        printError(&error, 0);
        return error.iErr;
    }
    AssignOutputVariable(pvApiCtx, 3) = text_output;
    return 0;
}
