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
//#include <ctime>
/**********************************************************************
* imout=imfilter(imin, F);
* the difference between filter2 and imfilter is:
* the returned matrix of filter2 is double,
* but the returned matrix of imfilter is as the same as input image
**********************************************************************/
int sci_int_imfilter(char * fname,void* pvApiCtx)

{
	//IplImage* src_image = NULL;
	//IplImage* dst_image = NULL;
	//
	//IplImage* src_filter = NULL;
	//CvMat* f32_filter = NULL;
	Mat src_image,dst_image,src_filter;

	//CheckRhs(2, 2);
	//CheckLhs(1, 1);
	CheckInputArgument(pvApiCtx, 2, 2);
	CheckOutputArgument(pvApiCtx, 0, 1);

	////load the input image
	//src_image = Mat2IplImg(1);
	////load the input src_filter
	//src_filter = Mat2IplImg(2);
	
	GetImage(1,src_image,pvApiCtx);
	GetImage(2,src_filter,pvApiCtx);
	
	//time_t t;
	//t = clock();
	//if(src_image == NULL)
	if (src_image.empty())
	{
		Scierror(999, "%s: Internal error for getting the image data.\r\n", fname);
		return -1;
	}
	//if(src_filter == NULL)
	if(src_filter.empty())
	{
		Scierror(999, "%s: Internal error for getting the src_filter data.\r\n", fname);
		//cvReleaseImage(&src_image);
		return -1;
	}
	if(src_filter.channels() != 1)
	{
		Scierror(999, "%s: The kernel must be 2D matrix.\r\n", fname);
		//cvReleaseImage(&src_image);
		//cvReleaseImage(&src_filter);
		return -1;
	}


	filter2D(src_image, dst_image, -1, src_filter);
	//t = clock() - t;
	//sciprint("It took me %d clicks (%f seconds).\n", t, ((float)t) / CLOCKS_PER_SEC);
	////the src_filter must be a 32F matrix
	////because scilab has no single float data type
	////src_filter must be converted to 32F
	//f32_filter = cvCreateMat(src_filter->height,
	//	src_filter->width,
	//	CV_32FC1);
	//if(f32_filter == NULL)
	//{
	//	Scierror(999, "%s: Internal error for allocating memory for the kernel.\r\n", fname);
	//	cvReleaseImage(&src_image);
	//	cvReleaseImage(&src_filter);
	//	return -1;
	//}
	//cvConvert(src_filter, f32_filter);


	////create the output image
	//dst_image = cvCreateImage(cvSize(src_image->width, src_image->height),
	//	src_image->depth, src_image->nChannels);
	//if(dst_image == NULL)
	//{
	//	Scierror(999, "%s: Internal error for allocating memory for the output image.\r\n", fname);
	//	cvReleaseImage(&src_image);
	//	cvReleaseImage(&src_filter);
	//	cvReleaseMat(&f32_filter);
	//	return -1;
	//}

	//opencv function cvFilter2D can only filte 8U, 16U, 32F images
	//if the input image isn't in those classes
	//it will be converted to 32F first and then filter it

	//if(src_image->depth == IPL_DEPTH_8U ||src_image->depth == IPL_DEPTH_16U ||src_image->depth == IPL_DEPTH_32F)
	//	{
	//		cvFilter2D(src_image, dst_image, f32_filter, cvPoint(-1,-1));
	//	}
	//else
	//{
	//	IplImage* tmp_image = cvCreateImage(cvSize(src_image->width, src_image->height),
	//		IPL_DEPTH_32F, src_image->nChannels);
	//	IplImage* tmp_filtered_image = cvCloneImage(tmp_image);

	//	if( !tmp_image || !tmp_filtered_image)
	//	{
	//		Scierror(999, "%s: Internal error for allocating memory for images.\r\n", fname);
	//		cvReleaseImage(&tmp_image);
	//		cvReleaseImage(&tmp_filtered_image);
	//		cvReleaseImage(&src_image);
	//		cvReleaseImage(&dst_image);
	//		cvReleaseImage(&src_filter);
	//		cvReleaseMat(&f32_filter);
	//		return -1;
	//	}
	//	cvConvert(src_image, tmp_image);
	//	cvFilter2D(tmp_image, tmp_filtered_image, f32_filter, cvPoint(-1,-1));
	//	cvConvert(tmp_filtered_image, dst_image);

	//	cvReleaseImage(&tmp_image);
	//	cvReleaseImage(&tmp_filtered_image);
	//}

	//IplImg2Mat(dst_image, Rhs+1);
	//LhsVar(1) = Rhs+1;

	//cvReleaseImage(&src_image);
	//cvReleaseImage(&dst_image);
	//cvReleaseImage(&src_filter);
	//cvReleaseMat(&f32_filter);
	SetImage(1,dst_image,pvApiCtx);
	return 0;
}
