/***********************************************************************
 * SIVP - Scilab Image and Video Processing toolbox
 * Copyright (C) 2006  Shiqi Yu
 * Copyright (C) 2005  Vincent Etienne
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

/**********************************************************************
* BW = sobel(im, dx, dy, thresh)
* [BW,thresh] = sobel(im, ...)
**********************************************************************/
int sci_int_sobel(char *fname,void* pvApiCtx)
{


	Mat pSrcImg, pSobelImg;
	int iRows1 = 0;
	int iCols1 = 0;
	double *d1 = NULL;
	int iRows2 = 0;
	int iCols2 = 0;
	double *d2 = NULL;
	int iRows3 = 0;
	int iCols3 = 0;
	double *d3 = NULL;
	int i1,i2;


	CheckInputArgument(pvApiCtx, 3, 3);
	CheckOutputArgument(pvApiCtx, 1, 1);

	GetImage(1,pSrcImg,pvApiCtx);


	if(!pSrcImg.data)
	{
		sciprint("%s Error: can't read the input image\r\n", fname);
		return 0;
	}

	GetDouble(2,d1,iRows1,iCols1,pvApiCtx);
	i1 = int(*d1);
	GetDouble(3,d2,iRows2,iCols2,pvApiCtx);
	i2 = int(*d2);
	

	Sobel(pSrcImg, pSobelImg, CV_64F,i1 , i2);
	
	double minVal, maxVal;
    minMaxLoc(pSobelImg, &minVal, &maxVal); 
   
    pSobelImg.convertTo(pSobelImg, CV_64F, 1.0/(maxVal - minVal), -minVal * 1.0/(maxVal - minVal));
 

	SetImage(1,pSobelImg,pvApiCtx);



	return 0;

}
