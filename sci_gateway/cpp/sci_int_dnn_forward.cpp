/***********************************************************************
 * IPCV - Scilab Image Processing and Computer Vision toolbox
 * Copyright (C) 2017  Tan Chin Luh
***********************************************************************/

#include "common.h"
//#include <opencv2/core/utils/trace.hpp>


/************************************************************
* imout = sci_int_dnn_forward(imin, se);
************************************************************/

int sci_int_dnn_forward(char * fname, void* pvApiCtx)
{
	Mat pSrcImg, pDstImg;
	int iRet = 0;
	int iRows = 0;
	int iCols = 0;
	double *sz1 = NULL;
	double *sz2 = NULL;
	double *sf = NULL;
	int nFile;
	Mat img;
	char *pstName = NULL;
	double *out = NULL;
	int nWidth, nHeight;
	double R, G, B;
	bool swapRB,crop;

	CheckInputArgument(pvApiCtx, 8, 8);
	CheckOutputArgument(pvApiCtx, 0, 1);

	try
	{
		// Input 1 : Pointer to the DNN
		GetDouble(1, out, iRows, iCols, pvApiCtx);
		nFile = round(*out);
		nFile -= 1;

		// Input 2 : Image
		GetImage(2, img, pvApiCtx);

		// Input 3 : Image Size
		GetDouble(3, sz1, iRows, iCols, pvApiCtx);
		nWidth = int(*sz1);
		nHeight = int(*(sz1 + 1));

		// Input 4 : Layer's Name to Evaluate
		GetString(4, pstName, pvApiCtx);

		// Input 5 : multiplier for images values.
		double scalefactor;
		GetDouble(5, sf, iRows, iCols, pvApiCtx);
		scalefactor = *sf;

		// Input 6 : Image Mean
		GetDouble(6, sz2, iRows, iCols, pvApiCtx);
		R = *sz2;
		G = *(sz2 + 1);
		B = *(sz2 + 2);

		// Input 7 : swapRGB
		GetDouble(7, sz1, iRows, iCols, pvApiCtx);
		swapRB = (*sz1 != 0);

		// Input 8 : crop
		GetDouble(8, sz1, iRows, iCols, pvApiCtx);
		crop = (*sz1 != 0);


		// Error Checking
		if (DeepNet[nFile].net.empty())
		{
			Scierror(999, "%s: Could not load deep learning model.\n", fname);
			return -1;
		}

		if (img.empty())
		{
			Scierror(999, "%s: Not a valid image\n", fname);
			return -1;
		}


		//sciprint("img : %i %i\n", img.type(), img.depth());

		//GoogLeNet accepts only 224x224 BGR-images
		if (img.depth()==6)
		{
			img.convertTo(img, CV_32F);
		}

		Mat inputBlob = blobFromImage(img, scalefactor, Size(nWidth, nHeight), Scalar(R, G, B), swapRB,crop);     //Convert Mat to batch of images   
		DeepNet[nFile].net.setInput(inputBlob);   //set the network input
		string str(pstName);

		vector<Mat> outs;
		DeepNet[nFile].net.forward(outs, str);
		//sciprint("outs : %i %i %i %i\n", outs[0].size[0], outs[0].size[1],outs[0].size[2], outs[0].size[3]);


		SciErr sciErr;
		int ndims;
		double* pdblReal = NULL;
		double* pdblImg = NULL;
		void * pMatData;
		//Mat new_img = outs[0];

		outs[0].convertTo(outs[0], CV_64F);

		// For troubleshoot
		//sciprint("outsize : %i\n", outs.size);
		//sciprint("r,c,dpt,ch : %i %i %i %i\n", outs[0].rows, outs[0].cols, outs[0].depth(), outs[0].channels());
		//sciprint("3,2,1,0,5,6 : %i %i %i %i %i %i\n", outs[0].size[3], outs[0].size[2], outs[0].size[1], outs[0].size[0], outs[0].size[5], outs[0].size[6]);
		//sciprint("r,c,dpt,ch : %i %i %i %i\n", outs[1].rows, outs[1].cols, outs[1].depth(), outs[1].channels());
		//if outs[0].rows 

		if (outs[0].rows == -1)
		{
			int dims_var[4] = { outs[0].size[3],outs[0].size[2],outs[0].size[1], outs[0].size[0] };
			int *dims;
			dims = dims_var;
			sciErr = createHypermatOfDouble(pvApiCtx, nbInputArgument(pvApiCtx) + 1, dims, 4, (double*)outs[0].data);
		}
		else
		{
			int dims_var[2] = { outs[0].size[1],outs[0].size[0] };
			int *dims;
			dims = dims_var;
			sciErr = createHypermatOfDouble(pvApiCtx, nbInputArgument(pvApiCtx) + 1, dims, 2, (double*)outs[0].data);
		}



		//sciErr = createHypermatOfDouble(pvApiCtx, nbInputArgument(pvApiCtx) + 1, dims, 3, (double*)outs[0].data);
		if (sciErr.iErr)
		{
			printError(&sciErr, 0);
			return sciErr.iErr;
		}
		AssignOutputVariable(pvApiCtx, 1) = nbInputArgument(pvApiCtx) + 1;

		//SetImage(1, prob,pvApiCtx);
	}
	catch (const cv::Exception& e)
	{
		sciprint("Error code: %i \n", e.code);
		sciprint("Error description: %s \n", e.err.c_str());
		sciprint("Error source: %s \n", e.file.c_str());
		sciprint("Error function: %s \n", e.func.c_str());
		sciprint("Error line: %i \n", e.line);
		iRet = createScalarDouble(pvApiCtx, nbInputArgument(pvApiCtx) + 1, -1);
		AssignOutputVariable(pvApiCtx, 1) = nbInputArgument(pvApiCtx) + 1;
		return -1;
	}
	return 0;


}
