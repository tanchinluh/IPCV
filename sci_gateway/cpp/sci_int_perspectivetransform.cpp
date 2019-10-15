/***********************************************************************
 * IPCV - Scilab Image Processing and Computer Vision toolbox
 * Copyright (C) 2017  Tan Chin Luh
 ***********************************************************************/


#include "common.h"

/************************************************************
* imout = int_perspectivetransform(imin,src,dst);
************************************************************/


int sci_int_perspectivetransform(char * fname,void* pvApiCtx)
{

	
	
	int iRows1 = 0;
	int iCols1 = 0;
	int iRows2 = 0;
	int iCols2 = 0;
	Mat src,dst,t_mat;
	
	Size dsize;

	CheckInputArgument(pvApiCtx, 2, 4);
	CheckOutputArgument(pvApiCtx, 0, 1);
		
	///////////////////
	//// Get Inputs //
	///////////////////


	GetImage(1,src,pvApiCtx);
	GetImage(2,t_mat,pvApiCtx);
	t_mat = t_mat.t();
	Mat mat( 3, 3, CV_64F, t_mat.data);
	//mat.data = t_mat.data;

	double* ww = NULL;
	double* hh = NULL;

	//GetDouble(3,ww,iRows1,iCols1);
	GetDouble(3,ww,iRows2,iCols2,pvApiCtx);
	double width = *ww;
	GetDouble(4,hh,iRows1,iCols1,pvApiCtx);
	double height = *hh;
	
	//sciprint("cc : %f\t%f\n",height,width);

	dst = Mat::zeros((int)height, (int)width, src.type());
	//dsize = Size(round((int)ww),round((int)hh));
	//sciprint("3\n");
	warpPerspective( src, dst, mat, dst.size());
	//sciprint("4\n");

	SetImage(1,dst,pvApiCtx);
	return 0;


	//// Initialization
	//IplImage *pSrcImg = NULL;
	//IplImage *pDstImg = NULL;
	//CvMat* warp_mat  = cvCreateMat(3,3,CV_64F); // Extra
	//SciErr sciErr;
	//int m1 = 0, n1 = 0;
	//int *piAddressVarOne = NULL;
	//double *matrixOfDouble = NULL;
	//int m3,n3,o3;
	//int m4,n4,o4;

	//// Checking numbers of Arguments
	//CheckRhs(4, 4);
	//CheckLhs(1, 1);

	//// Creating images
	//pSrcImg = Mat2IplImg(1);

	//// Getting warpMatrix
	//sciErr = getVarAddressFromPosition(pvApiCtx, 2, &piAddressVarOne);
	//if (sciErr.iErr)
	//{	printError(&sciErr, 0);
	//return 0;}

	///* Check that the first input argument is a real matrix (and not complex) */
	//if ( !isDoubleType(pvApiCtx, piAddressVarOne) ||  isVarComplex(pvApiCtx, piAddressVarOne) )
	//{	Scierror(999, "%s: Wrong type for input argument #%d: A real matrix expected.\n", fname, 1);
	//return 0;}

	///* get matrix */
	//sciErr = getMatrixOfDouble(pvApiCtx, piAddressVarOne, &m1, &n1, &matrixOfDouble);
	//if (sciErr.iErr)
	//{	printError(&sciErr, 0);
	//return 0;}

	//warp_mat->data.db = matrixOfDouble;

	//int width,height;
	//// Get output size
	//GetRhsVar(3, "i", &m3, &n3, &o3);
	//width = *istk(o3);

	//GetRhsVar(4, "i", &m4, &n4, &o4);
	//height = *istk(o4);


	//// Create output Image size

	//pDstImg = cvCreateImage(cvSize(width, height),pSrcImg->depth, pSrcImg->nChannels);
	////pDstImg = cvCreateImage(cvSize(364, 366),pSrcImg->depth, pSrcImg->nChannels);

	//// Apply the Affine Transform just found to the src image
	//cvWarpPerspective( pSrcImg, pDstImg, warp_mat);

	//// Export output image
	//IplImg2Mat(pDstImg, Rhs+1);
	//LhsVar(1) = Rhs+1;

	//// Cleaning up
	//cvReleaseImage( &pSrcImg );
	//cvReleaseImage( &pDstImg );
	//cvReleaseMat( &warp_mat );

	//return 0;


}
