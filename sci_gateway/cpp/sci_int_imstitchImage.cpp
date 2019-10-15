/***********************************************************************
* IPCV - Scilab Image Processing and Computer Vision toolbox
* Copyright (C) 2017  Tan Chin Luh
***********************************************************************/


#include "common.h"


int sci_int_imstitchImage(char *fname,void* pvApiCtx)
{
	SciErr sciErr;
	int iItem       = 0;
	int iRet        = 0;
	int *piAddr     = NULL;

	CheckInputArgument(pvApiCtx, 0,7);
	CheckOutputArgument(pvApiCtx, 0, 1);

//	sciErr = getVarAddressFromPosition(pvApiCtx, 1, &piAddr);
//	if(sciErr.iErr)
//	{
//		printError(&sciErr, 0);
//		return 0;
//	}

	vector<Mat> imgs;

	GetListImg(1, NULL, piAddr, 0, imgs, pvApiCtx);

	Mat pano;
	//Stitcher stitcher = Stitcher::createDefault();
	Ptr<Stitcher> stitcher = Stitcher::create();

	int iRows = 0;
	int iCols = 0;
	double *d1 = NULL;
	double *d2 = NULL;
	double *d3 = NULL;
	double *d4 = NULL;
	double *d5 = NULL;
	double *d6 = NULL;

	
	GetDouble(2,d1,iRows,iCols,pvApiCtx); 
	GetDouble(3,d2,iRows,iCols,pvApiCtx);
	GetDouble(4,d3,iRows,iCols,pvApiCtx);
	GetDouble(5,d4,iRows,iCols,pvApiCtx); 
	GetDouble(6,d5,iRows,iCols,pvApiCtx); 
	GetDouble(7,d6,iRows,iCols,pvApiCtx); 

	
	stitcher->setRegistrationResol(*d1); /// 0.6  Resolution for image registration step. The default is 0.6 Mpx.\n"
	stitcher->setSeamEstimationResol(*d2);   /// 0.1 Resolution for seam estimation step. The default is 0.1 Mpx.\n"
	stitcher->setCompositingResol(*d3);   //1 Resolution for compositing step. Use -1 for original resolution.\n"
	stitcher->setPanoConfidenceThresh(*d4);   //1 Threshold for two images are from the same panorama confidence. Default 1
	stitcher->setWaveCorrection(*d5!=0);
	stitcher->setWaveCorrectKind(detail::WAVE_CORRECT_HORIZ); // Perform wave effect correction. The default is 'horiz'.
	stitcher->setExposureCompensator(Ptr<detail::GainCompensator> (new detail::GainCompensator ()));
    stitcher->setBlender(Ptr<detail::MultiBandBlender> (new detail::MultiBandBlender (false,int(*d6))));
	//stitcher.setExposureCompensator(makePtr<detail::GainCompensator>());
    //stitcher.setBlender(makePtr<detail::MultiBandBlender>(false,int(*d6)));

	Stitcher::Status status = stitcher->stitch(imgs, pano);

	if (Stitcher::OK == status) 
		SetImage(1,pano,pvApiCtx);
	else
		sciprint("Stitching fail.");

	
	//AssignOutputVariable(pvApiCtx, 1) = 0;
	
	return 0;
}

