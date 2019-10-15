/***********************************************************************
 * IPCV - Scilab Image Processing and Computer Vision toolbox
 * Copyright (C) 2017  Tan Chin Luh
***********************************************************************/

#include "common.h"


/************************************************************
* imout = sci_int_dnn_init(imin, se);
************************************************************/

/* Find best class for the blob (i. e. class with maximal probability) */

int sci_int_dnn_init(char * fname, void* pvApiCtx)
{
	Mat pSrcImg, pDstImg;
	int iRet = 0;
	int nCurrFile = 0;
	int *pret = &nCurrFile;
	int iRows = 0;
	int iCols = 0;
	double *sz1 = NULL;
	int sz2;
	char *modelTxtptr = NULL;
	char *modelBinptr = NULL;
	double *out = NULL;
	int typeDNN = -1;
	double er = -1;

	double* pdblReal1 = NULL;
	pdblReal1 = &er;

	int iRows1 = 1;
	int iCols1 = 1;

	CheckInputArgument(pvApiCtx, 2, 3);
	CheckOutputArgument(pvApiCtx, 0, 1);


	GetString(1, modelBinptr, pvApiCtx);
	GetString(2, modelTxtptr, pvApiCtx);
	GetDouble(3, out, iRows, iCols, pvApiCtx);
	typeDNN = round(*out);


	String modelTxt = modelTxtptr; // "C:/Users/chinluh/Desktop/IPCV_DNN/bvlc_googlenet.prototxt";
	String modelBin = modelBinptr; //  "C:/Users/chinluh/Desktop/IPCV_DNN/bvlc_googlenet.caffemodel";


	try
	{
		// Check how many models already loaded, and continue after the last opened number
		for (nCurrFile = 0; nCurrFile < MAX_DL_NUM; nCurrFile++)
		{
			if ((DeepNet[nCurrFile].net.empty()))
				break;
		}

		// It should not more than defined number of camera/avifile open
		if (nCurrFile == MAX_DL_NUM)
		{
			Scierror(999, "%s: Too many DNN model loaded. Use dnn_unload or dnn_unloadall to close some models.\r\n", fname);
			return -1;
		}


		switch (typeDNN) {
		case 1: {
			sciprint("Loading Caffe Model: %s\n", modelBin.c_str());
			DeepNet[nCurrFile].net = dnn::readNetFromCaffe(modelTxt, modelBin);
			break; }       // and exits the switch
		case 2: {
			sciprint("Loading Tensorflow Model: %s\n", modelBin.c_str());
			DeepNet[nCurrFile].net = dnn::readNetFromTensorflow(modelBin, modelTxt);
			//DeepNet[nCurrFile].net = dnn::readNetFromTensorflow(modelBin);
			break; }
		case 3: {
			sciprint("Loading Darknet (YOLO) Model: %s\n", modelBin.c_str());
			DeepNet[nCurrFile].net = dnn::readNetFromDarknet(modelTxt, modelBin);
			break; }
		case 4: {
			sciprint("Loading ONNX Model: %s\n", modelBin.c_str());
			DeepNet[nCurrFile].net = dnn::readNetFromONNX(modelBin);
			break; }
		}

		//DeepNet[nCurrFile].net = dnn::readNet(modelBin, modelTxt);



		//if (DeepNet[nCurrFile].net.empty())
		//{
		//	sciprint("Can't load network by using the following files: ");
		//	sciprint("prototxt:   %s\n" , modelTxt);
		//	sciprint("caffemodel: %s\n" , modelBin);
		//	sciprint("bvlc_googlenet.caffemodel can be downloaded here:");
		//	sciprint("http://dl.caffe.berkeleyvision.org/bvlc_googlenet.caffemodel");
		//	exit(-1);
		//}
		//

		//the output is the opened index
		nCurrFile += 1;
		iRet = createScalarDouble(pvApiCtx, nbInputArgument(pvApiCtx) + 1, (double)*pret);
		AssignOutputVariable(pvApiCtx, 1) = nbInputArgument(pvApiCtx) + 1;


		//return 0;
	}
	catch (const cv::Exception& e)
	{

		sciprint("Error: %s \n", e.err.c_str());
		iRet = createScalarDouble(pvApiCtx, nbInputArgument(pvApiCtx) + 1, -1);
		AssignOutputVariable(pvApiCtx, 1) = nbInputArgument(pvApiCtx) + 1;

	}

	return 0;

}
