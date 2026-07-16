#include "ipcv_gateway_common.h"
#include "ipcv_gateway_image.h"
#include "ipcv_geometry.h"

int sci_int_imsolvepnp(char *fname, void *pvApiCtx)
{
    double *object = NULL; double *image = NULL; double *camera = NULL; double *distortion = NULL;
    int objectRows = 0, objectCols = 0, imageRows = 0, imageCols = 0, cameraRows = 0, cameraCols = 0, distortionRows = 0, distortionCols = 0;
    IpcvDoubleMatrix rvec; IpcvDoubleMatrix tvec; std::memset(&rvec, 0, sizeof(rvec)); std::memset(&tvec, 0, sizeof(tvec));
    CheckInputArgument(pvApiCtx, 3, 4); CheckOutputArgument(pvApiCtx, 2, 2);
    if (GetDouble(1, object, objectRows, objectCols, pvApiCtx) || GetDouble(2, image, imageRows, imageCols, pvApiCtx) || GetDouble(3, camera, cameraRows, cameraCols, pvApiCtx))
    { Scierror(999, "%s: numeric point and camera matrices expected.\n", fname); return -1; }
    if (nbInputArgument(pvApiCtx) == 4 && GetDouble(4, distortion, distortionRows, distortionCols, pvApiCtx)) { Scierror(999, "%s: numeric distortion coefficients expected.\n", fname); return -1; }
    int iRet = ipcv_solve_pnp(object, objectRows, objectCols, image, imageRows, imageCols, camera, cameraRows, cameraCols, distortion, distortionRows, distortionCols, &rvec, &tvec);
    if (iRet) { Scierror(999, "%s: %s\n", fname, rvec.error); return iRet; }
    int outputRotation = nbInputArgument(pvApiCtx) + 1;
    int outputTranslation = nbInputArgument(pvApiCtx) + 2;
    SciErr sciErr = createMatrixOfDouble(pvApiCtx, outputRotation, rvec.rows, rvec.cols, rvec.data); if (sciErr.iErr) return sciErr.iErr;
    sciErr = createMatrixOfDouble(pvApiCtx, outputTranslation, tvec.rows, tvec.cols, tvec.data); if (sciErr.iErr) return sciErr.iErr;
    AssignOutputVariable(pvApiCtx, 1) = outputRotation; AssignOutputVariable(pvApiCtx, 2) = outputTranslation;
    ipcv_free_double_matrix(&rvec); ipcv_free_double_matrix(&tvec); return 0;
}
