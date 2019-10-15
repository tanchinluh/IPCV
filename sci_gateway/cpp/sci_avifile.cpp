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

int sci_avifile(char *fname,void* pvApiCtx)
{
	int mL, nL;
	int mR1, nR1, lR1;
	int mR2, nR2, lR2;
	int mR3, nR3, lR3;
	int mR4, nR4, lR4;
	int nPos = 0;
	int iRet = 0;
	int nCurrFile = 0;
	int *pret = &nCurrFile;
	int nWidth, nHeight;
	int nFPS = 25;
	char c1,c2,c3,c4;
	int c5;
	char *pstName = NULL;
	SciErr sciErr;
	int* piAddr = NULL;


	CheckInputArgument(pvApiCtx, 2, 4);
	CheckOutputArgument(pvApiCtx, 1, 1);

	// Get Filename
	//GetRhsVar(++nPos, "c", &mR1, &nR1, &lR1);
	GetString(1, pstName,pvApiCtx);
	sciprint("Following file has been created for saving video.\n");
	sciprint("Filename : %s\n",pstName);

	// Get Dimensions
	//GetRhsVar(++nPos, "i", &mR2, &nR2, &lR2);
	double *out = NULL;
	int iRows			= 0;
	int iCols			= 0;
	GetDouble(2,out,iRows,iCols,pvApiCtx);
	//CheckDims(nPos, mR2, nR2, 2, 1);
	nWidth = int(*out);
	nHeight = int(*(out+1));
	sciprint("Size : [%i,%i]\n",nWidth,nHeight);

	// Get Frame-rate
	if(*getNbInputArgument(pvApiCtx) >= 3)
	{
		GetDouble(3,out,iRows,iCols,pvApiCtx);
		nFPS = int(*out);
	}
	sciprint("FPS : %i\n",nFPS);

	// Get fourcc Codec 
	sciErr = getVarAddressFromPosition(pvApiCtx, 4, &piAddr);
	if(*getNbInputArgument(pvApiCtx) == 4)
	{
		if(isStringType(pvApiCtx, piAddr))
		{
			char *cc = NULL;
			GetString(4, cc,pvApiCtx);
			c1 = *(cc);
			c2 = *(cc+1);
			c3 = *(cc+2);
			c4 = *(cc+3);
			//sciprint("Filename : %s\n",cc);
			//sciprint("Filename : %c\t%c\t%c\t%c\n",c1,c2,c3,c4);
		}
		else if(isDoubleType(pvApiCtx, piAddr)) 
		{
			GetDouble(4,out,iRows,iCols,pvApiCtx);
			c5 = int(*out);
		}
		else
		{
			Scierror(999, "Input should be only fourcc code, '0' or '-1' ");
		}
	}

	for (nCurrFile = 0; nCurrFile < MAX_AVI_FILE_NUM; nCurrFile++)
	{
		if(!OpenedAvi[nCurrFile].writer.isOpened() & !OpenedAvi[nCurrFile].cap.isOpened())
			break;
	}

	if( nCurrFile ==  MAX_AVI_FILE_NUM)
	{
		Scierror(999, "%s: Too many video files (or cameras) opened. Use aviclose or avicloseall to close some files (cameras).\r\n", fname);
		return -1;
	}

	// Reference
	//OpenedAvi[nCurrFile].cap = VideoCapture(fn);
	//if (!OpenedAvi[nCurrFile].cap.isOpened())
	//{
	//	Scierror(999, "%s: Can not open video file %s. \nMaybe the codec of the video can not be handled or the file does not exist.\r\n", fname, fn);
	//	return -1;
	//}
	// Reference

	//OpenedAviCap[nCurrFile].video.writer = cvCreateVideoWriter(cstk(lR1), CV_FOURCC('X','V','I','D'), (double)nFPS, cvSize(nWidth, nHeight),1);
	sciErr = getVarAddressFromPosition(pvApiCtx, 4, &piAddr);
	if(isStringType(pvApiCtx, piAddr))
	{
		//OpenedAviCap[nCurrFile].video.writer = cvCreateVideoWriter(pstName, CV_FOURCC(c1,c2,c3,c4), (double)nFPS, cvSize(nWidth, nHeight),1);
		OpenedAvi[nCurrFile].writer = VideoWriter(pstName, VideoWriter::fourcc(c1, c2, c3, c4), (double)nFPS, cvSize(nWidth, nHeight), 1);
		if(!OpenedAvi[nCurrFile].writer.isOpened())
		{
			Scierror(999, "%s: Can not create video file %s or codec %c %c %c %c not found.\r\n", fname, pstName,c1,c2,c3,c4);
			return -1;
		}
	}
	else if(isDoubleType(pvApiCtx, piAddr))
	{
		//OpenedAviCap[nCurrFile].video.writer = cvCreateVideoWriter(pstName,c5, (double)nFPS, cvSize(nWidth, nHeight),1);
		OpenedAvi[nCurrFile].writer = VideoWriter(pstName, c5, (double)nFPS, cvSize(nWidth, nHeight), 1);
		if(!OpenedAvi[nCurrFile].writer.isOpened())
		{
			Scierror(999, "%s: Can not create video file %s or mode %i not supported.\r\n", fname, pstName,c5);
			return -1;
		}
	}
	else
		Scierror(999, "File Open Error.\r\n");


	strncpy(OpenedAvi[nCurrFile].filename, pstName, MAX_FILENAME_LENGTH);
	OpenedAvi[nCurrFile].iswriter = 1;
	OpenedAvi[nCurrFile].width = nWidth;
	OpenedAvi[nCurrFile].height = nHeight;

	//the output is the opened index
	nCurrFile += 1;

	mL = 1;
	nL = 1;
	//CreateVarFromPtr(++nPos, "i", &mL, &nL, &pret);
	iRet = createScalarDouble(pvApiCtx, nbInputArgument(pvApiCtx) + 1, (double)*pret);			
	AssignOutputVariable(pvApiCtx, 1) = nbInputArgument(pvApiCtx) + 1;
	//LhsVar(1) =nPos ;
	return 0;
}
