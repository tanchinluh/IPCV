/***********************************************************************
* IPCV - Scilab Image Processing and Computer Vision toolbox
* Original work Copyright (C) 2017  Tan Chin Luh
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
static int iTab = 0;
void insert_indent(void)
{
	int i = 0;
	for(i = 0 ; i < iTab ; i++)
	{
		sciprint("\t");
	}
}

int SetImage(int nPos, Mat& new_img,void* pvApiCtx)
{

	Size s = new_img.size();
	int rows = new_img.size().height;
	int cols = new_img.size().width;
	int ndims;

	// 20190308 : Change from == to >= to cater higher dimension images
	// new_img.channels() is the number of layers in Scilab, while ndims is the dimension of the Matrix. 
	// whether is RGB, or RGBA, or in future GDAL images with more layers, ndims is still 3. 
	if 	(new_img.channels() >=3 )
	{ndims = 3;}
	else
	{ndims = 2;}

	//int ndims = new_img.ndims;
	int dims_var[3] = {rows,cols,new_img.channels()};
	int *dims;
	dims = dims_var;
	void * pMatData;


	SciErr sciErr;
	//sciprint("-----------------------\n");
	//sciprint("Set Image Properties...\n");
	//sciprint("-----------------------\n");
	//sciprint("dims : %i\n",new_img.dims);
	//sciprint("rows  : %i\n",new_img.rows );
	//sciprint("cols  : %i\n",new_img.cols );
	//sciprint("channels  : %i\n",new_img.channels() );
	//sciprint("dims  : %i\t %i\t %i\t\n",*dims, *(dims+1), *(dims+2));
	//sciprint("depth  : %i\n",new_img.depth());

	switch(new_img.depth())
	{
	case CV_8U:
		{

			//////////////////////////
			// ND Uint8 Scilab Image
			//////////////////////////

			//if (ndims>3)
			//{
			//	//sciprint("CV_8U\n");
			//	sciprint("1\n");
			//	pMatData = malloc(new_img.size().width * new_img.size().height * new_img.channels() * new_img.elemSize1());
			//	matdata2scidata(new_img, pMatData);
			//	sciprint("2\n");
			//	sciErr = createHypermatOfUnsignedInteger8(pvApiCtx, nbInputArgument(pvApiCtx) + nPos, dims, ndims, (const unsigned char*)pMatData);
			//	if (sciErr.iErr)
			//	{
			//		printError(&sciErr, 0);
			//		return sciErr.iErr;
			//	}
			//	sciprint("3\n");
			//	AssignOutputVariable(pvApiCtx, nPos) = nbInputArgument(pvApiCtx) + nPos;
			//}

			//////////////////////////
			// 3D Uint8 Scilab Image
			//////////////////////////

			if (ndims>=3)
			{
				//sciprint("CV_8U\n");
				pMatData = malloc(new_img.size().width * new_img.size().height * new_img.channels() * new_img.elemSize1());
				matdata2scidata(new_img, pMatData);

				sciErr = createHypermatOfUnsignedInteger8(pvApiCtx, nbInputArgument(pvApiCtx) + nPos, dims, 3, (const unsigned char*)pMatData);
				if (sciErr.iErr)
				{
					printError(&sciErr, 0);
					return sciErr.iErr;
				}

				AssignOutputVariable(pvApiCtx, nPos) = nbInputArgument(pvApiCtx) + nPos;
			}
			//////////////////////////
			// 2D Uint8 Scilab Image
			//////////////////////////

			else if (ndims == 2)
			{

				double s1 = sum(new_img==0)[0]/255;
				double s2 = sum(new_img==255)[0]/255;
				double s3 = new_img.rows*new_img.cols;

				if (s3 == (s1+s2))
				{
					//sciprint("binary");

					Mat new_img2;
					//new_img2 = Mat(2, sz2, CV_32S);

					new_img.convertTo(new_img2,CV_32S,1.0/255);

					pMatData = malloc(new_img2.size().width * new_img2.size().height * new_img2.channels() * new_img2.elemSize1());
					matdata2scidata(new_img2, pMatData);
					sciErr = createMatrixOfBoolean(pvApiCtx, nbInputArgument(pvApiCtx) + nPos, rows, cols, (int*)pMatData);
					if(sciErr.iErr)
					{
						printError(&sciErr, 0);
						return sciErr.iErr;
					}
					AssignOutputVariable(pvApiCtx, nPos) = nbInputArgument(pvApiCtx) + nPos;
				}

				else
				{
					////
					pMatData = malloc(new_img.size().width * new_img.size().height * new_img.channels() * new_img.elemSize1());
					matdata2scidata(new_img, pMatData);
					sciErr = createMatrixOfUnsignedInteger8(pvApiCtx, nbInputArgument(pvApiCtx) + nPos, rows, cols, (unsigned char*)pMatData);
					if(sciErr.iErr)
					{
						printError(&sciErr, 0);
						return sciErr.iErr;
					}
					AssignOutputVariable(pvApiCtx, nPos) = nbInputArgument(pvApiCtx) + nPos;
				}

				////

			}
			else
			{
				Scierror(999, ("%s: Wrong type for input argument: An Image expected.\n"), 1);
				return -1;
			}

		}
		break;
	case CV_8S:
		{
			//////////////////////////
			// 3D int8 Scilab Image
			//////////////////////////

			if (ndims>=3)
			{
				//sciprint("CV_8S\n");
				pMatData = malloc(new_img.size().width * new_img.size().height * new_img.channels() * new_img.elemSize1());
				matdata2scidata(new_img, pMatData);

				sciErr = createHypermatOfInteger8(pvApiCtx, nbInputArgument(pvApiCtx) + nPos, dims, 3, (const char*)pMatData);
				if (sciErr.iErr)
				{
					printError(&sciErr, 0);
					return sciErr.iErr;
				}

				AssignOutputVariable(pvApiCtx, nPos) = nbInputArgument(pvApiCtx) + nPos;
			}
			//////////////////////////
			// 2D int8 Scilab Image
			//////////////////////////

			else if (ndims == 2)
			{
				pMatData = malloc(new_img.size().width * new_img.size().height * new_img.channels() * new_img.elemSize1());
				matdata2scidata(new_img, pMatData);

				//sciErr = createMatrixOfUnsignedInteger8(pvApiCtx, nbInputArgument(pvApiCtx) + nPos, rows, cols, (const unsigned char*)new_img.data);
				sciErr = createMatrixOfInteger8(pvApiCtx, nbInputArgument(pvApiCtx) + nPos, rows, cols, (char*)pMatData);
				if(sciErr.iErr)
				{
					printError(&sciErr, 0);
					return sciErr.iErr;
				}
				AssignOutputVariable(pvApiCtx, nPos) = nbInputArgument(pvApiCtx) + nPos;
			}
			else
			{
				Scierror(999, ("%s: Wrong type for input argument: An Image expected.\n"), 1);
				return -1;
			}

		}
		break;
	case CV_16U:
		{

			//////////////////////////
			// 3D Uint16 Scilab Image
			//////////////////////////

			if (ndims>=3)
			{
				//sciprint("CV_16U\n");
				pMatData = malloc(new_img.size().width * new_img.size().height * new_img.channels() * new_img.elemSize1());
				matdata2scidata(new_img, pMatData);

				sciErr = createHypermatOfUnsignedInteger16(pvApiCtx, nbInputArgument(pvApiCtx) + nPos, dims, 3, (const unsigned short*)pMatData);
				if (sciErr.iErr)
				{
					printError(&sciErr, 0);
					return sciErr.iErr;
				}

				AssignOutputVariable(pvApiCtx, nPos) = nbInputArgument(pvApiCtx) + nPos;
			}
			//////////////////////////
			// 2D Uint16 Scilab Image
			//////////////////////////

			else if (ndims == 2)
			{
				pMatData = malloc(new_img.size().width * new_img.size().height * new_img.channels() * new_img.elemSize1());
				matdata2scidata(new_img, pMatData);

				//sciErr = createMatrixOfUnsignedInteger8(pvApiCtx, nbInputArgument(pvApiCtx) + nPos, rows, cols, (const unsigned char*)new_img.data);
				sciErr = createMatrixOfUnsignedInteger16(pvApiCtx, nbInputArgument(pvApiCtx) + nPos, rows, cols, (unsigned short*)pMatData);
				if(sciErr.iErr)
				{
					printError(&sciErr, 0);
					return sciErr.iErr;
				}
				AssignOutputVariable(pvApiCtx, nPos) = nbInputArgument(pvApiCtx) + nPos;
			}
			else
			{
				Scierror(999, ("%s: Wrong type for input argument: An Image expected.\n"), 1);
				return -1;
			}

		}
		break;
	case CV_16S:
		{

			//////////////////////////
			// 3D int16 Scilab Image
			//////////////////////////

			if (ndims>=3)
			{
				//sciprint("CV_16S\n");
				pMatData = malloc(new_img.size().width * new_img.size().height * new_img.channels() * new_img.elemSize1());
				matdata2scidata(new_img, pMatData);

				sciErr = createHypermatOfInteger16(pvApiCtx, nbInputArgument(pvApiCtx) + nPos, dims, 3, (const short*)pMatData);
				if (sciErr.iErr)
				{
					printError(&sciErr, 0);
					return sciErr.iErr;
				}

				AssignOutputVariable(pvApiCtx, nPos) = nbInputArgument(pvApiCtx) + nPos;
			}
			//////////////////////////
			// 2D int16 Scilab Image
			//////////////////////////

			else if (ndims == 2)
			{
				pMatData = malloc(new_img.size().width * new_img.size().height * new_img.channels() * new_img.elemSize1());
				matdata2scidata(new_img, pMatData);

				//sciErr = createMatrixOfUnsignedInteger8(pvApiCtx, nbInputArgument(pvApiCtx) + nPos, rows, cols, (const unsigned char*)new_img.data);
				sciErr = createMatrixOfInteger16(pvApiCtx, nbInputArgument(pvApiCtx) + nPos, rows, cols, (short*)pMatData);
				if(sciErr.iErr)
				{
					printError(&sciErr, 0);
					return sciErr.iErr;
				}
				AssignOutputVariable(pvApiCtx, nPos) = nbInputArgument(pvApiCtx) + nPos;
			}
			else
			{
				Scierror(999, ("%s: Wrong type for input argument: An Image expected.\n"), 1);
				return -1;
			}

		}
		break;
	case CV_32S:
		{

			//////////////////////////
			// 3D int32 Scilab Image
			//////////////////////////

			if (ndims>=3)
			{
				//sciprint("CV_32S\n");
				pMatData = malloc(new_img.size().width * new_img.size().height * new_img.channels() * new_img.elemSize1());
				matdata2scidata(new_img, pMatData);

				sciErr = createHypermatOfInteger32(pvApiCtx, nbInputArgument(pvApiCtx) + nPos, dims, 3, (const int*)pMatData);
				if (sciErr.iErr)
				{
					printError(&sciErr, 0);
					return sciErr.iErr;
				}

				AssignOutputVariable(pvApiCtx, nPos) = nbInputArgument(pvApiCtx) + nPos;
			}
			//////////////////////////
			// 2D int32 Scilab Image
			//////////////////////////

			else if (ndims == 2)
			{
				pMatData = malloc(new_img.size().width * new_img.size().height * new_img.channels() * new_img.elemSize1());
				matdata2scidata(new_img, pMatData);

				//sciErr = createMatrixOfUnsignedInteger8(pvApiCtx, nbInputArgument(pvApiCtx) + nPos, rows, cols, (const unsigned char*)new_img.data);
				sciErr = createMatrixOfInteger32(pvApiCtx, nbInputArgument(pvApiCtx) + nPos, rows, cols, (int*)pMatData);
				if(sciErr.iErr)
				{
					printError(&sciErr, 0);
					return sciErr.iErr;
				}
				AssignOutputVariable(pvApiCtx, nPos) = nbInputArgument(pvApiCtx) + nPos;
			}
			else
			{
				Scierror(999, ("%s: Wrong type for input argument: An Image expected.\n"), 1);
				return -1;
			}

		}
		break;


	case CV_32F:
		//sciprint("CV_32F\n");
		//sciprint("%i %i %i\ %i\n", new_img.size().width , new_img.size().height , new_img.channels() , new_img.elemSize1());

		{
			//sciprint("CV_64F\n");
			new_img.convertTo(new_img,CV_64F);

			if (ndims >= 3)
			{
				pMatData = malloc(new_img.size().width * new_img.size().height * new_img.channels() * new_img.elemSize1());
				matdata2scidata(new_img, pMatData);

				sciErr = createHypermatOfDouble(pvApiCtx, nbInputArgument(pvApiCtx) + nPos, dims, 3, (double*)pMatData);
				if (sciErr.iErr)
				{
					printError(&sciErr, 0);
					return sciErr.iErr;
				}

				AssignOutputVariable(pvApiCtx, nPos) = nbInputArgument(pvApiCtx) + nPos;
			}
			else if (ndims == 2 )
			{

				pMatData = malloc(new_img.size().width * new_img.size().height * new_img.channels() * new_img.elemSize1());
				matdata2scidata(new_img, pMatData);

				sciErr = createMatrixOfDouble(pvApiCtx, nbInputArgument(pvApiCtx) + nPos, rows, cols, (double*)pMatData);
				if(sciErr.iErr)
				{
					printError(&sciErr, 0);
					return sciErr.iErr;
				}
				AssignOutputVariable(pvApiCtx, nPos) = nbInputArgument(pvApiCtx) + nPos;

			}
			else
			{
				Scierror(999, ("%s: Wrong type for input argument: An Image expected.\n"), 1);
				return -1;
			}
		}
		break;
	case CV_64F:
		{
			//sciprint("CV_64F\n");

			if (ndims >= 3)
			{
				pMatData = malloc(new_img.size().width * new_img.size().height * new_img.channels() * new_img.elemSize1());
				matdata2scidata(new_img, pMatData);

				sciErr = createHypermatOfDouble(pvApiCtx, nbInputArgument(pvApiCtx) + nPos, dims, 3, (double*)pMatData);
				if (sciErr.iErr)
				{
					printError(&sciErr, 0);
					return sciErr.iErr;
				}

				AssignOutputVariable(pvApiCtx, nPos) = nbInputArgument(pvApiCtx) + nPos;
			}
			else if (ndims == 2 )
			{

				pMatData = malloc(new_img.size().width * new_img.size().height * new_img.channels() * new_img.elemSize1());
				matdata2scidata(new_img, pMatData);

				sciErr = createMatrixOfDouble(pvApiCtx, nbInputArgument(pvApiCtx) + nPos, rows, cols, (double*)pMatData);
				if(sciErr.iErr)
				{
					printError(&sciErr, 0);
					return sciErr.iErr;
				}
				AssignOutputVariable(pvApiCtx, nPos) = nbInputArgument(pvApiCtx) + nPos;

			}
			else
			{
				Scierror(999, ("%s: Wrong type for input argument: An Image expected.\n"), 1);
				return -1;
			}
		}
		break;
	default:
		sciprint("Unknown type !\n"); // Should never happen
	}
	//sciErr = createHypermatOfUnsignedInteger8(pvApiCtx, nbInputArgument(pvApiCtx) + 1, dims, ndims, (const unsigned char*)new_img.data);
	free(pMatData);
	new_img.release();
	//free(pSrc);
	//free(pDst);
	return 0;
}

//int scidata2matdata(Mat &pImage, void* pMatData)
int matdata2scidata(Mat &pImage, void *pMatData)
{
	//  IPL_DEPTH_8U, IPL_DEPTH_8S, IPL_DEPTH_16U,
	//IPL_DEPTH_16S, IPL_DEPTH_32S, IPL_DEPTH_32F and IPL_DEPTH_64F
	//int row, col, ch;
	int rows, cols;
	long nCount = 0;
	int nBytes;

	unsigned char * pSrc = NULL;
	unsigned char * pDst = NULL;

	//if (pImage == NULL || pMatData == NULL)
	//	return FALSE;

	/////////////
	//pSrc = (unsigned char*)(pImage.data);
	//pDst = (unsigned char*)pMatData;

	///*how many bytes per pixel per channel*/
	//nBytes = pImage.elemSize1();
	//
	//for(ch = 0; ch < pImage.channels() ; ch++) //the order of IplImage is BGR
	//	for(col =0; col < pImage.size().width; col++)
	//		for(row = 0; row < pImage.size().height; row++)
	//		{
	//			memcpy(pDst+nCount, pSrc + pImage.step*row + (col*pImage.channels() + (pImage.channels()-ch-1))*nBytes, nBytes );
	//			nCount += nBytes;
	//			//sciprint(".");
	//		}
	/////////////

	///////////////////////////////////////
	pImage = pImage.t();
	pSrc = (unsigned char*)(pImage.data);
	pDst = (unsigned char*)pMatData;
	rows = pImage.rows;
	cols = pImage.cols;
	vector<Mat> ch1; // B, G, R channels
	split(pImage, ch1);
	nBytes = pImage.elemSize1();	


	//unsigned char * data = NULL;
	//data = (unsigned char*)pMatData;

	if (pImage.channels()==1)
	{
		memcpy(pDst, ch1[0].ptr(), rows*cols*nBytes);
	}
	else if (pImage.channels() == 3)
	{
		memcpy(pDst + 0 * rows*cols*nBytes, ch1[2].ptr(), rows*cols*nBytes);
		memcpy(pDst + 1 * rows*cols*nBytes, ch1[1].ptr(), rows*cols*nBytes);
		memcpy(pDst + 2 * rows*cols*nBytes, ch1[0].ptr(), rows*cols*nBytes);
	}
	else if (pImage.channels() == 4)
	{
		memcpy(pDst + 0 * rows*cols*nBytes, ch1[2].ptr(), rows*cols*nBytes);
		memcpy(pDst + 1 * rows*cols*nBytes, ch1[1].ptr(), rows*cols*nBytes);
		memcpy(pDst + 2 * rows*cols*nBytes, ch1[0].ptr(), rows*cols*nBytes);
		memcpy(pDst + 3 * rows*cols*nBytes, ch1[3].ptr(), rows*cols*nBytes);
	}
	else
	{
		// 20190308 - Changed to for loop to cater N Dim Images
		int i;
		for (i = 0; i <pImage.channels(); i++) {
			//memcpy(pDst, ch1[2].ptr(), rows*cols*nBytes);
			//memcpy(pDst + rows*cols*nBytes, ch1[1].ptr(), rows*cols*nBytes);
			//memcpy(pDst + 2 * rows*cols*nBytes, ch1[0].ptr(), rows*cols*nBytes);
			memcpy(pDst + i * rows*cols*nBytes, ch1[i].ptr(), rows*cols*nBytes);
		}
	}

	///////////////////////////////////////



	//memcpy(pDst + pImage.step*row + (col*pImage.channels() + (pImage.channels()-ch-1))*nBytes, pSrc+nCount, nBytes );
	//sciprint("Test3\n");

	//pDst = (unsigned char*)pImage.data;
	//	pSrc = (unsigned char*)pMatData;
	//
	//	
	//
	//	/*how many bytes per pixel per channel*/
	//	nBytes = pImage.elemSize1();
	//
	//	for(ch = 0; ch < pImage.channels() ; ch++) //the order of IplImage is BGR
	//		for(col =0; col < pImage.size().width; col++)
	//			for(row = 0; row < pImage.size().height; row++)
	//			{
	//				memcpy(pDst + pImage.step*row + (col*pImage.channels() + (pImage.channels()-ch-1))*nBytes, pSrc+nCount, nBytes );
	//				nCount += nBytes;
	//			}
	pImage.release();
	//free(pMatData);
	//free(pSrc);
//	free(pDst);
	return 0;
}

//int scidata2matdata(Mat &pImage, unsigned char* pMatData)
int scidata2matdata(Mat &pImage, void* pMatData)
{
	//int row, col, ch;
	int rows, cols;
	long nCount = 0;
	int nBytes;
	SciErr sciErr;
	unsigned char * pDst = NULL;
	unsigned char * pSrc = NULL;
	//sciprint("pucData : %d \t %d \t %c \t %c \t\n", pMatData, &pMatData, pMatData, &pMatData);
	//if (pImage == NULL || pMatData == NULL)
	//	return FALSE;
	//sciprint("Check Point 1\n");


	////////////////
	//pDst = (unsigned char*)pImage.data;
	//pSrc = (unsigned char*)pMatData;
	///*how many bytes per pixel per channel*/
	//nBytes = pImage.elemSize1();
	//for(ch = 0; ch < pImage.channels() ; ch++) //the order of IplImage is BGR
	//	for(col =0; col < pImage.size().width; col++)
	//		for(row = 0; row < pImage.size().height; row++)
	//		{
	//			memcpy(pDst + pImage.step*row + (col*pImage.channels() + (pImage.channels()-ch-1))*nBytes, pSrc+nCount, nBytes );
	//			nCount += nBytes;
	//		}
	//////////////////

	///////////////////////////////////////
	//pImage = pImage.t();
	pImage = pImage.t();
	pDst = (unsigned char*)(pImage.data);
	pSrc = (unsigned char*)pMatData;
	rows = pImage.rows;
	cols = pImage.cols;

	nBytes = pImage.elemSize1();	
	//nBytes = 1;	
	//sciprint("nBytes : %i\n",nBytes);
	if (pImage.channels()==1)
	{
		memcpy(pDst, pSrc, rows*cols*nBytes);
	}
	else if (pImage.channels() == 3)
	{
		vector<Mat> ch1; // B, G, R channels
		split(pImage, ch1);

		//memcpy(pDst, ch1[2].ptr(), rows*cols*nBytes);
		//memcpy(pDst+rows*cols, ch1[1].ptr(), rows*cols*nBytes);
		//memcpy(pDst+2*rows*cols, ch1[0].ptr(), rows*cols*nBytes);
		memcpy(ch1[2].ptr(), pSrc, rows*cols*nBytes);
		memcpy(ch1[1].ptr(), pSrc+rows*cols*nBytes, rows*cols*nBytes);
		memcpy(ch1[0].ptr(), pSrc+2*rows*cols*nBytes, rows*cols*nBytes);
		//ch1[2].data = pSrc;
		//ch1[1].data = pSrc+rows*cols;
		//ch1[0].data = pSrc+2*rows*cols;
		merge(ch1,pImage);
	}

	// 20190309 : Add to write multidimension images
	else if (pImage.channels() == 4)
	{
		vector<Mat> ch1; // B, G, R channels
		split(pImage, ch1);


		memcpy(ch1[2].ptr(), pSrc + 0 * rows*cols*nBytes, rows*cols*nBytes);
		memcpy(ch1[1].ptr(), pSrc + 1 * rows*cols*nBytes, rows*cols*nBytes);
		memcpy(ch1[0].ptr(), pSrc + 2 * rows*cols*nBytes, rows*cols*nBytes);
		memcpy(ch1[3].ptr(), pSrc + 3 * rows*cols*nBytes, rows*cols*nBytes);

		//ch1[2].data = pSrc;
		//ch1[1].data = pSrc+rows*cols;
		//ch1[0].data = pSrc+2*rows*cols;
		merge(ch1, pImage);
	}
	else
	{
		printError(&sciErr, 0);
	}



	pImage = pImage.t();

	//////////////////////
	//int ch,col;
	//sciprint("This line show pDst\n");
	//for(ch = 0; ch < rows ; ch++) 
	//{
	//	for(col =0; col < cols; col++)		
	//	{
	//		//sciprint("%i\t%i\t%i\n",&pDst,pDst,*pDst);
	//		//*pDst++;
	//		sciprint("%d\t",*(pDst+ch*pImage.step+col)); //
	//		//sciprint("%f\t",pDst[ch*pImage.step+col]);
	//	}
	//	sciprint("\n");
	//}
	//////////////////////
	return 0;
}


int GetImage(int nPos, Mat& new_img,void* pvApiCtx)
{

	SciErr sciErr;
	int* piAddr = NULL;
	int iType   = 0;
	int iRet    = 0;
	int * dims = NULL;
	int ndims;
	double* pdblReal	= NULL;

	sciErr = getVarAddressFromPosition(pvApiCtx, nPos, &piAddr);
	if (sciErr.iErr)
	{
		printError(&sciErr, 0);
		return -1;
	}

	sciErr = getVarType(pvApiCtx, piAddr, &iType);
	if(sciErr.iErr)
	{
		printError(&sciErr, 0);
		return -1;
	}

	//sciprint("\tType: %i : ", iType);

	switch(iType)
	{
	case sci_matrix:
		{
			if (isHypermatType(pvApiCtx, piAddr))
			{
				/////////////////////
				// 3D Double Image //
				/////////////////////
				sciErr = getHypermatOfDouble(pvApiCtx, piAddr, &dims, &ndims, &pdblReal);
				if (sciErr.iErr)
				{
					printError(&sciErr, 0);
					return -1;
				}
				int sz2[] = {*dims, *(dims+1), *(dims+2)};
				//new_img = Mat(ndims, sz2, CV_64F, pdblReal);	
				new_img = Mat(2, sz2, CV_64FC(*(dims + 2)));
				scidata2matdata(new_img, pdblReal);
			}
			else
			{

				//sciprint("2D Double Image Detected...\n");
				int iRows			= 0;
				int iCols			= 0;

				/////////////////////
				// 2D Double Image //
				/////////////////////

				sciErr = getMatrixOfDouble(pvApiCtx, piAddr, &iRows, &iCols, &pdblReal);
				if(sciErr.iErr)
				{
					printError(&sciErr, 0);
					return sciErr.iErr;
				}

				int sz2[] = {iRows,iCols};

				new_img = Mat(2, sz2, CV_64F);
				scidata2matdata(new_img, pdblReal);
			}


		}
		break;
	case sci_poly:
		sciprint("A matrix of polynomials\n");
		break;
	case sci_boolean:
		{
			if (isHypermatType(pvApiCtx, piAddr))
			{
				int* piBool	= NULL;
				/////////////////////
				// 3D Boolean Image //
				/////////////////////
				sciErr = getHypermatOfBoolean(pvApiCtx, piAddr, &dims, &ndims, &piBool);
				//sciErr = getHypermatOfInteger32(pvApiCtx, piAddr, &dims, &ndims, &piBool);			
				if (sciErr.iErr)
				{
					printError(&sciErr, 0);
					return -1;
				}
				int sz2[] = {*dims, *(dims+1), *(dims+2)};
				//new_img = Mat(ndims, sz2, CV_64F, pdblReal);	
				//new_img = Mat(2, sz2, CV_64FC3);
				//scidata2matdata(new_img, pdblReal);

				/////////////////////
				//int sz2[] = {iRows,iCols};

				Mat new_img2;
				new_img2 = Mat(2, sz2, CV_32SC3);
				scidata2matdata(new_img2, piBool);
				new_img = Mat(2, sz2, CV_8UC(*(dims + 2)));
				new_img2.convertTo(new_img,CV_8UC(*(dims + 2)),255);
			}
			else
			{

				int iRows	= 0;
				int iCols	= 0;
				int* piBool	= NULL;
				sciErr = getMatrixOfBoolean(pvApiCtx, piAddr, &iRows, &iCols, &piBool);
				if(sciErr.iErr)
				{
					printError(&sciErr, 0);
					return -1;
				}
				int sz2[] = {iRows,iCols};

				Mat new_img2;
				new_img2 = Mat(2, sz2, CV_32S);
				scidata2matdata(new_img2, piBool);

				new_img = Mat(2, sz2, CV_8U);
				new_img2.convertTo(new_img,CV_8U,255);
			}

		}
		break;
	case sci_sparse:
		sciprint("A sparse matrix of doubles\n");
		break;
	case sci_boolean_sparse:
		sciprint("A sparse matrix of booleans\n");
		break;
	case sci_matlab_sparse:
		sciprint("A sparse matlab matrix\n");
		break;
	case sci_ints:
		//sciprint("A matrix of integers\n");
		{
			int precision;
			sciErr = getMatrixOfIntegerPrecision(pvApiCtx, piAddr, &precision);
			if (sciErr.iErr)
			{
				printError(&sciErr, 0);
				return sciErr.iErr;
			}
			//sciprint("datatype found: %i\n",precision);
			switch (precision)
			{
			case SCI_INT8:
				{
					if (isHypermatType(pvApiCtx, piAddr))
					{
						//void * data = NULL;
						char* pucData  = NULL;

						//sciprint("Precision : %i - SCI_UINT8\n", precision);
						/////////////////////
						// 3D INT8 Image //
						/////////////////////
						//sciErr = getHypermatOfUnsignedInteger8(pvApiCtx, piAddr, &dims, &ndims, (unsigned char**)&data);
						sciErr = getHypermatOfInteger8(pvApiCtx, piAddr, &dims, &ndims, &pucData);
						if (sciErr.iErr)
						{
							printError(&sciErr, 0);
							return -1;
						}
						int sz2[] = {*dims, *(dims+1), *(dims+2)};

						new_img = Mat(2, sz2, CV_8SC(*(dims + 2)));
						scidata2matdata(new_img, pucData);
					}
					else
					{

						int iRows               = 0;
						int iCols               = 0;
						char* pucData  = NULL;

						//sciprint("Precision : %i - SCI_UINT8\n", precision);
						/////////////////////
						// 2D UINT8 Image //
						/////////////////////
						sciErr = getMatrixOfInteger8(pvApiCtx, piAddr, &iRows, &iCols, &pucData);
						if (sciErr.iErr)
						{
							printError(&sciErr, 0);
							return sciErr.iErr;
						}
						int sz2[] = {iRows,iCols};

						new_img = Mat(2, sz2, CV_8S);
						scidata2matdata(new_img, pucData);
					}
				}
				break;
			case SCI_UINT8:
				{

					if (isHypermatType(pvApiCtx, piAddr))
					{
						//void * data = NULL;
						unsigned char* pucData  = NULL;

						//sciprint("Precision : %i - SCI_UINT8\n", precision);
						/////////////////////
						// 3D UINT8 Image //
						/////////////////////
						sciErr = getHypermatOfUnsignedInteger8(pvApiCtx, piAddr, &dims, &ndims, &pucData);
						if (sciErr.iErr)
						{
							printError(&sciErr, 0);
							return -1;
						}
						int sz2[] = {*dims, *(dims+1), *(dims+2)};
						new_img = Mat(2, sz2, CV_8UC(*(dims + 2)));
						scidata2matdata(new_img, pucData);
					}
					else
					{
						int iRows               = 0;
						int iCols               = 0;
						unsigned char* pucData  = NULL;

						/////////////////////
						// 2D UINT8 Image //
						/////////////////////
						sciErr = getMatrixOfUnsignedInteger8(pvApiCtx, piAddr, &iRows, &iCols, &pucData);
						if (sciErr.iErr)
						{
							printError(&sciErr, 0);
							return sciErr.iErr;
						}
						int sz2[] = {iRows,iCols};

						new_img = Mat(2, sz2, CV_8U);
						scidata2matdata(new_img, pucData);
					}

				}
				break;
			case SCI_INT16:
				{
					if (isHypermatType(pvApiCtx, piAddr))
					{
						//void * data = NULL;
						short* pucData  = NULL;

						//sciprint("Precision : %i - SCI_UINT16\n", precision);
						/////////////////////
						// 3D INT16 Image //
						/////////////////////
						//sciErr = getHypermatOfUnsignedInteger8(pvApiCtx, piAddr, &dims, &ndims, (unsigned char**)&data);
						sciErr = getHypermatOfInteger16(pvApiCtx, piAddr, &dims, &ndims, &pucData);
						if (sciErr.iErr)
						{
							printError(&sciErr, 0);
							return -1;
						}
						int sz2[] = {*dims, *(dims+1), *(dims+2)};
						//new_img = Mat(2, sz2, CV_8UC3, pucData);	

						//int sz2[] = {iCols,iRows};

						new_img = Mat(2, sz2, CV_16SC(*(dims + 2)));
						scidata2matdata(new_img, pucData);
					}
					else
					{

						int iRows               = 0;
						int iCols               = 0;
						short* pucData  = NULL;

						/////////////////////
						// 2D UINT16 Image //
						/////////////////////
						sciErr = getMatrixOfInteger16(pvApiCtx, piAddr, &iRows, &iCols, &pucData);
						if (sciErr.iErr)
						{
							printError(&sciErr, 0);
							return sciErr.iErr;
						}
						int sz2[] = {iRows,iCols};

						new_img = Mat(2, sz2, CV_16S);
						scidata2matdata(new_img, pucData);
					}

				}
				break;

			case SCI_UINT16:
				{
					if (isHypermatType(pvApiCtx, piAddr))
					{
						unsigned short* pucData  = NULL;

						//sciprint("Precision : %i - SCI_UINT16\n", precision);
						/////////////////////
						// 3D UINT16 Image //
						/////////////////////
						//sciErr = getHypermatOfUnsignedInteger8(pvApiCtx, piAddr, &dims, &ndims, (unsigned char**)&data);
						sciErr = getHypermatOfUnsignedInteger16(pvApiCtx, piAddr, &dims, &ndims, &pucData);
						if (sciErr.iErr)
						{
							printError(&sciErr, 0);
							return -1;
						}
						int sz2[] = {*dims, *(dims+1), *(dims+2)};
						//new_img = Mat(2, sz2, CV_8UC3, pucData);	

						//int sz2[] = {iCols,iRows};

						new_img = Mat(2, sz2, CV_16UC(*(dims + 2)));
						scidata2matdata(new_img, pucData);
					}
					else
					{

						int iRows               = 0;
						int iCols               = 0;
						unsigned short* pucData  = NULL;

						/////////////////////
						// 2D UINT16 Image //
						/////////////////////
						sciErr = getMatrixOfUnsignedInteger16(pvApiCtx, piAddr, &iRows, &iCols, &pucData);
						if (sciErr.iErr)
						{
							printError(&sciErr, 0);
							return sciErr.iErr;
						}
						int sz2[] = {iRows,iCols};

						new_img = Mat(2, sz2, CV_16U);
						scidata2matdata(new_img, pucData);
					}

				}
				break;

			case SCI_INT32:
				{
					if (isHypermatType(pvApiCtx, piAddr))
					{
						//sciErr = getHypermatOfInteger32(pvApiCtx, piAddr, &dims, &ndims, (int*)&data);
						//if(sciErr.iErr)
						//{
						//	printError(&sciErr, 0);
						//	return sciErr.iErr;
						//}
						sciprint("Precision : %i - SCI_INT32\n", precision);
						break;
					}
					else
					{
						int iRows               = 0;
						int iCols               = 0;
						int* pucData  = NULL;

						/////////////////////
						// 2D INT32 Image //
						/////////////////////
						sciErr = getMatrixOfInteger32(pvApiCtx, piAddr, &iRows, &iCols, &pucData);
						if (sciErr.iErr)
						{
							printError(&sciErr, 0);
							return sciErr.iErr;
						}
						int sz2[] = {iRows,iCols};

						new_img = Mat(2, sz2, CV_32S);
						scidata2matdata(new_img, pucData);
					}

				}
				break;
			case SCI_UINT32:
				//sciErr = getHypermatOfUnsignedInteger32(pvApiCtx, piAddr, &dims, &ndims, (unsigned int*)&data);
				//if(sciErr.iErr)
				//{
				//	printError(&sciErr, 0);
				//	return sciErr.iErr;
				//}
				sciprint("Precision : %i - SCI_UINT32\n", precision);
				break;
			}
		}

		break;

	case sci_pointer:
		sciprint("A pointer\n");
		break;
	default:
		sciprint("Unknown type !\n"); // Should never happen
	}


	/*sciprint("-----------------------\n");
	sciprint("Get Image Properties...\n");
	sciprint("-----------------------\n");
	sciprint("dims : %i\n",new_img.dims);
	sciprint("rows  : %i\n",new_img.rows );
	sciprint("cols  : %i\n",new_img.cols );
	sciprint("channels  : %i\n",new_img.channels() );
	sciprint("dims  : %i\t %i\t %i\t\n",*dims, *(dims+1), *(dims+2));
	sciprint("depth  : %i\n",new_img.depth());*/



	return 0;
}

int GetString(int nPos, char *&pstName,void* pvApiCtx)
{

	SciErr sciErr;
	int* piAddr = NULL;
	int iType   = 0;
	int iRet    = 0;

	sciErr = getVarAddressFromPosition(pvApiCtx, nPos, &piAddr);
	if(sciErr.iErr)
	{
		printError(&sciErr, 0);
		return -1;
	}

	if(isStringType(pvApiCtx, piAddr))
	{
		//sciprint("Is String Type\n");
		if(isScalar(pvApiCtx, piAddr))
		{
			char* pstData = NULL;
			//char* pstName = NULL;


			iRet = getAllocatedSingleString(pvApiCtx, piAddr, &pstData);
			//sciprint("Answer (Single String) : %s\n",  pstData);
			pstName = pstData;


			if(iRet)
			{
				freeAllocatedSingleString(pstData);
				return iRet;
			}


		}
		else
		{
			sciprint("Not Scalar Type\n");
			return -1;
		}

		//AssignOutputVariable(pvApiCtx, 1) = nbInputArgument(pvApiCtx) + 1;
	}
	else
	{
		sciprint("Not String Type\n");
		return -1;
		//AssignOutputVariable(pvApiCtx, 1) = 0;
	}
	return 0;
}

int SetString(int nPos, char *&pstName, void* pvApiCtx)
{

	SciErr sciErr;
	int* piAddr = NULL;
	int iType = 0;
	int iRet = 0;


//
	char* pstData = pstName;
	//char* pstName = NULL;
	
	iRet = createSingleString(pvApiCtx, nbInputArgument(pvApiCtx) + nPos, pstData);

	AssignOutputVariable(pvApiCtx, 1) = nbInputArgument(pvApiCtx) + 1;
	ReturnArguments(pvApiCtx);

	
	return 0;
}
//int GetString(int nPos, char *&pstName)
int GetDouble2(int nPos, double *&pstdata, int& iRows,int& iCols,void* pvApiCtx)
{

	SciErr sciErr;
	int* piAddr = NULL;
	int iType   = 0;
	int iRet    = 0;


	//CheckInputArgument(pvApiCtx, 1, 1);
	//CheckOutputArgument(pvApiCtx, 0, 1);

	sciErr = getVarAddressFromPosition(pvApiCtx, nPos, &piAddr);
	if(sciErr.iErr)
	{
		printError(&sciErr, 0);
		return 0;
	}

	if(isDoubleType(pvApiCtx, piAddr))
	{
		if(isScalar(pvApiCtx, piAddr))
		{
			double dblReal	= 1;
			iRows = 1;
			iCols = 1;
			iRet = getScalarDouble(pvApiCtx, piAddr, &dblReal);
			pstdata = &dblReal;

			if(iRet)
			{
				return iRet;
			}

			//sciprint("%f\n",*pstdata);
		}
		else
		{
			double* pdblReal	= NULL;
			sciErr = getMatrixOfDouble(pvApiCtx, piAddr, &iRows, &iCols, &pdblReal);
			pstdata = pdblReal;

			if(sciErr.iErr)
			{
				printError(&sciErr, 0);
				return sciErr.iErr;
			}


		}

	}
	else 
	{
		printError(&sciErr, 0);
		return -1;
	}

	ReturnArguments(pvApiCtx);
	return 0;
}

int GetDouble(int nPos, double *&pstdata, int& iRows,int& iCols,void* pvApiCtx)
{

	SciErr sciErr;
	int* piAddr = NULL;
	int iType   = 0;
	int iRet    = 0;


	sciErr = getVarAddressFromPosition(pvApiCtx, nPos, &piAddr);
	if(sciErr.iErr)
	{
		printError(&sciErr, 0);
		return 0;
	}

	if(isDoubleType(pvApiCtx, piAddr))
	{

		double* pdblReal	= NULL;
		sciErr = getMatrixOfDouble(pvApiCtx, piAddr, &iRows, &iCols, &pdblReal);
		pstdata = pdblReal;

		if(sciErr.iErr)
		{
			printError(&sciErr, 0);
			return sciErr.iErr;
		}


	}
	else 
	{
		printError(&sciErr, 0);
		return -1;
	}

	ReturnArguments(pvApiCtx);
	return 0;
}

int SetDouble(int nPos, double *&pstdata, int& iRows,int& iCols,void* pvApiCtx)
{
	//int iRows			= 0;
	//int iCols			= 0;
	double* pdblReal	= NULL;

	SciErr sciErr;
	pdblReal = pstdata;
	//sciErr = getMatrixOfDouble(pvApiCtx, piAddr, &iRows, &iCols, &pdblReal);
	sciErr = createMatrixOfDouble(pvApiCtx, nbInputArgument(pvApiCtx) + nPos, iRows, iCols, pdblReal);      
	AssignOutputVariable(pvApiCtx, nPos) = nbInputArgument(pvApiCtx) + nPos;	
	ReturnArguments(pvApiCtx);

	return 0;
}

// Function from : http://stackoverflow.com/questions/10167534/how-to-find-out-what-type-of-a-mat-object-is-with-mattype-in-opencv

string type2str(int type) {
	string r;

	uchar depth = type & CV_MAT_DEPTH_MASK;
	uchar chans = 1 + (type >> CV_CN_SHIFT);

	switch ( depth ) {
	case CV_8U:  r = "8U"; break;
	case CV_8S:  r = "8S"; break;
	case CV_16U: r = "16U"; break;
	case CV_16S: r = "16S"; break;
	case CV_32S: r = "32S"; break;
	case CV_32F: r = "32F"; break;
	case CV_64F: r = "64F"; break;
	default:     r = "User"; break;
	}

	r += "C";
	r += (chans+'0');

	return r;
}

//int SetImage(int nPos, Mat& new_img)

int is_binary_image( Mat& new_img) {
	int r;

	double s1 = sum(new_img==0)[0]/255;
	double s2 = sum(new_img==255)[0]/255;
	double s3 = new_img.rows*new_img.cols;
	if (s3 == (s1+s2))
		r = 1;
	else
		r = 0; 

	//new_img.convertTo(new_img2,CV_32S,1.0/255);

	return r;
}

int GetListImg(int _iRhs, int* _piParent, int *_piAddr, int _iItemPos, vector<Mat>& imgs, void* pvApiCtx)
{
	SciErr sciErr;
	int iRet    = 0;
	int iType   = 0;
	int* piAddr = NULL;


	sciErr = getVarAddressFromPosition(pvApiCtx, _iRhs, &piAddr);
	if(sciErr.iErr)
	{
		printError(&sciErr, 0);
		return 0;
	}
	
	iRet = get_info_imgvec(_iRhs, _piParent, piAddr, _iItemPos,imgs,pvApiCtx);

	//GetList(1, NULL, piAddr, 0, imgs, pvApiCtx);

	return 0;

}

int get_info_imgvec(int _iRhs, int* _piParent, int *_piAddr, int _iItemPos, vector<Mat>& imgs, void* pvApiCtx)
{
	SciErr sciErr;
	int iRet    = 0;
	int iType   = 0;

	sciErr = getVarType(pvApiCtx, _piAddr, &iType);
	switch(iType)
	{
	case sci_matrix :
		iRet = get_double_info_imgvec(_iRhs, _piParent, _piAddr, _iItemPos,imgs,pvApiCtx);
		break;
	case sci_poly :
		iRet = get_poly_info_imgvec(_iRhs, _piParent, _piAddr, _iItemPos,imgs,pvApiCtx);
		break;
	case sci_boolean :
		iRet = get_boolean_info_imgvec(_iRhs, _piParent, _piAddr, _iItemPos,imgs,pvApiCtx);
		break;
	case sci_sparse :
		iRet = get_sparse_info_imgvec(_iRhs, _piParent, _piAddr, _iItemPos,imgs,pvApiCtx);
		break;
	case sci_boolean_sparse :
		iRet = get_bsparse_info_imgvec(_iRhs, _piParent, _piAddr, _iItemPos,imgs,pvApiCtx);
		break;
	case sci_ints :
		iRet = get_integer_info_imgvec(_iRhs, _piParent, _piAddr, _iItemPos, imgs, pvApiCtx);
		break;
	case sci_strings :
		iRet = get_string_info_imgvec(_iRhs, _piParent, _piAddr, _iItemPos,imgs,pvApiCtx);
		break;
	case sci_list :
		insert_indent();
		sciprint("List ");
		iRet = get_list_info_imgvec(_iRhs, _piParent, _piAddr, _iItemPos,imgs,pvApiCtx);
		break;
	case sci_tlist :
		insert_indent();
		sciprint("TList ");
		iRet = get_list_info_imgvec(_iRhs, _piParent, _piAddr, _iItemPos,imgs,pvApiCtx);
		break;
	case sci_mlist :
		insert_indent();
		sciprint("MList ");
		iRet = get_list_info_imgvec(_iRhs, _piParent, _piAddr, _iItemPos,imgs,pvApiCtx);
		break;
	case sci_pointer :
		iRet = get_pointer_info_imgvec(_iRhs, _piParent, _piAddr, _iItemPos,imgs,pvApiCtx);
		break;
	default :
		insert_indent();
		sciprint("Unknown type\n");
		return 1;
	}
	return iRet;
}

int get_list_info_imgvec(int _iRhs, int* _piParent, int *_piAddr, int _iItemPos, vector<Mat>& imgs, void* pvApiCtx)
{
	SciErr sciErr;
	int i;
	int iRet        = 0;
	int iItem       = 0;
	int* piChild    = NULL;

	sciErr = getListItemNumber(pvApiCtx, _piAddr, &iItem);
	if(sciErr.iErr)
	{
		printError(&sciErr, 0);
		return 0;
	}

	sciprint("(%d)\n", iItem);
	for(i = 0 ; i < iItem ; i++)
	{
		sciErr = getListItemAddress(pvApiCtx, _piAddr, i + 1, &piChild);
		if(sciErr.iErr)
		{
			printError(&sciErr, 0);
			return 0;
		}

		iTab++;
		iRet = get_info_imgvec(_iRhs, _piAddr, piChild, i + 1,imgs, pvApiCtx);
		iTab--;
	}
	return 0;;
}

int get_double_info_imgvec(int _iRhs, int* _piParent, int *_piAddr, int _iItemPos,vector<Mat>& imgs,void* pvApiCtx)
{
	SciErr sciErr;
	int iRows           = 0;
	int iCols           = 0;
	double* pdblReal    = NULL;
	double* pdblImg     = NULL;

	if(_iItemPos == 0)
	{//not in list
		if(isVarComplex(pvApiCtx, _piAddr))
		{
			sciErr = getComplexMatrixOfDouble(pvApiCtx, _piAddr, &iRows, &iCols, &pdblReal, &pdblImg);
		}
		else
		{
			sciErr = getMatrixOfDouble(pvApiCtx, _piAddr, &iRows, &iCols, &pdblReal);
		}
	}
	else
	{
		if(isVarComplex(pvApiCtx, _piAddr))
		{
			sciErr = getComplexMatrixOfDoubleInList(pvApiCtx, _piParent, _iItemPos, &iRows, &iCols, &pdblReal, &pdblImg);
		}
		else
		{
			sciErr = getMatrixOfDoubleInList(pvApiCtx, _piParent, _iItemPos, &iRows, &iCols, &pdblReal);
		}
	}

	if(sciErr.iErr)
	{
		printError(&sciErr, 0);
		return 0;
	}

	insert_indent();
	sciprint("Double (%d x %d)\n", iRows, iCols);
	return 0;;
}

int get_poly_info_imgvec(int _iRhs, int* _piParent, int *_piAddr, int _iItemPos,vector<Mat>& imgs,void* pvApiCtx)
{
	SciErr sciErr;
	int i;
	int iLen            = 0;
	int iRows           = 0;
	int iCols           = 0;
	char pstVar[16];
	int* piCoeff        = NULL;
	double** pdblReal   = NULL;
	double** pdblImg    = NULL;

	sciErr = getPolyVariableName(pvApiCtx, _piAddr, pstVar, &iLen);
	if(sciErr.iErr)
	{
		printError(&sciErr, 0);
		return 0;
	}

	if(_iItemPos == 0)
	{//not in list
		sciErr = getMatrixOfPoly(pvApiCtx, _piAddr, &iRows, &iCols, NULL, NULL);
		if(sciErr.iErr)
		{
			printError(&sciErr, 0);
			return 0;
		}

		piCoeff     = (int*)malloc(sizeof(int) * iRows * iCols);
		sciErr = getMatrixOfPoly(pvApiCtx, _piAddr, &iRows, &iCols, piCoeff, NULL);
		if(sciErr.iErr)
		{
			printError(&sciErr, 0);
			return 0;
		}

		pdblReal    = (double**)malloc(sizeof(double*) * iRows * iCols);
		pdblImg     = (double**)malloc(sizeof(double*) * iRows * iCols);

		for(i = 0 ; i < iRows * iCols ; i++)
		{
			pdblReal[i] = (double*)malloc(sizeof(double) * piCoeff[i]);
			pdblImg[i]  = (double*)malloc(sizeof(double) * piCoeff[i]);
		}

		if(isVarComplex(pvApiCtx, _piAddr))
		{
			sciErr = getComplexMatrixOfPoly(pvApiCtx, _piAddr, &iRows, &iCols, piCoeff, pdblReal, pdblImg);
			if(sciErr.iErr)
			{
				printError(&sciErr, 0);
				return 0;
			}
		}
		else
		{
			sciErr = getMatrixOfPoly(pvApiCtx, _piAddr, &iRows, &iCols, piCoeff, pdblReal);
			if(sciErr.iErr)
			{
				printError(&sciErr, 0);
				return 0;
			}
		}
	}
	else
	{
		sciErr = getMatrixOfPolyInList(pvApiCtx, _piParent, _iItemPos, &iRows, &iCols, NULL, NULL);
		if(sciErr.iErr)
		{
			printError(&sciErr, 0);
			return 0;
		}

		piCoeff = (int*)malloc(sizeof(int) * iRows * iCols);

		sciErr = getMatrixOfPolyInList(pvApiCtx, _piParent, _iItemPos, &iRows, &iCols, piCoeff, NULL);
		if(sciErr.iErr)
		{
			printError(&sciErr, 0);
			return 0;
		}

		pdblReal    = (double**)malloc(sizeof(double*) * iRows * iCols);
		pdblImg     = (double**)malloc(sizeof(double*) * iRows * iCols);

		for(i = 0 ; i < iRows * iCols ; i++)
		{
			pdblReal[i] = (double*)malloc(sizeof(double) * piCoeff[i]);
			pdblImg[i]  = (double*)malloc(sizeof(double) * piCoeff[i]);
		}

		if(isVarComplex(pvApiCtx, _piAddr))
		{
			sciErr = getComplexMatrixOfPolyInList(pvApiCtx, _piParent, _iItemPos, &iRows, &iCols, piCoeff, pdblReal, pdblImg);
		}
		else
		{
			sciErr = getMatrixOfPolyInList(pvApiCtx, _piParent, _iItemPos, &iRows, &iCols, piCoeff, pdblReal);
		}
	}

	if(sciErr.iErr)
	{
		printError(&sciErr, 0);
		return 0;
	}

	insert_indent();
	sciprint("Poly  (%d x %d), varname : \'%s\'\n", iRows, iCols, pstVar);

	for(i = 0 ; i < iRows * iCols ; i++)
	{
		free(pdblReal[i]);
		free(pdblImg[i]);
	}

	free(pdblReal);
	free(pdblImg);
	free(piCoeff);
	return 0;;
}
int get_boolean_info_imgvec(int _iRhs, int* _piParent, int *_piAddr, int _iItemPos,vector<Mat>& imgs,void* pvApiCtx)
{
	SciErr sciErr;
	int iRows       = 0;
	int iCols       = 0;
	int* piBool     = NULL;

	if(_iItemPos == 0)
	{
		sciErr = getMatrixOfBoolean(pvApiCtx, _piAddr, &iRows, &iCols, &piBool);
	}
	else
	{
		sciErr = getMatrixOfBooleanInList(pvApiCtx, _piParent, _iItemPos, &iRows, &iCols, &piBool);
	}

	if(sciErr.iErr)
	{
		printError(&sciErr, 0);
		return 0;
	}

	insert_indent();
	sciprint("Boolean (%d x %d)\n", iRows, iCols);
	return 0;
}
int get_sparse_info_imgvec(int _iRhs, int* _piParent, int *_piAddr, int _iItemPos,vector<Mat>& imgs,void* pvApiCtx)
{
	SciErr sciErr;
	int iRows           = 0;
	int iCols           = 0;
	int iItem           = 0;
	int* piNbRow        = NULL;
	int* piColPos       = NULL;
	double* pdblReal    = NULL;
	double* pdblImg     = NULL;

	if(_iItemPos == 0)
	{//Not in list
		if(isVarComplex(pvApiCtx, _piAddr))
		{
			sciErr = getComplexSparseMatrix(pvApiCtx, _piAddr, &iRows, &iCols, &iItem, &piNbRow, &piColPos, &pdblReal, &pdblImg);
		}
		else
		{
			sciErr = getSparseMatrix(pvApiCtx, _piAddr, &iRows, &iCols, &iItem, &piNbRow, &piColPos, &pdblReal);
		}
	}
	else
	{
		if(isVarComplex(pvApiCtx, _piAddr))
		{
			sciErr = getComplexSparseMatrixInList(pvApiCtx, _piParent, _iItemPos, &iRows, &iCols, &iItem, &piNbRow, &piColPos, &pdblReal, &pdblImg);
		}
		else
		{
			sciErr = getSparseMatrixInList(pvApiCtx, _piParent, _iItemPos, &iRows, &iCols, &iItem, &piNbRow, &piColPos, &pdblReal);
		}
	}

	insert_indent();
	sciprint("Sparse (%d x %d), Item(s) : %d \n", iRows, iCols, iItem);
	return 0;;
}

int get_bsparse_info_imgvec(int _iRhs, int* _piParent, int *_piAddr, int _iItemPos,vector<Mat>& imgs,void* pvApiCtx)
{
	SciErr sciErr;
	int iRows       = 0;
	int iCols       = 0;
	int iItem       = 0;
	int* piNbRow    = NULL;
	int* piColPos   = NULL;

	if(_iItemPos == 0)
	{//Not in list
		sciErr = getBooleanSparseMatrix(pvApiCtx, _piAddr, &iRows, &iCols, &iItem, &piNbRow, &piColPos);
	}
	else
	{
		sciErr = getBooleanSparseMatrixInList(pvApiCtx, _piParent, _iItemPos, &iRows, &iCols, &iItem, &piNbRow, &piColPos);
	}

	if(sciErr.iErr)
	{
		printError(&sciErr, 0);
		return 0;
	}

	insert_indent();
	sciprint("Boolean Sparse (%d x %d), Item(s) : %d \n", iRows, iCols, iItem);
	return 0;;
}
int get_integer_info_imgvec(int _iRhs, int* _piParent, int *_piAddr, int _iItemPos, vector<Mat>& imgs, void* pvApiCtx)
{
	SciErr sciErr;
	int iPrec               = 0;
	int iRows               = 0;
	int iCols               = 0;
	char* pcData            = NULL;
	short* psData           = NULL;
	int* piData             = NULL;
	unsigned char* pucData  = NULL;
	unsigned short* pusData = NULL;
	unsigned int* puiData   = NULL;

	if(_iItemPos == 0)
	{//Not in list
		sciErr = getMatrixOfIntegerPrecision(pvApiCtx, _piAddr, &iPrec);
		if(sciErr.iErr)
		{
			printError(&sciErr, 0);
			return 0;
		}

		switch(iPrec)
		{
		case SCI_INT8 :
			sciErr = getMatrixOfInteger8(pvApiCtx, _piAddr, &iRows, &iCols, &pcData);
			break;
		case SCI_INT16 :
			sciErr = getMatrixOfInteger16(pvApiCtx, _piAddr, &iRows, &iCols, &psData);
			break;
		case SCI_INT32 :
			sciErr = getMatrixOfInteger32(pvApiCtx, _piAddr, &iRows, &iCols, &piData);
			break;
		case SCI_UINT8 :
			sciErr = getMatrixOfUnsignedInteger8(pvApiCtx, _piAddr, &iRows, &iCols, &pucData);
			break;
		case SCI_UINT16 :
			sciErr = getMatrixOfUnsignedInteger16(pvApiCtx, _piAddr, &iRows, &iCols, &pusData);
			break;
		case SCI_UINT32 :
			sciErr = getMatrixOfUnsignedInteger32(pvApiCtx, _piAddr, &iRows, &iCols, &puiData);
			break;
		default :
			return 1;
		}
	}
	else
	{
		sciErr = getMatrixOfIntegerPrecision(pvApiCtx, _piAddr, &iPrec);
		if(sciErr.iErr)
		{
			printError(&sciErr, 0);
			return 0;
		}

		switch(iPrec)
		{
		case SCI_INT8 :
			sciErr = getMatrixOfInteger8InList(pvApiCtx, _piParent, _iItemPos, &iRows, &iCols, &pcData);
			break;
		case SCI_INT16 :
			sciErr = getMatrixOfInteger16InList(pvApiCtx, _piParent, _iItemPos, &iRows, &iCols, &psData);
			break;
		case SCI_INT32 :
			sciErr = getMatrixOfInteger32InList(pvApiCtx, _piParent, _iItemPos, &iRows, &iCols, &piData);
			break;
		case SCI_UINT8 :
			{sciErr = getMatrixOfUnsignedInteger8InList(pvApiCtx, _piParent, _iItemPos, &iRows, &iCols, &pucData);
			///////////////
			int sz2[] = {iRows,iCols,3};
			//new_img = Mat(2, sz2, CV_8U);
			//scidata2matdata(new_img, pucData);

			//int sz2[] = {*dims, *(dims+1), *(dims+2)};
			Mat new_img = Mat(2, sz2, CV_8UC3);
			scidata2matdata(new_img, pucData);
			//imshow("aaa",new_img);
			imgs.push_back(new_img);
			//SetImage(1,new_img,pvApiCtx);
			/////////////////
			break;}
		case SCI_UINT16 :
			sciErr = getMatrixOfUnsignedInteger16InList(pvApiCtx, _piParent, _iItemPos, &iRows, &iCols, &pusData);
			break;
		case SCI_UINT32 :
			sciErr = getMatrixOfUnsignedInteger32InList(pvApiCtx, _piParent, _iItemPos, &iRows, &iCols, &puiData);
			break;
		default :
			return 1;
		}
	}

	if(sciErr.iErr)
	{
		printError(&sciErr, 0);
		return 0;
	}

	insert_indent();

	if(iPrec > 10)
	{
		sciprint("Unsigned ");
	}

	sciprint("Integer %d bits (%d x %d)\n", (iPrec % 10) * 8, iRows, iCols);
	return 0;;
}
int get_string_info_imgvec(int _iRhs, int* _piParent, int *_piAddr, int _iItemPos,vector<Mat>& imgs,void* pvApiCtx)
{
	SciErr sciErr;
	int i;
	int iRows       = 0;
	int iCols       = 0;
	int* piLen      = NULL;
	char **pstData  = NULL;

	if(_iItemPos == 0)
	{//Not in list
		sciErr = getMatrixOfString(pvApiCtx, _piAddr, &iRows, &iCols, NULL, NULL);
		if(sciErr.iErr)
		{
			printError(&sciErr, 0);
			return 0;
		}

		piLen = (int*)malloc(sizeof(int) * iRows * iCols);
		sciErr = getMatrixOfString(pvApiCtx, _piAddr, &iRows, &iCols, piLen, NULL);
		if(sciErr.iErr)
		{
			printError(&sciErr, 0);
			return 0;
		}

		pstData = (char**)malloc(sizeof(char*) * iRows * iCols);

		for(i = 0 ; i < iRows * iCols ; i++)
		{
			pstData[i] = (char*)malloc(sizeof(char) * (piLen[i] + 1));//+ 1 for null termination
		}

		sciErr = getMatrixOfString(pvApiCtx, _piAddr, &iRows, &iCols, piLen, pstData);
		if(sciErr.iErr)
		{
			printError(&sciErr, 0);
			return 0;
		}
	}
	else
	{
		sciErr = getMatrixOfStringInList(pvApiCtx, _piParent, _iItemPos, &iRows, &iCols, NULL, NULL);
		if(sciErr.iErr)
		{
			printError(&sciErr, 0);
			return 0;
		}

		piLen = (int*)malloc(sizeof(int) * iRows * iCols);

		sciErr = getMatrixOfStringInList(pvApiCtx, _piParent, _iItemPos, &iRows, &iCols, piLen, NULL);
		if(sciErr.iErr)
		{
			printError(&sciErr, 0);
			return 0;
		}

		pstData = (char**)malloc(sizeof(char*) * iRows * iCols);

		for(i = 0 ; i < iRows * iCols ; i++)
		{
			pstData[i] = (char*)malloc(sizeof(char) * (piLen[i] + 1));//+ 1 for null termination
		}

		sciErr = getMatrixOfStringInList(pvApiCtx, _piParent, _iItemPos, &iRows, &iCols, piLen, pstData);
		if(sciErr.iErr)
		{
			printError(&sciErr, 0);
			return 0;
		}
	}
	if(sciErr.iErr)
	{
		printError(&sciErr, 0);
		return 0;
	}

	insert_indent();
	sciprint("Strings (%d x %d)\n", iRows, iCols);
	return 0;;
}
int get_pointer_info_imgvec(int _iRhs, int* _piParent, int *_piAddr, int _iItemPos,vector<Mat>& imgs,void* pvApiCtx)
{
	SciErr sciErr;
	void* pvPtr     = NULL;

	if(_iItemPos == 0)
	{
		sciErr = getPointer(pvApiCtx, _piAddr, &pvPtr);
	}
	else
	{
		sciErr = getPointerInList(pvApiCtx, _piParent, _iItemPos, &pvPtr);
	}

	if(sciErr.iErr)
	{
		printError(&sciErr, 0);
		return 0;
	}

	insert_indent();
	sciprint("Pointer : 0x%08X\n", pvPtr);
	return 0;
}

