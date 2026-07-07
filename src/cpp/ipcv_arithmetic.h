#ifndef IPCV_ARITHMETIC_H
#define IPCV_ARITHMETIC_H

#include "ipcv_image_io.h"

#ifdef __cplusplus
extern "C" {
#endif

enum
{
    IPCV_ARITH_ADD = 1,
    IPCV_ARITH_SUBTRACT = 2,
    IPCV_ARITH_MULTIPLY = 3,
    IPCV_ARITH_DIVIDE = 4,
    IPCV_ARITH_ABSDIFF = 5
};

IPCV_CORE_API int ipcv_binary_arithmetic(const IpcvDecodedImage *left, const IpcvDecodedImage *right, int operation, IpcvDecodedImage *output);

#ifdef __cplusplus
}
#endif

#endif
