#include "ipcv_gateway_volume.h"

extern "C" int sci_int_imlabeln3(char *fname, void *pvApiCtx)
{
    CheckInputArgument(pvApiCtx, 2, 2);
    CheckOutputArgument(pvApiCtx, 2, 2);
    IpcvVolume source, labels;
    std::memset(&labels, 0, sizeof(labels));
    int *address = NULL;
    double connectivity = 0.0;
    int result = ipcv_get_volume_argument(pvApiCtx, 1, source);
    SciErr error = getVarAddressFromPosition(pvApiCtx, 2, &address);
    if (!result && !error.iErr) result = getScalarDouble(pvApiCtx, address, &connectivity);
    int count = 0;
    if (!result) result = ipcv_label_volume(&source,
        static_cast<int>(std::round(connectivity)), &labels, &count);
    ipcv_release_volume_argument(source);
    if (result)
    {
        Scierror(999, "%s: %s\n", fname,
            labels.error[0] ? labels.error : "invalid input");
        ipcv_free_volume(&labels);
        return result;
    }
    result = ipcv_set_volume_argument(pvApiCtx, 1, labels, 0);
    if (!result)
    {
        result = createScalarDouble(pvApiCtx, nbInputArgument(pvApiCtx) + 2,
            static_cast<double>(count));
        AssignOutputVariable(pvApiCtx, 2) = nbInputArgument(pvApiCtx) + 2;
    }
    ipcv_free_volume(&labels);
    return result;
}
