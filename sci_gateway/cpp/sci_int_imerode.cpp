/***********************************************************************
 * IPCV - Scilab Image Processing and Computer Vision toolbox
 * Copyright (C) 2017  Tan Chin Luh
 ***********************************************************************/

#include "common.h"

/************************************************************
* imout = int_imerode(imin, se);
************************************************************/


int sci_int_imerode(char * fname,void* pvApiCtx)
{

	Mat src;
	Mat dst;
	Mat se;

	GetImage(1,src,pvApiCtx);
	GetImage(2,se,pvApiCtx);

	erode(src,dst,se);

	SetImage(1,dst,pvApiCtx);

	

	return 0;


}
