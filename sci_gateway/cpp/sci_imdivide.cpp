/***********************************************************************
 * SIVP - Scilab Image and Video Processing toolbox
 * Copyright (C) 2006  Shiqi Yu
 *
 * IPCV - Scilab Image Processing and Computer Vision toolbox
 * Copyright (C) 2017  Tan Chin Luh
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
 ***********************************************************************/


#include "common.h"

/************************************************************
* imout = int_imdivide(im1, im2)
* !! INT8 is unsupported by this function !!
************************************************************/

int sci_imdivide(char * fname,void* pvApiCtx)
{

		Mat pImage1, pImage2, pImageOut;

	CheckInputArgument(pvApiCtx, 2, 2);
	CheckOutputArgument(pvApiCtx, 1, 1);

	GetImage(1,pImage1,pvApiCtx);
	GetImage(2,pImage2,pvApiCtx);

	//sciprint("Rows :%i \n",pImage2.rows);
	//sciprint("Cols :%i \n",pImage2.cols);
	//sciprint("ndims  :%i \n",pImage2.channels());

	//sciprint("Rows :%i \n",pImage1.rows);
	//sciprint("Cols :%i \n",pImage1.cols);
	//sciprint("ndims  :%i \n",pImage1.channels());
	//if( !src1 || !src2)

	//if the second input is a scalar double
	if ((pImage2.rows == 1) && (pImage2.cols ==1))
	{
		//if not be a scalar double
		if( pImage2.channels() != 1)
		{
			Scierror(999, "%s: The second argument should be a double scalar, or of the same size with the first.\r\n",fname);
			return -1;
		}
		if( pImage2.type() != CV_64F)
		{
			pImage2.convertTo(pImage2,CV_64F);
		
		}

		divide(pImage1,pImage2,pImageOut);

	}


	else if (is_binary_image(pImage2))
	{
		//sciprint("Bin %i\t%i\n",pImage1.channels(),is_binary_image(pImage2));
		if((pImage1.rows != pImage2.rows) || (pImage1.cols != pImage2.cols))
		{
			Scierror(999, "%s: The binary image must be the same size with the source image.\r\n",fname);
			return -1;
		}		

		uchar depth = pImage1.type() & CV_MAT_DEPTH_MASK;

		if (depth == CV_64F)
		{
			pImage2.convertTo(pImage2,CV_32F,1.0/255);
			if (pImage1.channels() == 3)
				cvtColor(pImage2, pImage2, COLOR_GRAY2BGR);
			pImage2.convertTo(pImage2,CV_64F);

		}
		else
		{
			pImage2.convertTo(pImage2,pImage1.type(),1.0/255);
			if (pImage1.channels() == 3)
				cvtColor(pImage2, pImage2, COLOR_GRAY2BGR);
		}	


		divide(pImage1,pImage2,pImageOut);
	}
	//if the second input is not a scalar double,
	//it should be of the same size and same class
	else
	{
		//must be of the same size
		if((pImage1.rows != pImage2.rows) || (pImage1.cols != pImage2.cols))
		{
			Scierror(999, "%s: The two input images do not have same image size.\r\n",fname);
			return -1;
		}
		//must be of the same channel number
		if(pImage1.channels() != pImage2.channels())
		{
			Scierror(999, "%s: The two input images do not have same channel number.\r\n",fname);
			return -1;
			//multiply(pImage1,pImage2,pImageOut);
		}
		//must be of the same depth
		if(pImage1.type() != pImage2.type())
		{
			Scierror(999, "%s: The two input images do not have same type.\r\n",fname);
			return -1;
		}
		//sciprint("1 %i\t%i\n",pImage1.channels(),pImage1.type());
		//sciprint("2 %i\t%i\n",pImage2.channels(),pImage2.type());
		divide(pImage1,pImage2,pImageOut);

	}//end else


	SetImage(1,pImageOut,pvApiCtx);
	return 0;

	//IplImage * pImage1 = NULL;
	//IplImage * pImage2 = NULL;
	//IplImage * pImageOut = NULL; //output

	//CheckRhs(2, 2);
	//CheckLhs(1, 1);

	///*convert the matrix to IplImage*/
	//pImage1 = Mat2IplImg(1);
	//pImage2 = Mat2IplImg(2);

	//if( !pImage1 || !pImage2)
	//{
	//	return -1;
	//}

	////check input

	////if the second input is a scalar double
	//if ((pImage2->width == 1) && (pImage2->height ==1))
	//{
	//	IplImage * pOnesTmp;
	//	//if not be a scalar double
	//	if( pImage2->depth != IPL_DEPTH_64F ||
	//		pImage2->nChannels != 1)
	//	{
	//		cvReleaseImage(&pImage1);
	//		cvReleaseImage(&pImage2);
	//		Scierror(999, "%s: The second argument should be a double scalar, or of the same size with the first.\r\n",fname);
	//		return -1;
	//	}
	//	//create an output image
	//	pImageOut = cvCreateImage(cvGetSize(pImage1), pImage1->depth, pImage1->nChannels);

	//	//create an all-one matrix
	//	pOnesTmp = cvCloneImage(pImage1);
	//	cvSet(pOnesTmp, cvScalarAll(1.0), NULL);

	//	cvMul(pImage1,
	//		pOnesTmp,
	//		pImageOut,
	//		1.0/CV_IMAGE_ELEM(pImage2, double, 0, 0 ));

	//	cvReleaseImage(&pOnesTmp);
	//}

	////if the second input is not a scalar double,
	////it should be of the same size and same class
	//else
	//{
	//	//must be of the same size
	//	if((pImage1->width != pImage2->width) || (pImage1->height != pImage2->height))
	//	{
	//		cvReleaseImage(&pImage1);
	//		cvReleaseImage(&pImage2);
	//		Scierror(999, "%s: The two input images do not have same image size.\r\n",fname);
	//		return -1;
	//	}
	//	//must be of the same channel number
	//	if(pImage1->nChannels != pImage2->nChannels)
	//	{
	//		cvReleaseImage(&pImage1);
	//		cvReleaseImage(&pImage2);
	//		Scierror(999, "%s: The two input images do not have same channel number.\r\n",fname);
	//		return -1;
	//	}
	//	//must be of the same depth
	//	if(pImage1->depth != pImage2->depth)
	//	{
	//		cvReleaseImage(&pImage1);
	//		cvReleaseImage(&pImage2);
	//		Scierror(999, "%s: The two input images do not have same depth.\r\n",fname);
	//		return -1;
	//	}
	//	//create an output image
	//	pImageOut = cvCreateImage(cvGetSize(pImage1), pImage1->depth, pImage1->nChannels);

	//	if(!pImageOut)
	//	{
	//		Scierror(998, "%s: Can not alloc memeory for image.\r\n", fname);
	//		cvReleaseImage(&pImage1);
	//		cvReleaseImage(&pImage2);
	//		return -1;
	//	}

	//	cvDiv(pImage1, pImage2, pImageOut, 1.0);
	//}//end else


	//IplImg2Mat(pImageOut, 3);

	//LhsVar(1) = 3;

	//cvReleaseImage(&pImage1);
	//cvReleaseImage(&pImage2);
	//cvReleaseImage(&pImageOut);

	//return 0;

}
