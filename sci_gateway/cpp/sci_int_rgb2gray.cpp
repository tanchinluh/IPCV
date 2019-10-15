/***********************************************************************
 *
 * IPCV - Scilab Image Processing and Computer Vision toolbox
 * Copyright (C) 2017  Tan Chin Luh
 *
 ***********************************************************************/

#include "common.h"

/************************************************************
* imout = int_rgb2lab(imin, se);
************************************************************/


int sci_int_rgb2gray(char * fname,void* pvApiCtx)
{

	// Initialization
	Mat src;
	Mat dst;

	// Check arguments
	CheckInputArgument(pvApiCtx, 1, 1);
	CheckOutputArgument(pvApiCtx, 1, 1);

	// Creating images
	GetImage(1,src,pvApiCtx);

	uchar depth = src.type() & CV_MAT_DEPTH_MASK;

	//sciprint("CheckPoint : %i\n",depth);
	// Conversion

  switch ( depth ) {
	case CV_8U: 
	case CV_16U:
	case CV_32F:  
		{
			//sciprint("CV_8U | CV_16U | CV_32F");
			cvtColor( src, dst, COLOR_RGB2GRAY); 
			break;
		}
	case CV_8S:
	case CV_16S:
	case CV_32S:  
		{
			//sciprint("CV_8S | CV_16S | CV_32S");
			Scierror(999,"rgb2gray only support image of uint8, uint16 or double.",fname);
			return -1; 
			break;
		}
    case CV_64F: 
		{
			src.convertTo(src,CV_32F);
			cvtColor( src, dst, COLOR_RGB2GRAY);
			break;
		}
    default:     
		{
			Scierror(999,"rgb2gray only support image of uint8, uint16 or double.",fname); 
			return -1; 
			break;
		}
  }
	//cvCvtColor(pSrcImg, pDstImg, CV_RGB2Lab);
  	//cvtColor( src, dst, CV_RGB2GRAY);
	//sciprint("CheckPoint : 2\n");
	// Creating output image
	
	SetImage(1,dst,pvApiCtx);

	//free(dst);
	//free(src);
	return 0;


}
