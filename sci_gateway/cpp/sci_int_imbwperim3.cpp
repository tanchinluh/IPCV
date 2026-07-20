#include "ipcv_gateway_volume.h"

extern "C" int sci_int_imbwperim3(char *fname, void *pvApiCtx)
{
    CheckInputArgument(pvApiCtx, 2, 2);
    CheckOutputArgument(pvApiCtx, 1, 1);
    IpcvVolume source, output;
    std::memset(&output, 0, sizeof(output));
    int *address = NULL;
    double connectivity = 0.0;
    int result = ipcv_get_volume_argument(pvApiCtx, 1, source);
    SciErr error = getVarAddressFromPosition(pvApiCtx, 2, &address);
    if (!result && !error.iErr) result = getScalarDouble(pvApiCtx, address, &connectivity);
    if (!result) result = ipcv_perimeter_volume(&source,
        static_cast<int>(std::round(connectivity)), &output);
    ipcv_release_volume_argument(source);
    if (result)
    {
        Scierror(999, "%s: %s\n", fname,
            output.error[0] ? output.error : "invalid input");
        ipcv_free_volume(&output);
        return result;
    }
    result = ipcv_set_volume_argument(pvApiCtx, 1, output, 1);
    ipcv_free_volume(&output);
    return result;
}
