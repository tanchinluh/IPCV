#include "ipcv_gateway_common.h"
#include "ipcv_image_io.h"

int sci_int_imreadable(char *fname, void* pvApiCtx)
{
    char *filename = NULL;

    CheckInputArgument(pvApiCtx, 1, 1);
    CheckOutputArgument(pvApiCtx, 1, 1);

    int iRet = GetString(1, filename, pvApiCtx);
    if (iRet || filename == NULL)
    {
        Scierror(999, "%s: Wrong type for input argument #%d: A scalar string expected.\n", fname, 1);
        return -1;
    }

    int supported = 0;
    char error[1024] = {0};
    iRet = ipcv_have_image_reader(filename, &supported, error, sizeof(error));
    freeAllocatedSingleString(filename);
    if (iRet)
    {
        Scierror(999, "%s: Could not check image reader: %s\r\n", fname, error);
        return -1;
    }

    iRet = createScalarBoolean(pvApiCtx, nbInputArgument(pvApiCtx) + 1, supported ? TRUE : FALSE);
    if (iRet)
    {
        return iRet;
    }
    AssignOutputVariable(pvApiCtx, 1) = nbInputArgument(pvApiCtx) + 1;
    return 0;
}
