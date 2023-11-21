/***********************************************************************
 * IPCV - Scilab Image Processing and Computer Vision toolbox
 * Copyright (C) 2017  Tan Chin Luh
***********************************************************************/

#include "common.h"
#include <string.h>
#include <stdio.h>

/************************************************************
* imout = sci_int_dnn_superres_upsample(imin, se);
************************************************************/

/* Find best class for the blob (i. e. class with maximal probability) */

int sci_int_dnn_superres_upsample(char * fname, void* pvApiCtx)
{
	Mat pSrcImg, pDstImg;
	int iRet = 0;
	int nCurrFile = 0;
	int *pret = &nCurrFile;
	int iRows = 0;
	int iCols = 0;
	double *sz1 = NULL;
	int sz2;
	char *algorithm = NULL;
	char *model_name = NULL;
	double *scale = NULL;
	int scale_int = -1;
	double er = -1;

	double* pdblReal1 = NULL;
	pdblReal1 = &er;

	int iRows1 = 1;
	int iCols1 = 1;
	Mat img_new;
	CheckInputArgument(pvApiCtx, 0, 0);
	CheckOutputArgument(pvApiCtx, 0, 1);



	try
	{
		// Check how many models already loaded, and continue after the last opened number

		int result = 0;
		// case (strcmp(*algorithm == "edsr" || *algorithm == "espcn" || *algorithm == "fsrcnn" || *algorithm == "lapsrn"):
		if (result == 0)
		{

			string img_path = "orig_butterfly.jpg";
			string algorithm = "fsrcnn";
			int scale = 4;
			//string path = "FSRCNN_x4.pb";
			Mat img = cv::imread(img_path);
			Mat original_img(img);
			

			//sciprint("Loading Caffe Model: %s\n", modelBin.c_str());
			//DeepSRNet[nCurrFile] = dnn::readNetFromCaffe(modelTxt, modelBin);
			//DeepSRNet[nCurrFile].sr.readModel(model_name);
			//sciprint("%s\n", sr.getAlgorithm());
			//sciprint("%f\n", sr.getScale());
			//DeepSRNet[0].sr.setModel(algorithm, scale_int);
			//sciprint("aaa\n");
			
			sciprint("%s\n", DeepSRNet[0].sr.getAlgorithm());
			DeepSRNet[0].sr.upsample(img, img_new);

		}       // and exits the switch
		else {
			std::cerr << "Algorithm not recognized. \n";
		}
		//case 2: {
		//	sciprint("Loading Tensorflow Model: %s\n", modelBin.c_str());
		//	DeepSRNet[nCurrFile] = dnn::readNetFromTensorflow(modelBin, modelTxt);
		//	//DeepSRNet[nCurrFile] = dnn::readNetFromTensorflow(modelBin);
		//	break; }
		//case 3: {
		//	sciprint("Loading Darknet (YOLO) Model: %s\n", modelBin.c_str());
		//	DeepSRNet[nCurrFile] = dnn::readNetFromDarknet(modelTxt, modelBin);
		//	break; }
		//case 4: {
		//	sciprint("Loading ONNX Model: %s\n", modelBin.c_str());
		//	DeepSRNet[nCurrFile] = dnn::readNetFromONNX(modelBin);
		//	break; }
		//case 5: {
		//	sciprint("Loading Torch Model: %s\n", modelBin.c_str());
		//	DeepSRNet[nCurrFile] = dnn::readNetFromTorch(modelBin);
		//	break; }
	}

	//DeepSRNet[nCurrFile] = dnn::readNet(modelBin, modelTxt);



	//if (DeepSRNet[nCurrFile].empty())
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
	//nCurrFile += 1;
	//iRet = createScalarDouble(pvApiCtx, nbInputArgument(pvApiCtx) + 1, (double)*pret);
	//AssignOutputVariable(pvApiCtx, 1) = nbInputArgument(pvApiCtx) + 1;


	//return 0;

	catch (const cv::Exception& e)
	{

		sciprint("Error: %s \n", e.err.c_str());
		iRet = createScalarDouble(pvApiCtx, nbInputArgument(pvApiCtx) + 1, -1);
		AssignOutputVariable(pvApiCtx, 1) = nbInputArgument(pvApiCtx) + 1;
		return 0;

	}
	SetImage(1, img_new, pvApiCtx);
	return 0;

}
