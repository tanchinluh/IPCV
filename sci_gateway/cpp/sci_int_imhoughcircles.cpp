/***********************************************************************
 * IPCV - Scilab Image Processing and Computer Vision toolbox
 * Copyright (C) 2017  Tan Chin Luh
***********************************************************************/


#include "common.h"

int sci_int_imhoughcircles(char * fname,void* pvApiCtx)
{

SciErr sciErr;
CheckInputArgument(pvApiCtx, 1, 1);
CheckOutputArgument(pvApiCtx, 0, 1);

Mat src;
Mat	src_gray;


//int* piAddr = NULL;
//double* pdbRho = NULL;
//double* pdbTheta = NULL;
//int iRet    = 0;
int iRows1           = 0;
int iCols1           = 0;
double *pr1;
double* pdblReal1	= NULL;
int rSize;
//int iRows2           = 0;
//int iCols2           = 0;
	
GetImage(1,src,pvApiCtx);


  /// Read the image
  //src = imread( argv[1], 1 );

  //if( !src.data )
 if( src.empty() )
    { return -1; }

  /// Convert it to gray
  cvtColor( src, src_gray, COLOR_BGR2GRAY );

  /// Reduce the noise so we avoid false circle detection
  GaussianBlur( src_gray, src_gray, Size(9, 9), 2, 2 );

  //vector<Vec3f> circles;
  std::vector<Vec3f> circles;

  /// Apply the Hough Transform to find the circles
  // C++: void HoughCircles(InputArray image, OutputArray circles, int method, double dp, double minDist, double param1=100, double param2=100, int minRadius=0, int maxRadius=0 )
  //HoughCircles( src_gray, circles, CV_HOUGH_GRADIENT, 1, src_gray.rows/8, 200, 100, 0, 0 );
  //HoughCircles( src_gray, circles, CV_HOUGH_GRADIENT, 1.2, 100, 200, 100, 0, 0 );
  
  HoughCircles( src_gray, circles, HOUGH_GRADIENT, 1.2, 100);
 

  //Draw the circles detected

  	iRows1 = circles.size();
	iCols1 = 3;
	rSize = iRows1*iCols1;
	// pdblReal1 = *circles.data();
	pdblReal1 = (double*)calloc(rSize,sizeof(double));
	pr1 =  pdblReal1;
  for( size_t i = 0; i < circles.size(); i++ )
  {
	  //*pr1++ = (double(circles[i][0]), double(circles[i][1]),double(circles[i][2]));
	   
	  *pr1++ = double(circles[i][0]);
	  *pr1++ = double(circles[i][1]);
	  *pr1++ = double(circles[i][2]);
      
	  //Point center(cvRound(circles[i][0]), cvRound(circles[i][1]));
	  //int radius = cvRound(circles[i][2]);


   //   //// circle center
   //   circle( src, center, 3, Scalar(0,255,0), -1, 8, 0 );
   //   //// circle outline
   //   circle( src, center, radius, Scalar(0,0,255), 3, 8, 0 );
	

   }

  /// Show your results
 // namedWindow( "aaa", CV_WINDOW_AUTOSIZE );
 // 
	//
 // while(1)
 // {
 // imshow( "aaa", src );
	////sciprint("Keypress: %d\n", waitKey(10));
	//if(waitKey(10) == 27)
 //     break;
 // }

	//cvDestroyWindow("aaa");
//	sciprint("Before return\n");
//	sciprint("Size : %i\n",circles.size());
	//free(circles);

	//pr1 = (double*)calloc(rSize,sizeof(double));
	//for (k = rFirst; k <= rLast; k++)
	//	pr1[k-rFirst] = (double) k;
	
 	sciErr = createMatrixOfDouble(pvApiCtx, nbInputArgument(pvApiCtx) + 1,  iCols1, iRows1,pdblReal1);
	if(sciErr.iErr)
	{
		printError(&sciErr, 0);
		return 0;
	}
	//after creation, we can free memory.

	AssignOutputVariable(pvApiCtx, 1) = nbInputArgument(pvApiCtx) + 1;
	free(pdblReal1);
	//SetImage(2,src);
  //src.release();
  //src_gray.release();
  //circles.clear();


  return(0);

}


