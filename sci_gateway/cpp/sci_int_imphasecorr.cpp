#include "ipcv_gateway_common.h"
#include "ipcv_gateway_image.h"

#include <cstring>

int sci_int_imphasecorr(char *fname, void *pvApiCtx)
{
    IpcvDecodedImage target;
    IpcvDecodedImage source;
    IpcvDecodedImage registeredImage;
    std::memset(&registeredImage, 0, sizeof(registeredImage));
    double translation[2] = {0.0, 0.0};
    double rotation = 0.0;
    double scale = 1.0;

    CheckInputArgument(pvApiCtx, 2, 2);
    CheckOutputArgument(pvApiCtx, 1, 4);

    int iRet = ipcv_get_image_argument(pvApiCtx, 1, target);
    if (iRet)
    {
        Scierror(999, "%s: target image expected.\n", fname);
        return iRet;
    }
    iRet = ipcv_get_image_argument(pvApiCtx, 2, source);
    if (iRet)
    {
        ipcv_release_image_argument(target);
        Scierror(999, "%s: source image expected.\n", fname);
        return iRet;
    }

    iRet = ipcv_phase_register_image(&target, &source, &registeredImage, translation, &rotation, &scale);
    ipcv_release_image_argument(target);
    ipcv_release_image_argument(source);
    if (iRet)
    {
        Scierror(999, "%s: %s\n", fname, registeredImage.error);
        ipcv_free_decoded_image(&registeredImage);
        return iRet;
    }

    iRet = ipcv_set_image_argument(pvApiCtx, 1, registeredImage);
    ipcv_free_decoded_image(&registeredImage);
    if (iRet) return iRet;

    const int outputTranslation = nbInputArgument(pvApiCtx) + 2;
    const int outputRotation = nbInputArgument(pvApiCtx) + 3;
    const int outputScale = nbInputArgument(pvApiCtx) + 4;

    SciErr sciErr = createMatrixOfDouble(pvApiCtx, outputTranslation, 1, 2, translation);
    if (sciErr.iErr) return sciErr.iErr;
    sciErr = createMatrixOfDouble(pvApiCtx, outputRotation, 1, 1, &rotation);
    if (sciErr.iErr) return sciErr.iErr;
    sciErr = createMatrixOfDouble(pvApiCtx, outputScale, 1, 1, &scale);
    if (sciErr.iErr) return sciErr.iErr;

    AssignOutputVariable(pvApiCtx, 1) = nbInputArgument(pvApiCtx) + 1;
    AssignOutputVariable(pvApiCtx, 2) = outputTranslation;
    AssignOutputVariable(pvApiCtx, 3) = outputRotation;
    AssignOutputVariable(pvApiCtx, 4) = outputScale;
    return 0;
}
