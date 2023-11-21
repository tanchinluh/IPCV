/***********************************************************************
 * SIVP - Scilab Image and Video Processing toolbox
 * Copyright (C) 2006  Shiqi Yu
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
* im2=int_cvtcolor(im, cvt_code);
* cvt_code = 'rgb2hsv', 'hsv2rgb', 'rgb2ycrcb', 'ycrcb2rgb'
************************************************************/

int sci_int_cvtcolor(char *fname,void* pvApiCtx)
{
	
	Mat src_image, dst_image;
	char *cvt_str_code = NULL;
	int cvt_code; 

	//IplImage * src_image = NULL;
	//IplImage * src_f32_image = NULL;
	//IplImage * dst_f32_image = NULL;
	//IplImage * dst_f64_image = NULL;

	//int m2, n2, l2;

	//check the number of input and output parameters
	//CheckRhs(2,2);
	//CheckLhs(1,1);
	CheckInputArgument(pvApiCtx, 2, 2);
	CheckOutputArgument(pvApiCtx, 1, 1);

	//GetRhsVar(2, "c", &m2, &n2, &l2);
	//cvt_str_code = cstk(l2);

	////load the input image
	//src_image = Mat2IplImg(1);

	//// check if input image is correctly loaded
	//if(src_image == NULL)
	//{
	//	sciprint("%s error: can't load the input image.\r\n", fname);
	//	return -1;
	//}
	GetImage(1,src_image,pvApiCtx);
	if(src_image.channels() != 3)
	{
		sciprint("%s error: The input image must be 3-channel image.\r\n", fname);		
		return -1;
	}
	GetString(2, cvt_str_code,pvApiCtx);




	//check the number of channels

	//this function is called
	//from scilab macros rgb2hsv/hsv2rgb/...
	//the input image can only be double float.
	//if(src_image->depth != IPL_DEPTH_64F)
	//{
	//	sciprint("%s error: The input image must be double type.\r\n", fname);
	//	cvReleaseImage(&src_image);
	//	return -1;
	//}

	if( strcmp(cvt_str_code, "rgb2hsv") == 0)
		cvt_code = COLOR_BGR2HSV; //the channel order of IplImage in AIVP is BGR
	else if( strcmp(cvt_str_code, "hsv2rgb") == 0)
		cvt_code = COLOR_HSV2BGR;
	else if( strcmp(cvt_str_code, "rgb2ycrcb") == 0)
		cvt_code = COLOR_BGR2YCrCb;
	else if( strcmp(cvt_str_code, "ycrcb2rgb") == 0)
		cvt_code = COLOR_YCrCb2BGR;
	else if (strcmp(cvt_str_code, "lab2rgb") == 0)
		cvt_code = COLOR_Lab2BGR;

	else
	{
		sciprint("%s error: unsupport convertion code %s.\r\n", fname, cvt_str_code);
		return -1;
	}
	//create images needed
	//src_f32_image = cvCreateImage(cvGetSize(src_image),
	//	IPL_DEPTH_32F,
	//	3);
	//dst_f32_image = cvCreateImage(cvGetSize(src_image),
	//	IPL_DEPTH_32F,
	//	3);
	//dst_f64_image = cvCreateImage(cvGetSize(src_image),
	//	IPL_DEPTH_64F,
	//	3);

	//if(src_f32_image == NULL ||
	//	dst_f32_image == NULL ||
	//	dst_f64_image == NULL)
	//{
	//	sciprint("Error: create image error.\r\n");
	//	cvReleaseImage(&src_image);
	//	cvReleaseImage(&src_f32_image);
	//	cvReleaseImage(&dst_f32_image);
	//	cvReleaseImage(&dst_f64_image);
	//	return -1;
	//}

	//cvConvert(src_image, src_f32_image);

	//cvCvtColor(src_f32_image, dst_f32_image, cvt_code);

	//cvConvert(dst_f32_image, dst_f64_image);

	//IplImg2Mat(dst_f64_image, 3);
	////send the result
	//LhsVar(1)=3;

	//cvReleaseImage(&src_image);
	//cvReleaseImage(&src_f32_image);
	//cvReleaseImage(&dst_f32_image);
	//cvReleaseImage(&dst_f64_image);

	cvtColor(src_image, dst_image,cvt_code);

	SetImage(1,dst_image,pvApiCtx);

	return 0;
}

