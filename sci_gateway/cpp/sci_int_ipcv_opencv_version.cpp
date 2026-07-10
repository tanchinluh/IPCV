#include "ipcv_gateway_common.h"

extern "C" int sci_int_ipcv_opencv_version(char *fname, void *pvApiCtx)
{
    CheckInputArgument(pvApiCtx, 0, 0);
    CheckOutputArgument(pvApiCtx, 0, 1);

    const int outVar = nbInputArgument(pvApiCtx) + 1;
    const int status = createSingleString(pvApiCtx, outVar, CV_VERSION);
    if (status)
    {
        Scierror(999, "%s: Could not create OpenCV version output.\n", fname);
        return status;
    }

    AssignOutputVariable(pvApiCtx, 1) = outVar;
    ReturnArguments(pvApiCtx);
    return 0;
}
