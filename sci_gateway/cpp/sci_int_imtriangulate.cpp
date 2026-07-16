#include "ipcv_gateway_common.h"
#include "ipcv_gateway_image.h"
#include "ipcv_geometry.h"

int sci_int_imtriangulate(char *fname, void *pvApiCtx)
{
    double *points1 = NULL; double *points2 = NULL; double *projection1 = NULL; double *projection2 = NULL;
    int rows1 = 0, cols1 = 0, rows2 = 0, cols2 = 0, rowsP1 = 0, colsP1 = 0, rowsP2 = 0, colsP2 = 0; IpcvDoubleMatrix result; std::memset(&result, 0, sizeof(result));
    CheckInputArgument(pvApiCtx, 4, 4); CheckOutputArgument(pvApiCtx, 1, 1);
    if (GetDouble(1, points1, rows1, cols1, pvApiCtx) || GetDouble(2, points2, rows2, cols2, pvApiCtx) || GetDouble(3, projection1, rowsP1, colsP1, pvApiCtx) || GetDouble(4, projection2, rowsP2, colsP2, pvApiCtx)) { Scierror(999, "%s: numeric point and projection matrices expected.\n", fname); return -1; }
    int iRet = ipcv_triangulate(points1, rows1, cols1, points2, rows2, cols2, projection1, rowsP1, colsP1, projection2, rowsP2, colsP2, &result);
    if (iRet) { Scierror(999, "%s: %s\n", fname, result.error); return iRet; }
    SciErr sciErr = createMatrixOfDouble(pvApiCtx, 5, result.rows, result.cols, result.data); if (sciErr.iErr) return sciErr.iErr;
    AssignOutputVariable(pvApiCtx, 1) = 5; ipcv_free_double_matrix(&result); return 0;
}
