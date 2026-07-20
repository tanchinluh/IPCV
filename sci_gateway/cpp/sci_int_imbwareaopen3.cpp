#include "ipcv_gateway_volume.h"

extern "C" int sci_int_imbwareaopen3(char *fname, void *pvApiCtx)
{
    CheckInputArgument(pvApiCtx, 3, 3);
    CheckOutputArgument(pvApiCtx, 1, 1);
    IpcvVolume source, output;
    std::memset(&output, 0, sizeof(output));
    double arguments[2] = {0.0, 0.0};
    int result = ipcv_get_volume_argument(pvApiCtx, 1, source);
    for (int position = 2; !result && position <= 3; ++position)
    {
        int *address = NULL;
        SciErr error = getVarAddressFromPosition(pvApiCtx, position, &address);
        if (error.iErr) result = error.iErr;
        else result = getScalarDouble(pvApiCtx, address, &arguments[position - 2]);
    }
    if (!result) result = ipcv_area_open_volume(&source,
        static_cast<int>(std::round(arguments[0])),
        static_cast<int>(std::round(arguments[1])), &output);
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
