/***********************************************************************
 * IPCV - Scilab Image Processing and Computer Vision toolbox
 * Copyright (C) 2017  Tan Chin Luh
***********************************************************************/

#include "common.h"

/************************************************************
* imout = sci_int_dnn_init(imin, se);
************************************************************/

/* Find best class for the blob (i. e. class with maximal probability) */

int sci_int_tracker_init(char * fname, void* pvApiCtx)
{
	Mat pSrcImg, pDstImg;
	int iRet = 0;
	int nCurrFile = 0;
	int *pret = &nCurrFile;
	int iRows = 0;
	int iCols = 0;
	double *sz1 = NULL;
	int sz2;
	double *out = NULL;
	int typeTracker = -1;
	double er = -1;
	Mat img;
	double* pdblReal1 = NULL;
	pdblReal1 = &er;


	CheckInputArgument(pvApiCtx, 3, 3);
	CheckOutputArgument(pvApiCtx, 0, 1);

	// Input 1 : Image
	GetImage(1, img, pvApiCtx);

	// Input 2 : BB
	GetDouble(2, sz1, iRows, iCols, pvApiCtx);
	Rect2d bbox(*sz1, *(sz1 + 1), *(sz1 + 2), *(sz1 + 3));

	// Input 3 : Algo
	GetDouble(3, out, iRows, iCols, pvApiCtx);
	typeTracker = round(*out);


	try
	{
		// Check how many models already loaded, and continue after the last opened number
		for (nCurrFile = 0; nCurrFile < MAX_TRACK_NUM; nCurrFile++)
		{
			if ((ObjTrack[nCurrFile].trackobj.empty()))
				break;
		}

		// It should not more than defined number of camera/avifile open
		if (nCurrFile == MAX_TRACK_NUM)
		{
			Scierror(999, "%s: Too many Trackers model loaded. Use dnn_unload or dnn_unloadall to close some models.\r\n", fname);
			return -1;
		}

		

		

		switch (typeTracker) {
		case 1: {
			sciprint("Initializing CSRT Tracker...\n");
			ObjTrack[nCurrFile].trackobj = cv::legacy::TrackerCSRT::create();
			break; }
		case 2: {
			sciprint("Initializing KCF Tracker...\n");
			ObjTrack[nCurrFile].trackobj = cv::legacy::TrackerKCF::create();
			break; }
		case 3: {
			sciprint("Initializing Boosting Tracker...\n");
			ObjTrack[nCurrFile].trackobj = cv::legacy::TrackerBoosting::create();
			break; }       // and exits the switch
		case 4: {
			sciprint("Initializing MIL Tracker...\n");
			ObjTrack[nCurrFile].trackobj = cv::legacy::TrackerMIL::create();
			break; }       // and exits the switch
		case 5: {
			sciprint("Initializing TLD Tracker...\n");
			ObjTrack[nCurrFile].trackobj = cv::legacy::TrackerTLD::create();
			break; }       // and exits the switch
		case 6: {
			sciprint("Initializing MedianFlow Tracker...\n");
			ObjTrack[nCurrFile].trackobj = cv::legacy::TrackerMedianFlow::create();
			break; }
		case 7: {
			sciprint("Initializing MOSSE Tracker...\n");
			ObjTrack[nCurrFile].trackobj = cv::legacy::TrackerMOSSE::create();
			break; }
		}

		ObjTrack[nCurrFile].trackobj->init(img, bbox);



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
