/***********************************************************************
 * IPCV - Scilab Image Processing and Computer Vision toolbox
 * Copyright (C) 2017  Tan Chin Luh
***********************************************************************/

#include "common.h"
#include <iostream>

#include <opencv2/dnn_superres.hpp>

/************************************************************
* imout = sci_int_dnn_init(imin, se);
************************************************************/

/* Find best class for the blob (i. e. class with maximal probability) */

int sci_int_dnn_superres(char * fname, void* pvApiCtx)
{

	CheckInputArgument(pvApiCtx, 0, 3);
	CheckOutputArgument(pvApiCtx, 0, 1);


	string img_path = "orig_butterfly.jpg";
	string algorithm = "fsrcnn";
	int scale = 4;
	string path = "FSRCNN_x4.pb";


	// Load the image
	Mat img = cv::imread(img_path);
	Mat original_img(img);
	if (img.empty())
	{
		Scierror(999, "%s: Couldn't load image: \n", img_path.c_str());
		return -2;
	}

	//Make dnn super resolution instance
	dnn_superres::DnnSuperResImpl sr;

	Mat img_new;

	try
	{

		if (algorithm == "bilinear") {
			resize(img, img_new, Size(), scale, scale, 2);
		}
		else if (algorithm == "bicubic")
		{
			resize(img, img_new, Size(), scale, scale, 3);
		}
		else if (algorithm == "edsr" || algorithm == "espcn" || algorithm == "fsrcnn" || algorithm == "lapsrn")
		{
			sr.readModel(path);
			sciprint("%s\n", sr.getAlgorithm().c_str());
			sciprint("%f\n", sr.getScale());
			sr.setModel(algorithm, scale);
			sciprint("%s\n", sr.getAlgorithm().c_str());
			sciprint("%f\n", sr.getScale());
			sr.upsample(img, img_new);

		}
		else {
			Scierror(999, "Algorithm not recognized. \n");
		}

	}
	catch (const cv::Exception& e)
	{

		sciprint("Error: %s \n\n\n", e.err.c_str());
		sciprint("Error: %s \n", e.what());
		//iRet = createScalarDouble(pvApiCtx, nbInputArgument(pvApiCtx) + 1, -1);
		//AssignOutputVariable(pvApiCtx, 1) = nbInputArgument(pvApiCtx) + 1;

	}

	if (img_new.empty())
	{
		Scierror(999, "Upsampling failed. \n");
		return -3;
	}
	sciprint("Upsampling succeeded. \n");

	// Display image
	//cv::namedWindow("Initial Image", WINDOW_AUTOSIZE);
	//cv::imshow("Initial Image", img_new);
	//cv::imwrite("saved.jpg", img_new);
	//cv::waitKey(0);

	SetImage(1, img_new, pvApiCtx);
	return 0;

}
