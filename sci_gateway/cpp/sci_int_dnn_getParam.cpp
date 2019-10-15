/***********************************************************************
 * IPCV - Scilab Image Processing and Computer Vision toolbox
 * Copyright (C) 2017  Tan Chin Luh
***********************************************************************/

#include "common.h"

/************************************************************
* imout = sci_int_dnn_getParam();
************************************************************/

int sci_int_dnn_getParam(char * fname, void* pvApiCtx)
{

	int iRet = 0;
	int iRows = 0;
	int iCols = 0;
	double *sz1 = NULL;
	int nFile;
	char *pstName = NULL;
	double *out = NULL;
	int ind, layer_id;


	CheckInputArgument(pvApiCtx, 3, 3);
	CheckOutputArgument(pvApiCtx, 0, 1);

	
		// Input 1 : Pointer to the DNN
		GetDouble(1, out, iRows, iCols, pvApiCtx);
		nFile = round(*out);
		nFile -= 1;

		// Input 2 : Layer's Name to Evaluate
		//GetDouble(2, sz1, iRows, iCols, pvApiCtx);
		//layer_id = int(*sz1);
		GetString(2, pstName, pvApiCtx);
		
		// Input 3 : Layer Index?
		GetDouble(3, sz1, iRows, iCols, pvApiCtx);
		ind = int(*sz1);

		// Error Checking
		if (DeepNet[nFile].net.empty())
		{
			Scierror(999, "%s: Could not load deep learning model.\n", fname);
			return -1;
		}

		try
		{



		string str(pstName);
		Mat outs;
		//outs = DeepNet[nFile].net.getParam(layer_id, ind);
		outs = DeepNet[nFile].net.getParam(DeepNet[nFile].net.getLayerId(str), ind);
		//sciprint("outs : %i %i %i %i\n", outs[0].size[0], outs[0].size[1],outs[0].size[2], outs[0].size[3]);

		



		//sciprint("r,c,dpt,ch : %i %i %i %i\n", outs.rows, outs.cols, outs.depth(), outs.channels());
		//sciprint("outs : %i %i %i %i\n", outs.size[0], outs.size[1], outs.size[2], outs.size[3]);
		
		SciErr sciErr;
		int ndims;
		double* pdblReal = NULL;
		double* pdblImg = NULL;
		void * pMatData;
		//Mat new_img = outs[0];

		outs.convertTo(outs, CV_64F);

		// For troubleshoot
		//sciprint("outsize : %i\n", outs.size);
		//sciprint("r,c,dpt,ch : %i %i %i %i\n", outs[0].rows, outs[0].cols, outs[0].depth(), outs[0].channels());
		//sciprint("3,2,1,0,5,6 : %i %i %i %i %i %i\n", outs[0].size[3], outs[0].size[2], outs[0].size[1], outs[0].size[0], outs[0].size[5], outs[0].size[6]);
		//sciprint("r,c,dpt,ch : %i %i %i %i\n", outs[1].rows, outs[1].cols, outs[1].depth(), outs[1].channels());
		//if outs[0].rows 

		if (outs.rows == -1)
		{
			int dims_var[4] = { outs.size[3],outs.size[2],outs.size[1], outs.size[0] };
			int *dims;
			dims = dims_var;
			sciErr = createHypermatOfDouble(pvApiCtx, nbInputArgument(pvApiCtx) + 1, dims, 4, (double*)outs.data);
		}
		else
		{
			int dims_var[2] = { outs.size[1],outs.size[0] };
			int *dims;
			dims = dims_var;
			sciErr = createHypermatOfDouble(pvApiCtx, nbInputArgument(pvApiCtx) + 1, dims, 2, (double*)outs.data);
		}


		//sciErr = createHypermatOfDouble(pvApiCtx, nbInputArgument(pvApiCtx) + 1, dims, 3, (double*)outs[0].data);
		if (sciErr.iErr)
		{
			printError(&sciErr, 0);
			return sciErr.iErr;
		}
		AssignOutputVariable(pvApiCtx, 1) = nbInputArgument(pvApiCtx) + 1;

		//SetImage(1, outs,pvApiCtx);
		//AssignOutputVariable(pvApiCtx, 1) = nbInputArgument(pvApiCtx) + 1;

	}
	catch (const cv::Exception& e)
	{
		sciprint("Error: %s \n", e.what());
		iRet = createScalarDouble(pvApiCtx, nbInputArgument(pvApiCtx) + 1, -1);
		AssignOutputVariable(pvApiCtx, 1) = nbInputArgument(pvApiCtx) + 1;
		return -1;
	}
	return 0;


}
