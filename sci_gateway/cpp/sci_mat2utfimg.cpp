/***********************************************************************
* SIVP - Scilab Image and Video Processing toolbox
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

/************************************************************/

int sci_mat2utfimg(char * fname,void* pvApiCtx)
{

	Mat Img;

	unsigned char * pUTFData = NULL;
	int nCurr = 0;

	int w,h,c;
	unsigned char Pixel;

	CheckInputArgument(pvApiCtx, 1, 1);
	CheckOutputArgument(pvApiCtx, 1, 1);


	GetImage(1,Img,pvApiCtx);

	if(!Img.data)
	{
		sciprint("%s Error: can't read the input image\r\n", fname);
		return 0;
	}

	// ToDo : Get rid of malloc?
	pUTFData=(unsigned char*)malloc(Img.size().width * Img.size().height * Img.channels() * 2);


	for(h=0; h < Img.rows; h++)
	{
		//sciprint("h = : %i\n",h);

		for(w=0; w < Img.cols; w++)
		{
			for(c=Img.channels()-1; c>=0; c--)
			{
				Pixel = Img.ptr<uchar>(h)[w*Img.channels() + c ];
				if(Pixel <= 127 && Pixel > 0)
				{
					pUTFData[nCurr++] = Pixel;
				}
				// To check the correct way representing 0 in utf-8. 194 128? previously 192 128 error. 0 not working 
				else if (Pixel == 0)	
				{
					//pUTFData[nCurr++] = (Pixel >> 6) + 0xC2; //11000000 + highest 2 bits 
					//pUTFData[nCurr++] = (Pixel & 0x3F) + 0x80;//10000000 + lest 6 bits
					pUTFData[nCurr++] = Pixel+1;
				}
				else
				{
					pUTFData[nCurr++] = (Pixel >> 6) + 0xC0; //11000000 + highest 2 bits
					pUTFData[nCurr++] = (Pixel & 0x3F) + 0x80;//10000000 + lest 6 bits
				}
			}

		}
	}
	SciErr sciErr;
	int iRows               = 1;
	int iCols               = nCurr;

	sciErr = createMatrixOfUnsignedInteger8(pvApiCtx, nbInputArgument(pvApiCtx) + 1, iRows, iCols, pUTFData);
	if(sciErr.iErr)
	{
		printError(&sciErr, 0);
		return sciErr.iErr;
	}


	if(pUTFData)
		free(pUTFData);


	AssignOutputVariable(pvApiCtx, 1) = nbInputArgument(pvApiCtx) + 1;
	return 0;
}

