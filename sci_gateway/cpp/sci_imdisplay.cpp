/***********************************************************************
 *
 * IPCV - Scilab Image Processing and Computer Vision toolbox
 * Copyright (C) 2017  Tan Chin Luh
 *
***********************************************************************/

#include "common.h"

/**********************************************************************
* This function is using the OpenCV highgui function for plotting image
* imdisplay(imin);
**********************************************************************/
int sci_imdisplay(char * fname,void* pvApiCtx)
{



	CheckInputArgument(pvApiCtx, 1, 2);
	CheckOutputArgument(pvApiCtx, 0, 1);

	/////////////////
	// First Input //
	/////////////////
	double dblReal	= 0;
	int iRet    = 0;
	Mat pSrcImg;
	GetImage(1,pSrcImg,pvApiCtx);

	
	char *pstName = NULL;

	if(nbInputArgument(pvApiCtx) == 2)
	{
		GetString(2, pstName,pvApiCtx);
	}
	else
	{
		pstName = "Display Window";		
	}

	//namedWindow(pstName, CV_WINDOW_NORMAL);// Create a window for display.
	imshow(pstName, pSrcImg);                   // Show our image inside it.
	
	// if cv2.waitKey(1) & 0xFF == ord('q'):
	//waitKey(1);   

	if (waitKey(1) >= 0)
	{
		dblReal = -1;
		iRet = createScalarDouble(pvApiCtx, nbInputArgument(pvApiCtx) + 1, dblReal);
	}
	else
	{
		dblReal = 0;
		iRet = createScalarDouble(pvApiCtx, nbInputArgument(pvApiCtx) + 1, dblReal);
	}
	
	AssignOutputVariable(pvApiCtx, 1) = nbInputArgument(pvApiCtx) + 1;

	return 0;

	////////////

	//int mR2, nR2, lR2;
	//char *fn;
	//fn = "Original Image";
	//IplImage* pSrcImg = NULL;

	//CheckRhs(1, 2);
	//CheckLhs(1, 1);


	////load the input image
	//pSrcImg = Mat2IplImg(1);
	//
	//if (Rhs == 2)
	//{
	//	GetRhsVar(2, "c", &mR2, &nR2, &lR2);
	//	fn = cstk(lR2);
	//}

	//if(pSrcImg == NULL)
	//{
	//	Scierror(999, "%s: Internal error for getting the image data.\r\n", fname);
	//	return -1;
	//}

	// /// Create Windows
	//namedWindow(fn, 1);

	///// Show stuff
	//cvShowImage(fn,pSrcImg);
	//	waitKey(1);
	//cvReleaseImage(&pSrcImg);


	//return 0;
}
