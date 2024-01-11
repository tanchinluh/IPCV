/***********************************************************************
 * IPCV - Scilab Image Processing and Computer Vision toolbox
 * Copyright (C) 2020  Tan Chin Luh
 ***********************************************************************/

#include "common.h"

/************************************************************
* imout = int_imdist(imin, me);
************************************************************/


int sci_int_imdist(char * fname,void* pvApiCtx)
{

	Mat src;
	Mat dst;
	Mat se;

	GetImage(1,src,pvApiCtx);

	distanceTransform(src, dst, DIST_L1, 3);

	SetImage(1,dst,pvApiCtx);

	return 0;


}
