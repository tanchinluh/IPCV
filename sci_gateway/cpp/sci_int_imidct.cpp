/***********************************************************************
 * IPCV - Scilab Image Processing and Computer Vision toolbox
 * Copyright (C) 2017  Tan Chin Luh
 ***********************************************************************/


#include "common.h"



/************************************************************
* y = int_imidct(x);
************************************************************/

int sci_int_imidct(char * fname,void* pvApiCtx)
{

	CheckInputArgument(pvApiCtx, 1, 1);
	CheckOutputArgument(pvApiCtx, 1, 1);

	/////////////////
	// First Input //
	/////////////////
	Mat pSrcImg;
	GetImage(1,pSrcImg,pvApiCtx);
	/////////////////
	Mat pDstImg = pSrcImg;
	//
	dct( pSrcImg, pDstImg,1);
	//sciprint("dims : %i\n",pSrcImg.dims);
	//sciprint("dims : %i\n",pSrcImg.dims);
	//
	SetImage(1,pDstImg,pvApiCtx);

	return 0;


}
