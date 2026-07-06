/***********************************************************************
 * SIVP - Scilab Image and Video Processing toolbox
 * Copyright (C) 2006  Shiqi Yu
 *
 * IPCV - Scilab Image Processing and Computer Vision toolbox
 * Copyright (C) 2017  Tan Chin Luh
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version.
 ***********************************************************************/

#include "common.h"
#include "ipcv_gateway_image.h"

int sci_imadd(char *fname, void *pvApiCtx)
{
    return ipcv_run_binary_arithmetic(fname, pvApiCtx, IPCV_ARITH_ADD);
}
