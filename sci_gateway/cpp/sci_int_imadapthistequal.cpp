/***********************************************************************
 * IPCV - Scilab Image Processing and Computer Vision toolbox
 * Copyright (C) 2017  Tan Chin Luh
 ***********************************************************************/


#include "common.h"
using cv::CLAHE;


/************************************************************
* y = sci_int_imadapthistequa(x);
************************************************************/


int sci_int_imadapthistequal(char * fname,void* pvApiCtx)
{


	CheckInputArgument(pvApiCtx, 1, 2);
	CheckOutputArgument(pvApiCtx, 1, 1);

	int *piAddr2 = NULL;
	double cl	= 0;
	getVarAddressFromPosition(pvApiCtx, 2, &piAddr2);
	getScalarDouble(pvApiCtx, piAddr2, &cl);
	/////////////////
	// First Input //
	/////////////////
	Mat pSrcImg, pDstImg;
	GetImage(1,pSrcImg,pvApiCtx);
	/////////////////
	//Mat pDstImg = pSrcImg;
	//
sciprint("1\n");
//imshow("aaa",pSrcImg);
//waitKey();
Ptr<CLAHE> clahe = createCLAHE();
//Ptr<CLAHE> clahe = createCLAHE(clipLimit=0.01, tileGridSize=Size(8,8))

sciprint("2\n");
//createCLAHE(clipLimit=0.01, tileGridSize=(8,8))
clahe->setClipLimit(cl);
clahe->setTilesGridSize((Size(8,8)));
sciprint("3\n");
clahe->apply(pSrcImg,pDstImg);
//imshow("lena_CLAHE",pDstImg);
sciprint("4\n");



//sciprint("1\n");

//	dct( pSrcImg, pDstImg,0);
//	sciprint("dims : %i\n",pSrcImg.dims);
	//sciprint("dims : %i\n",pSrcImg.dims);
	//
	SetImage(1,pDstImg,pvApiCtx);

	return 0;


}
