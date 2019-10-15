/***********************************************************************
 * IPCV - Scilab Image Processing and Computer Vision toolbox
 * Copyright (C) 2017  Tan Chin Luh
 ***********************************************************************/


#include "common.h"

/************************************************************
* imout = sci_getperspectivetransform(imin,src,dst);
************************************************************/


int sci_int_getperspectivetransform(char * fname,void* pvApiCtx)
{

	// Initialization
	SciErr sciErr;
	//CvMat* warp_mat  = cvCreateMat(3,3,CV_64F); // Extra
	Point2f srcTri[4];
	Point2f dstTri[4];
	int mRow = 0, mCol = 0, nRow = 0, nCol = 0;
	int mOne = 1;
	int oRow = 0,oCol = 0;
	double *oData = NULL;
	int iRows1 = 0;
	int iCols1 = 0;
	int iRows2 = 0;
	int iCols2 = 0;
	int iRows			= 0;
	int iCols			= 0;
	double* mData = NULL;
	double* nData = NULL;
	// Checking numbers of Arguments
	CheckInputArgument(pvApiCtx, 2, 2);
	CheckOutputArgument(pvApiCtx, 0, 3);


	GetDouble(1,mData,iRows1,iCols1,pvApiCtx);
	GetDouble(2,nData,iRows1,iCols1,pvApiCtx);

	//srcTri[0] = cvPoint2D32f(stk(mData)[0],stk(mData)[4]);
	//srcTri[1] = cvPoint2D32f(stk(mData)[1],stk(mData)[5]);
	//srcTri[2] = cvPoint2D32f(stk(mData)[2],stk(mData)[6]);
	//srcTri[3] = cvPoint2D32f(stk(mData)[3],stk(mData)[7]);
	srcTri[0] = Point2f(*(mData),*(mData+4));
	srcTri[1] = Point2f(*(mData+1),*(mData+5));
	srcTri[2] = Point2f(*(mData+2),*(mData+6));
	srcTri[3] = Point2f(*(mData+3),*(mData+7));


	//dstTri[0] = cvPoint2D32f(stk(nData)[0],stk(nData)[4]);
	//dstTri[1] = cvPoint2D32f(stk(nData)[1],stk(nData)[5]);
	//dstTri[2] = cvPoint2D32f(stk(nData)[2],stk(nData)[6]);
	//dstTri[3] = cvPoint2D32f(stk(nData)[3],stk(nData)[7]);
	dstTri[0] = Point2f(*(nData),*(nData+4));
	dstTri[1] = Point2f(*(nData+1),*(nData+5));
	dstTri[2] = Point2f(*(nData+2),*(nData+6));
	dstTri[3] = Point2f(*(nData+3),*(nData+7));

	// Get the Affine Transform
	Mat warp_mat = getPerspectiveTransform( srcTri, dstTri);

	// Apply the Affine Transform just found to the src image
	//cvWarpAffine( pSrcImg, pDstImg, warp_mat);

	SetImage(1, warp_mat, pvApiCtx);


	return 0;


}
