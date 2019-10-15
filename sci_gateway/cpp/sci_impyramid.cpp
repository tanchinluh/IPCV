/*******************************************************************************
 * SIVP - Scilab Image and Video Processing toolbox
 * Copyright (C) 2008  Jia Wu
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
 *******************************************************************************/

#include "common.h"

int sci_impyramid(char *fname,void* pvApiCtx)
{
	int mR = 0, nR = 0, lR = 0;

	//IplImage *pSrcImg = NULL;
	//IplImage *pDstImg = NULL;
	Mat pSrcImg, pDstImg;
	char *pstName = NULL;
	//CheckRhs(2, 2);
	//CheckLhs(1, 1);
	CheckInputArgument(pvApiCtx, 2, 2);
	CheckOutputArgument(pvApiCtx, 1, 1);
	
	//load the input image
	//pSrcImg = Mat2IplImg(1);
	//if(pSrcImg == NULL)
	//	Scierror(999, "%s: Internal error for getting the image data.\r\n", fname);
	GetImage(1,pSrcImg,pvApiCtx);
	

	if(nbInputArgument(pvApiCtx) == 2)
	{
		GetString(2, pstName,pvApiCtx);
	}
	else
	{
		pstName = "reduce";		
	}

	//GetRhsVar(2, "c", &mR, &nR, &lR);

	if(strcmp(pstName, "reduce") == 0)
	{
		//double dValueX = (double)(pSrcImg->width / 2);
		//double dValueY = (double)(pSrcImg->height / 2);
		//pDstImg = cvCreateImage(cvSize((int)ceil(dValueX), (int)ceil(dValueY)), pSrcImg->depth, pSrcImg->nChannels);
		pyrDown(pSrcImg, pDstImg);
	}
	else if(strcmp(pstName, "expand") == 0)
	{
		//pDstImg = cvCreateImage(cvSize(2*pSrcImg->width, 2*pSrcImg->height), pSrcImg->depth, pSrcImg->nChannels);
		pyrUp(pSrcImg, pDstImg);
	}
	else
	{
		//cvReleaseImage(&pSrcImg);
		Scierror(999, "%s, undefined method.\r\n", pstName);
	}

	SetImage(1,pDstImg,pvApiCtx);



	return 0;
}

