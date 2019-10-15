/***********************************************************************
 * IPCV - Scilab Image Processing and Computer Vision toolbox
 * Copyright (C) 2017  Tan Chin Luh
 ***********************************************************************/


#include "common.h"


/************************************************************
* se = int_imcreatese(type,r,c);   
************************************************************/


int sci_int_imcreatese(char * fname,void* pvApiCtx)
{

	CheckInputArgument(pvApiCtx, 3, 3);
	CheckOutputArgument(pvApiCtx, 0, 1);

	SciErr sciErr;
	int* piAddr     = NULL;
	int iType       = 0;
	int iRet        = 0;
	int iPrec       = 0;
	char cData1  = 0;
	char cData2  = 0;
	char cData3  = 0;

	getVarAddressFromPosition(pvApiCtx, 1, &piAddr);
	getScalarInteger8(pvApiCtx, piAddr, &cData1);

	getVarAddressFromPosition(pvApiCtx, 2, &piAddr);
	getScalarInteger8(pvApiCtx, piAddr, &cData2);

	getVarAddressFromPosition(pvApiCtx, 3, &piAddr);
	getScalarInteger8(pvApiCtx, piAddr, &cData3);


	//sciprint("%i \t %i \t %i \t\n",cData1,cData2,cData3);
	//// Initialization
	Mat element = getStructuringElement( cData1, Size( cData3, cData2 ), Point( -1,-1) );
	SetImage(1,element,pvApiCtx);
	
	//int sRow = 0, sCol = 0, sData = 0;
	//int mRow = 0, mCol = 0, mData = 0;
	//int nRow = 0, nCol = 0, nData = 0;
	//int row = 0, col = 0, shape = 0;
	//int *oData = NULL;
	//IplConvKernel *se = NULL;

	//// Check arguments

	//CheckRhs(3, 3);
	//CheckLhs(1, 1);

	//// Get Parameters
	//GetRhsVar(1, "i", &sRow, &sCol, &sData);
	//shape = *istk(sData);

	//GetRhsVar(2, "i", &mRow, &mCol, &mData);
	//col = *istk(mData);

	//GetRhsVar(3, "i", &nRow, &nCol, &nData);
	//row = *istk(nData);

	//se = cvCreateStructuringElementEx(col, row, round(col/2),round(row/2), shape, NULL);

	//// Create output
	//oData = (se->values);
	//CreateVarFromPtr(Rhs+1,"i",&col,&row,&oData);
	//LhsVar(1) = Rhs + 1;

	// Cleaning up???

	return 0;


}
