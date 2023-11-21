/***********************************************************************
 * IPCV - Scilab Image Processing and Computer Vision toolbox
 * Copyright (C) 2017  Tan Chin Luh
***********************************************************************/

#include "common.h"
#include <string.h>
#include <stdio.h>

/************************************************************
* imout = sci_int_dnn_superres_init(imin, se);
************************************************************/

/* Find best class for the blob (i. e. class with maximal probability) */

int sci_int_dnn_superres_init(char * fname, void* pvApiCtx)
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
	double *typeSRN = NULL;
	int typeSRN_int = -1;
	//char *typeSRN_char = NULL;
	double er = -1;

	double* pdblReal1 = NULL;
	pdblReal1 = &er;

	int iRows1 = 1;
	int iCols1 = 1;
	Mat img_new;
	CheckInputArgument(pvApiCtx, 2, 3);
	CheckOutputArgument(pvApiCtx, 0, 1);


	GetString(1, model_name, pvApiCtx);
	GetDouble(2, scale, iRows, iCols, pvApiCtx);
	GetDouble(3, typeSRN, iRows, iCols, pvApiCtx);

	scale_int = round(*scale);
	typeSRN_int = round(*typeSRN);

	String modelTxt = model_name;
	String typeSRN_char;

	try
	{
		// Check how many models already loaded, and continue after the last opened number
		for (nCurrFile = 0; nCurrFile < MAX_DL_NUM; nCurrFile++)
		{
			sciprint("%i\n", nCurrFile);
			if ((DeepSRNet[nCurrFile].sr.getAlgorithm().empty()))
				break;
		}

		// It should not more than defined number of camera/avifile open
		if (nCurrFile == MAX_DL_NUM)
		{
			Scierror(999, "%s: Too many DNN model loaded. Use dnn_unload or dnn_unloadall to close some models.\r\n", fname);
			return -1;
		}
		//int result = strcmp(algorithm, "fsrcnn");
		// case (strcmp(*algorithm == "edsr" || *algorithm == "espcn" || *algorithm == "fsrcnn" || *algorithm == "lapsrn"):
		sciprint("typeSRN_int : %i", typeSRN_int);
		switch (typeSRN_int) {
		case 1: { // edsr
			sciprint("Loading EDSR Model: %s\n", modelTxt.c_str());
			typeSRN_char = "edsr";
			break; }       // and exits the switch
		case 2: { // espcn
			sciprint("Loading ESPCN Model: %s\n", modelTxt.c_str());
			typeSRN_char = "espcn";
			break; }
		case 3: { // fsrcnn
			sciprint("Loading FSRCNN Model: %s\n", modelTxt.c_str());
			typeSRN_char = "fsrcnn";
			sciprint("2");
			break; }
		case 4: { // lapsrn
			sciprint("Loading LAPSRN Model: %s\n", modelTxt.c_str());
			typeSRN_char = "lapsrn";
			break; }
		default: {
			sciprint("No model loaded\n");
			break; }
		}
		DeepSRNet[nCurrFile].sr.readModel(model_name);
		DeepSRNet[nCurrFile].sr.setModel(typeSRN_char, scale_int);

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
		//return 0;
	}
	//SetImage(1, img_new, pvApiCtx);
	return 0;

}

//
//int result = 0;
//if (result == 0)
//{
//
//	string img_path = "orig_butterfly.jpg";
//	string algorithm = "fsrcnn";
//	//int scale = 4;
//	//string path = "FSRCNN_x4.pb";
//	Mat img = cv::imread(img_path);
//	Mat original_img(img);
//
//
//	//sciprint("Loading Caffe Model: %s\n", modelBin.c_str());
//	//DeepSRNet[nCurrFile] = dnn::readNetFromCaffe(modelTxt, modelBin);
//	DeepSRNet[nCurrFile].sr.readModel(model_name);
//	//sciprint("%s\n", sr.getAlgorithm());
//	//sciprint("%f\n", sr.getScale());
//	DeepSRNet[nCurrFile].sr.setModel(algorithm, scale_int);
//	sciprint("aaa\n");
//
//	DeepSRNet[nCurrFile].sr.upsample(img, img_new);
//
//}       // and exits the switch
//else {
//	std::cerr << "Algorithm not recognized. \n";
//}