#include "ipcv_gateway_common.h"
#include "ipcv_gateway_image.h"

#include <string.h>

extern "C" int sci_int_imreadmulti(char *fname, void *pvApiCtx)
{
    SciErr sciErr;
    char *filename = NULL;
    int *flagsAddr = NULL;
    unsigned char flags = 0;
    IpcvDecodedImageStack stack;

    memset(&stack, 0, sizeof(stack));
    CheckInputArgument(pvApiCtx, 2, 2);
    CheckOutputArgument(pvApiCtx, 0, 1);

    GetString(1, filename, pvApiCtx);

    sciErr = getVarAddressFromPosition(pvApiCtx, 2, &flagsAddr);
    if (sciErr.iErr)
    {
        printError(&sciErr, 0);
        return sciErr.iErr;
    }

    int iRet = getScalarUnsignedInteger8(pvApiCtx, flagsAddr, &flags);
    if (iRet)
    {
        return iRet;
    }

    iRet = ipcv_decode_image_stack(filename, static_cast<int>(flags), &stack);
    if (iRet)
    {
        Scierror(999, "%s: %s: %s\n", fname, stack.error, filename);
        ipcv_free_decoded_image_stack(&stack);
        return iRet;
    }

    iRet = ipcv_set_image_stack_argument(pvApiCtx, 1, stack);
    ipcv_free_decoded_image_stack(&stack);
    return iRet;
}
