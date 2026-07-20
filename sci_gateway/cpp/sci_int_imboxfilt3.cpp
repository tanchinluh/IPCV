#include "ipcv_gateway_volume.h"

extern "C" int sci_int_imboxfilt3(char *fname, void *pvApiCtx)
{
    CheckInputArgument(pvApiCtx, 2, 2);
    CheckOutputArgument(pvApiCtx, 1, 1);
    IpcvVolume source, output;
    std::memset(&output, 0, sizeof(output));
    int *address = NULL, rows = 0, cols = 0;
    double *values = NULL;
    int result = ipcv_get_volume_argument(pvApiCtx, 1, source);
    SciErr error = getVarAddressFromPosition(pvApiCtx, 2, &address);
    if (!result && !error.iErr)
    {
        error = getMatrixOfDouble(pvApiCtx, address, &rows, &cols, &values);
        result = error.iErr;
    }
    int window[3] = {0, 0, 0};
    if (!result)
    {
        if (rows * cols != 3) result = -1;
        else for (int i = 0; i < 3; ++i)
            window[i] = static_cast<int>(std::round(values[i]));
    }
    if (!result) result = ipcv_box_filter_volume(&source, window, &output);
    ipcv_release_volume_argument(source);
    if (result)
    {
        Scierror(999, "%s: %s\n", fname,
            output.error[0] ? output.error : "window must contain three values");
        ipcv_free_volume(&output);
        return result;
    }
    result = ipcv_set_volume_argument(pvApiCtx, 1, output, 0);
    ipcv_free_volume(&output);
    return result;
}
