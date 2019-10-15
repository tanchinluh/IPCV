/***********************************************************************
 * IPCV - Scilab Image Processing and Computer Vision toolbox
 * Copyright (C) 2017  Tan Chin Luh
***********************************************************************/

#include "common.h"

/************************************************************
* imout = sci_int_dnn_getLayerNames();
************************************************************/


int sci_int_dnn_getLayerNames(char * fname, void* pvApiCtx)
{

	int iRows = 0;
	int iCols = 0;
	int nFile;
	double *out = NULL;

	CheckInputArgument(pvApiCtx, 1, 1);
	CheckOutputArgument(pvApiCtx, 0, 1);

	GetDouble(1, out, iRows, iCols, pvApiCtx);
	nFile = round(*out);
	nFile -= 1;


	if (DeepNet[nFile].net.empty())
	{
		Scierror(999, "%s: Not a valid dnn.\n", fname);
		return -1;
	}
	SciErr sciErr;

	try
	{
		char** pstData = NULL;
		char* pData = NULL;
		std::vector<String> strings = DeepNet[nFile].net.getLayerNames();

		//for (int i = 0; i<strings.size(); i++) {
		//	sciprint("Layer # %i: %s\n", i, strings[i].c_str());
		//}
		std::vector<char*> cstrings;
		cstrings.reserve(strings.size());
		for (size_t i = 0; i < strings.size(); ++i)
			cstrings.push_back(const_cast<char*>(strings[i].c_str()));

		pstData = &cstrings[0];
		sciErr = createMatrixOfString(pvApiCtx, nbInputArgument(pvApiCtx) + 1, strings.size(), iCols, pstData);
		AssignOutputVariable(pvApiCtx, 1) = nbInputArgument(pvApiCtx) + 1;

	}
	catch (const cv::Exception& e)
	{
		char* pData = "Err";

		sciprint("Error: %s \n", e.err.c_str());
		SetString(1, pData, pvApiCtx);

	}



	return 0;


}
