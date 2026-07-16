#include "ipcv_gateway_common.h"
#include "ipcv_gateway_image.h"
#include "ipcv_geometry.h"

int sci_int_imestimatefundamental(char *fname, void *pvApiCtx)
{
    double *points1 = NULL; double *points2 = NULL; int rows1 = 0, cols1 = 0, rows2 = 0, cols2 = 0; IpcvDoubleMatrix result; std::memset(&result, 0, sizeof(result));
    CheckInputArgument(pvApiCtx, 2, 2); CheckOutputArgument(pvApiCtx, 1, 1);
    if (GetDouble(1, points1, rows1, cols1, pvApiCtx) || GetDouble(2, points2, rows2, cols2, pvApiCtx)) { Scierror(999, "%s: two numeric point matrices expected.\n", fname); return -1; }
    int iRet = ipcv_estimate_fundamental(points1, rows1, cols1, points2, rows2, cols2, &result);
    if (iRet) { Scierror(999, "%s: %s\n", fname, result.error); return iRet; }
    SciErr sciErr = createMatrixOfDouble(pvApiCtx, 3, result.rows, result.cols, result.data); if (sciErr.iErr) return sciErr.iErr;
    AssignOutputVariable(pvApiCtx, 1) = 3; ipcv_free_double_matrix(&result); return 0;
}
