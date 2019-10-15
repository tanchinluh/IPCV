/***********************************************************************
 * IPCV - Scilab Image Processing and Computer Vision toolbox
 * Copyright (C) 2017  Tan Chin Luh
 ***********************************************************************/

#include "common.h"

/************************************************************
* imout = sci_getaffinetransform(imin,src,dst);
************************************************************/


int sci_int_getaffinetransform(char * fname,void* pvApiCtx)
{

	SciErr sciErr;
	//CvMat* warp_mat  = cvCreateMat(2,3,CV_64F); // Extra
	//Mat warp_mat;
	Point2f srcTri[3];
	Point2f dstTri[3];
	int mRow, mCol, nRow, nCol;
	int mOne = 1;
	int oRow,oCol;
	double *oData;
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

	srcTri[0] = Point2f(*(mData),*(mData+3));
	srcTri[1] = Point2f(*(mData+1),*(mData+4));
	srcTri[2] = Point2f(*(mData+2),*(mData+5));

	dstTri[0] = Point2f(*(nData),*(nData+3));
	dstTri[1] = Point2f(*(nData+1),*(nData+4));
	dstTri[2] = Point2f(*(nData+2),*(nData+5));

	// Get the Affine Transform
	//cvGetAffineTransform( srcTri, dstTri, warp_mat);
	Mat warp_mat = getAffineTransform(srcTri, dstTri);

	//// Export output image
	//oData = warp_mat.data.db;
	//oCol = warp_mat.cols;
	//oRow = warp_mat.rows;

	//sciErr = createMatrixOfDouble(pvApiCtx, nbInputArgument(pvApiCtx) + 1, oCol, oRow,oData);
	//if(sciErr.iErr)
	//{
	//	printError(&sciErr, 0);
	//	return sciErr.iErr;
	//}


	//AssignOutputVariable(pvApiCtx, 1) = nbInputArgument(pvApiCtx) + 1;
	
	SetImage(1, warp_mat, pvApiCtx);
	
	return 0;

}
