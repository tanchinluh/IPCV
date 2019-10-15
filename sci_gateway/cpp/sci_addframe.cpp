/***********************************************************************
 * SIVP - Scilab Image and Video Processing toolbox
 * Copyright (C) 2005,2010  Shiqi Yu
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

/* read a frame from an opened video file*/
int sci_addframe(char * fname,void* pvApiCtx)
{
	int mR1, nR1, lR1;

	int nFile;
	Mat pImage;

	CheckInputArgument(pvApiCtx, 2, 2);
	CheckOutputArgument(pvApiCtx, 1, 1);

	double *out = NULL;
	int iRows			= 0;
	int iCols			= 0;
	GetDouble(1,out,iRows,iCols,pvApiCtx);

	nFile = int(*out);
	
	nFile -= 1;

	//check whether the nFile'th is a video writer
	if (!(nFile >= 0 && nFile < MAX_AVI_FILE_NUM))
	{
		Scierror(999, "%s: The argument should >=1 and <= %d.\r\n", fname, MAX_AVI_FILE_NUM);
		return -1;
	}

	if (!OpenedAvi[nFile].iswriter )
	{
		Scierror(999, "%s: The opened file is not for writing.\r\n", fname);
		return -1;
	}

	if(!OpenedAvi[nFile].writer.isOpened())
	{
		Scierror(999, "%s: The %d'th file is not opened.\r\n Please use avilistopened command to show opened files.\r\n",
			fname, nFile+1);
		return -1;
	}

	//load the input image
	//pImage = Mat2IplImg(2);
	GetImage(2,pImage,pvApiCtx);

	if(!pImage.data)
	{
		Scierror(999, "%s: Internal error for getting the image data.\r\n", fname);
		return -1;
	}
	//only UINT8 images are supported by cvWriteFrame
	if(pImage.depth() != CV_8U)
	{
		//cvReleaseImage(&pImage);
		Scierror(999, "%s: The input image must be UINT8.\r\n", fname);
		return -1;
	}

	//if the input frame is not the same size as pre-defined video writer
	//resize the input image
	if(pImage.cols != OpenedAvi[nFile].width
		||pImage.rows != OpenedAvi[nFile].height)
	{
		/*IplImage * pTmp = cvCreateImage(cvSize(OpenedAviCap[nFile].width,
			OpenedAviCap[nFile].height),
			IPL_DEPTH_8U,
			pImage->nChannels);
		if(!pTmp)
		{
			cvReleaseImage(&pImage);
			Scierror(999, "%s: Can not alloc memory.\r\n", fname);
			return -1;
		}*/
		//cvResize(pImage, pTmp, CV_INTER_LINEAR);
		Size dsize;
		dsize = Size(OpenedAvi[nFile].width, OpenedAvi[nFile].height);

		resize(pImage, pImage, dsize, 0, 0, INTER_LINEAR);

		//cvReleaseImage(&pImage);
		//pImage = pTmp;
	}
	OpenedAvi[nFile].writer << pImage;
	////IplImage * pImage2 = cvCloneImage(&(IplImage)pImage);//IplImage(pSrcImg1);
	////IplImage* pImage2 = new IplImage(pImage);
	////IplImage* pImage2 = pImage.operator IplImage();
	////Mat(const IplImage* pImage2, bool copyData=false);
	////IplImage temp = pImage;
	////IplImage* pImage2 = &temp;
	// //IplImage* pImage2 = &pImage.operator IplImage(); 
	////IplImage * pImage2 = cvCloneImage(&(IplImage)pImage);
	//
	//IplImage* pImage2;
	//pImage2 = cvCreateImage(cvSize(pImage.cols,pImage.rows),8,3);
	//IplImage ipltemp=pImage;
	//cvCopy(&ipltemp,pImage2);

	//if( cvWriteFrame(OpenedAviCap[nFile].video.writer, pImage2) != 0)
	//{
	//	//Scierror(999, "%s: Write frame error, please check input image size and depth.\r\n", fname);
	//	//return -1;
	//}

	////LhsVar(1) = 1;

	//cvReleaseImage(&pImage2);
	return 0;
}
