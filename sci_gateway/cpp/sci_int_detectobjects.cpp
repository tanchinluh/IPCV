/*****************************************************************************
* SIVP - Scilab Image and Video Processing toolbox
* Copyright (C) 2008  Jia Wu
* Copyright (C) 2008  Shiqi Yu (shiqi.yu@gmail.com)
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
*****************************************************************************/

#include "common.h"
#include "opencv2/objdetect.hpp"

/**********************************************************************
* this function only supports UINT8
* [objects]=detectobjects(im, xmlfile);
* objects is a Nx4 matrix.
* each row of objects is an object location [x,y,w,h]
**********************************************************************/

int sci_int_detectobjects(char * fname,void* pvApiCtx)
{

	static CvHaarClassifierCascade* pCascade = NULL;

	CheckInputArgument(pvApiCtx, 6, 6);
	CheckOutputArgument(pvApiCtx, 0, 1);
	
	Mat pSrcImg;
	GetImage(1,pSrcImg,pvApiCtx);

	char *fn = NULL;
	GetString(2, fn,pvApiCtx);

	double *d1 = NULL;
	int iRows1 = 0;
	int iCols1 = 0;
	double *d2 = NULL;
	int iRows2 = 0;
	int iCols2 = 0;
	double d1b; 
	int i2;
	GetDouble(3,d1,iRows1,iCols1,pvApiCtx);
	d1b = *d1;
	GetDouble(4,d2,iRows2,iCols2,pvApiCtx);
	i2 = int(*d2);

	int iRows3 = 0;
	int iCols3 = 0;
	int iRows4 = 0;
	int iCols4 = 0;

	double* mData = NULL;
	double* nData = NULL;

	GetDouble(5,mData,iRows1,iCols1,pvApiCtx);
	GetDouble(6,nData,iRows2,iCols2,pvApiCtx);

	CascadeClassifier face_cascade;

	Mat pGray;

	char       sFileName[MAX_FILENAME_LENGTH];

	face_cascade.load(fn);	

	cvtColor(pSrcImg, pGray, COLOR_BGR2GRAY);

	vector<Rect> faces;
	//face_cascade.detectMultiScale(pGray, faces, 1.1, 3, CV_HAAR_FIND_BIGGEST_OBJECT|CV_HAAR_SCALE_IMAGE, Size(30,30));
	face_cascade.detectMultiScale(pGray, faces, d1b, i2, 0, Size(*(mData),*(mData+1)),Size(*(nData),*(nData+1)));
	int *pt = NULL;
	int *opt = NULL;

	pt = &faces[0].x;
	opt = pt;

	for(int i = 0; i < faces.size(); i++)
	{
		Point pt1(faces[i].x + faces[i].width, faces[i].y + faces[i].height);
		Point pt2(faces[i].x, faces[i].y);
		//Rect r = faces[i];
		pt = &faces[i].x;++pt;
		pt = &faces[i].y; ++pt;
		pt = &faces[i].width; ++pt;
		pt = &faces[i].height; ++pt;
		//*(pt++) = faces[i].width;
		//*(pt++) = faces[i].height;
		//rectangle(pSrcImg, pt1, pt2, cvScalar(0, 255, 0, 0), 1, 8, 0);
		//sciprint("a face is found at Rect(%d,%d,%d,%d).\n", r.x, r.y, r.width, r.height);
	}
	//pt = &faces[0].x;

	//*pt = rr.x;
	int iRows			= 4;
	int iCols			= faces.size()*1;

	SciErr sciErr;
	sciErr = createMatrixOfInteger32(pvApiCtx, nbInputArgument(pvApiCtx) + 1, iRows, iCols, opt);      

	AssignOutputVariable(pvApiCtx, 1) = nbInputArgument(pvApiCtx) + 1;
	

	//SetImage(2,pSrcImg,pvApiCtx);

	return 0;
}
