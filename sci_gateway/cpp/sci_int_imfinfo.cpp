/***********************************************************************
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

int sci_int_imfinfo(char *fname, void* pvApiCtx)
{
		//int mL, nL, lL;
		//int mxL;
	
		//int mR, nR, lR;
		//int One = 1;
		//int element = 0;
		//static char *NameStr[]= { "V",
		//	"Filename",
		//	"FileSize",
		//	"Width",
		//	"Height",
		//	"BitDepth",
		//	"ColorType"  };
		//char * pFilename;
		//double fValue;
		//double *pfValue = &fValue;
		//char sValue[16];
		//char **psValue = (char**)(&sValue);
	
		//IplImage * pImage = NULL;
	
	//#ifdef WIN_AIVP
	//	struct _stat fileStat;
	//#else
	//	struct stat fileStat;
	//#endif
	
	
		//CheckRhs(1,1);
		//CheckLhs(1,1);
	
		//GetRhsVar(1, "c", &mR, &nR, &lR);
	
		//pFilename = cstk(lR);
		////open image file
		//pImage = cvLoadImage(pFilename, -1);
	
		//if failed to open the video file
		//if(!pImage)
		//{
		//	Scierror(999, "%s: Can not open image file %s.\r\n", fname, pFilename);
		//	return -1;
		//}
	
		//mL = 7;
		//nL = 1;
	
		//CreateVar(2,"m", &mL, &nL, &lL);
	
		//CreateListVarFromPtr(2, ++element, "S", &mL, &nL, NameStr);
		////store file name
		////TODO: the path should be absolute path
		//mxL = (int)strlen(cstk(lR));
		//CreateListVarFromPtr(2, ++element, "c", &mxL, &One, &pFilename);
	
		//get the file size
	//#ifdef WIN_AIVP
	//	if( _stat(pFilename, &fileStat) != 0)
	//#else
	//	if( stat(pFilename, &fileStat) != 0)
	//#endif
	//	{
	//		Scierror(999, "%s: Can not get the information of file %s.\r\n", fname, pFilename);
	//		cvReleaseImage(&pImage);
	//		return -1;
	//	}
	//	fValue = (double)(fileStat.st_size);
	//	CreateListVarFromPtr(2, ++element, "d", &One, &One, &pfValue);
	//
	//	//Width
	//	fValue = (double)(pImage->width);
	//	CreateListVarFromPtr(2, ++element, "d", &One, &One, &pfValue);
	//
	//	//Height
	//	fValue = (double)(pImage->height);
	//	CreateListVarFromPtr(2, ++element, "d", &One, &One, &pfValue);
	//
	//	//BitDepth
	//	fValue = (double)(pImage->depth & 0x0FFFFFFF );
	//	CreateListVarFromPtr(2, ++element, "d", &One, &One, &pfValue);
	//
	//	//ColorType
	//	if( pImage->nChannels == 1 )
	//	{
	//		sprintf(sValue, "grayscale");
	//		mxL = 9;
	//	}
	//	else if( pImage->nChannels == 3 || pImage->nChannels == 4)
	//	{
	//		sprintf(sValue, "truecolor");
	//		mxL = 9;
	//	}
	//	else
	//	{
	//		mxL = 0;
	//	}
	//	CreateListVarFromPtr(2, ++element, "c", &mxL, &One, &psValue );
	//
	//	cvReleaseImage(&pImage);
	//
	//	LhsVar(1) =2 ;

	char *pstName = NULL;
	Mat pImage;
	SciErr sciErr;
	int *piAddr = NULL;
	double pdblData1[] = {0,0};
	double pdb1_depth;
	double pdb1_channel;

	CheckInputArgument(pvApiCtx, 1, 1);
	CheckOutputArgument(pvApiCtx, 1, 1);

	GetString(1, pstName, pvApiCtx);

	//pImage = cvLoadImage(cstk(lR), CV_LOAD_IMAGE_ANYDEPTH|CV_LOAD_IMAGE_ANYCOLOR);
	pImage = imread(pstName, IMREAD_LOAD_GDAL);

	sciErr = createList(pvApiCtx, nbInputArgument(pvApiCtx) + 1, 3, &piAddr);
	if (sciErr.iErr)
	{
		printError(&sciErr, 0);
		return 0;
	}
		
	Size s = pImage.size();
	pdblData1[0] = s.width;
	pdblData1[1] = s.height;
	pdb1_depth = pImage.depth() & 0x0FFFFFFF;
	pdb1_channel = pImage.channels();

	sciErr = createMatrixOfDoubleInList(pvApiCtx, nbInputArgument(pvApiCtx) + 1, piAddr, 1, 1, 2, pdblData1);
	if (sciErr.iErr)
	{
		printError(&sciErr, 0);
		return 0;
	}

	sciErr = createMatrixOfDoubleInList(pvApiCtx, nbInputArgument(pvApiCtx) + 1, piAddr, 2, 1, 1, &pdb1_depth);
	if (sciErr.iErr)
	{
		printError(&sciErr, 0);
		return 0;
	}

	sciErr = createMatrixOfDoubleInList(pvApiCtx, nbInputArgument(pvApiCtx) + 1, piAddr, 3, 1, 1, &pdb1_channel);
	if (sciErr.iErr)
	{
		printError(&sciErr, 0);
		return 0;
	}

	AssignOutputVariable(pvApiCtx, 1) = nbInputArgument(pvApiCtx) + 1;

	return 0;
}
