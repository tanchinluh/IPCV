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


/**********************************************************************
* imout=filter2(F, imin);
* the difference between filter2 and imfilter is:
* the returned matrix of filter2 is double,
* but the returned matrix of imfilter is as the same as input image
**********************************************************************/
int sci_filter2(char * fname,void* pvApiCtx)
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


	filter2D(src_image, dst_image, CV_64F, src_filter);

	
	SetImage(1,dst_image,pvApiCtx);
	return 0;
}
