/***********************************************************************
 * IPCV - Scilab Image Processing and Computer Vision toolbox
 * Copyright (C) 2017  Tan Chin Luh
***********************************************************************/

#include "common.h"
static void radon(double *pPtr, double *iPtr, double *thetaPtr, int M, int N,int xOrigin, int yOrigin, int numAngles, int rFirst,int rSize);
#define MAXX(x,y) ((x) > (y) ? (x) : (y))   


int sci_int_imradon(char * fname,void* pvApiCtx)
{
	SciErr sciErr;
	CheckInputArgument(pvApiCtx, 2, 2);
	CheckOutputArgument(pvApiCtx, 2, 2);
	double *pr1, *pr2;      /* double pointers used in loop */   
	int iRows1           = 0;
	int iCols1           = 0;
	int iRows2           = 0;
	int iCols2           = 0;
	double* pdbTheta	= NULL;
	double* pdbImage    = NULL;
	int* piAddr1 = NULL;
	int* piAddr2 = NULL;
	double deg2rad; 
	int numAngles		 = 0; 
	double* thetaPtr = NULL; 
	
	int k;  
	int M, N; 
	int xOrigin, yOrigin; 
	int temp1, temp2;
	int rFirst, rLast;
	int rSize;
	double* P = NULL;
	double* P2 = NULL;
	double* PP = NULL;

	sciErr = getVarAddressFromPosition(pvApiCtx, 1, &piAddr1);
	sciErr = getMatrixOfDouble(pvApiCtx, piAddr1, &iRows1, &iCols1, &pdbImage);
	if(sciErr.iErr)
	{
		printError(&sciErr, 0);
		return sciErr.iErr;
	}

	//sciprint("Double (%d x %d)\n", iRows1, iCols1);


	sciErr = getVarAddressFromPosition(pvApiCtx, 2, &piAddr2);
	sciErr = getMatrixOfDouble(pvApiCtx, piAddr2, &iRows2, &iCols2, &pdbTheta);
	if(sciErr.iErr)
	{
		printError(&sciErr, 0);
		return sciErr.iErr;
	}

	//sciprint("Double (%d x %d)\n", iRows2, iCols2);

	deg2rad = 3.14159265358979 / 180.0;
	numAngles = iRows2 * iCols2;
	//sciprint("2 values (%f , %i, %d)\n", deg2rad, numAngles, numAngles);
	thetaPtr = (double *) calloc(numAngles, sizeof(double));
	pr1 =  pdbTheta;
	pr2 = thetaPtr;
	for (k = 0; k < numAngles; k++)
	{*(pr2++) = *(pr1++) * deg2rad;
	//sciprint("thetaPtr : %g\n", *(pr2-1));
	}
		//thetaPtr[k] = pdbTheta[k] * deg2rad;

	//sciprint("thetaPtr(0), thetaPtr(1), thetaPtr(2) (%g, %g, %g)\n", *(thetaPtr), *(thetaPtr+1),*(thetaPtr+2));

	M = iRows1;
	N = iCols1;
	xOrigin = MAXX(0, (N-1)/2);
	yOrigin = MAXX(0, (M-1)/2);
	temp1 = M - 1 - yOrigin;
	temp2 = N - 1 - xOrigin;
	//sciprint("x,y,t1,t2 (%d , %d, %d, %d)\n", xOrigin, yOrigin,temp1,temp2);
	rLast = (int) ceil(sqrt((double) (temp1*temp1+temp2*temp2))) + 1;
	rFirst = -rLast;
	rSize = rLast - rFirst + 1;
	//sciprint("first, last, size (%d, %d, %d)\n", rFirst, rLast,rSize);

	P = (double*)calloc( rSize * numAngles,sizeof(double));
	//P2 = P;
	//PP = pdbImage;
	radon(P, pdbImage, thetaPtr, M, N, xOrigin, yOrigin,numAngles, rFirst, rSize);
	
	sciErr = createMatrixOfDouble(pvApiCtx, nbInputArgument(pvApiCtx) + 1, rSize, numAngles,P);
	if(sciErr.iErr)
	{
		printError(&sciErr, 0);
		return sciErr.iErr;
	}
	

	pr1 = (double*)calloc(rSize,sizeof(double));
	for (k = rFirst; k <= rLast; k++)
		pr1[k-rFirst] = (double) k;

	sciErr = createMatrixOfDouble(pvApiCtx, nbInputArgument(pvApiCtx) + 2, 1,rSize,pr1);
	if(sciErr.iErr)
	{
		printError(&sciErr, 0);
		return sciErr.iErr;
	}
	

	AssignOutputVariable(pvApiCtx, 1) = nbInputArgument(pvApiCtx) + 1;
	AssignOutputVariable(pvApiCtx, 2) = nbInputArgument(pvApiCtx) + 2;

	free(thetaPtr);
	free(P);
	free(pr1);

	return 0;


}

void incrementRadon(double *pr, double pixel, double r)   
{   
    int r1;   
    double delta;   
   
    r1 = (int) r;   
    delta = r - r1;   
    pr[r1] += pixel * (1.0 - delta);   
    pr[r1+1] += pixel * delta;   
}   

// static void radon(double *pPtr, double *iPtr, double *thetaPtr, int M, int N,int xOrigin, int yOrigin, int numAngles, int rFirst, int rSize)
static void radon(double *pPtr, double *iPtr, double *thetaPtr, int M, int N,int xOrigin, int yOrigin, int numAngles, int rFirst, int rSize)   
{   
    int k2 = 0;
	int m = 0;
	int n = 0;              /* loop counters */   
    double angle = 0;             /* radian angle value */   
    double cosine = 0;
	double sine = 0;      /* cosine and sine of current angle */   
    double *pr = NULL;               /* points inside output array */   
    double *pixelPtr;         /* points inside input array */   
    double pixel;             /* current pixel value */   
    double *ySinTable = NULL;
	double *xCosTable = NULL;   
    /* tables for x*cos(angle) and y*sin(angle) */   
    double x = 0;
	double y = 0;
    double r = 0; 
	double delta = 0;
    int r1 = 0;   
   
    /* Allocate space for the lookup tables */   
    xCosTable = (double *) calloc(2*N , sizeof(double));   
    ySinTable = (double *) calloc(2*M , sizeof(double));   
   
	for (k2 = 0; k2 < numAngles; k2++) 
	{
        angle = thetaPtr[k2];   
		//sciprint("k,rsize,angle  ...: %d %d %g\n",k2,numAngles,angle);
        pr = pPtr + k2*rSize;  /* pointer to the top of the output column */   
		//sciprint("pr  ...: %g \t %g\t %g\t %g\t %g\t %g\n",*pr,pr,&pr,*pPtr,pPtr,&pPtr);
        cosine = cos(angle);    
        sine = sin(angle);      
		
        /* Radon impulse response locus:  R = X*cos(angle) + Y*sin(angle) */   
        /* Fill the X*cos table and the Y*sin table.                      */   
        /* x- and y-coordinates are offset from pixel locations by 0.25 */   
        /* spaced by intervals of 0.5. */   
        for (n = 0; n < N; n++)   
        {   
            x = n - xOrigin;   
            xCosTable[2*n]   = (x - 0.25)*cosine;   
            xCosTable[2*n+1] = (x + 0.25)*cosine;   
        }   
        for (m = 0; m < M; m++)   
        {   
            y = yOrigin - m;   
            ySinTable[2*m] = (y - 0.25)*sine;   
            ySinTable[2*m+1] = (y + 0.25)*sine;   
        }   
   
        pixelPtr = iPtr;   
        for (n = 0; n < N; n++)   
        {   
            for (m = 0; m < M; m++)   
            {   
                pixel = *(pixelPtr++);   
                if (pixel != 0.0)   
                {   
                    pixel *= 0.25;   
   
                    r = xCosTable[2*n] + ySinTable[2*m] - rFirst;   
                    incrementRadon(pr, pixel, r);   
   
                    r = xCosTable[2*n+1] + ySinTable[2*m] - rFirst;   
                    incrementRadon(pr, pixel, r);   
   
                    r = xCosTable[2*n] + ySinTable[2*m+1] - rFirst;   
                    incrementRadon(pr, pixel, r);   
   
                   r = xCosTable[2*n+1] + ySinTable[2*m+1] - rFirst;   
                    incrementRadon(pr, pixel, r);   
                }   
            }   
        }   
    }   
                   
    free(xCosTable);   
    free(ySinTable);   
}   

//// Radon Transform, converted from IPT 2 
//static void radon(double *pPtr, double *iPtr, double *thetaPtr, int M, int N,int xOrigin, int yOrigin, int numAngles, int rFirst, int rSize)
//{
//	int k, m, n, p;
//	double angle; 
//	double cosine, sine;
//	double *pr = NULL; 
//	double *pixelPtr = NULL; 
//	double pixel; 
//	double rIdx; 
//	int rLow; 
//	double pixelLow; 
//	double *yTable = NULL;
//	double *xTable = NULL; 
//	double *ySinTable = NULL;
//	double *xCosTable = NULL;
//
//	yTable = (double *) malloc(sizeof(double) * 2 * M);
//	xTable = (double *) malloc(sizeof(double) * 2 * N);
//	xCosTable = (double *) malloc(sizeof(double) * 2 * N);
//	ySinTable = (double *) malloc(sizeof(double) * 2 * M);
//	
//	yTable[2*M-1] = -yOrigin - 0.25; 
//	for (k = 2*M-2; k >=0; k--)  
//		yTable[k] = yTable[k+1] + 0.5;
//	
//	xTable[0] = -xOrigin - 0.25;
//	for (k = 1; k < 2*N; k++) 
//		xTable[k] = xTable[k-1] + 0.5;
//	
//	for (k = 0; k < numAngles; k++)
//	{
//		angle = thetaPtr[k];
//		pr = pPtr + k*rSize;
//		cosine = cos(angle);
//		sine = sin(angle);
//		for (p = 0; p < 2*N; p++)
//			xCosTable[p] = xTable[p] * cosine - rFirst;
//		for (p = 0; p < 2*M; p++)
//			ySinTable[p] = yTable[p] * sine; 
//		for (n = 0; n < 2*N; n++)
//		{
//			pixelPtr = iPtr + (n/2)*M;
//			for (m = 0; m < 2*M; m++)
//			{
//				pixel = *pixelPtr;
//				if (pixel)
//				{
//					pixel *= 0.25; 
//					rIdx = (xCosTable[n] + ySinTable[m]);
//					rLow = (int) rIdx;
//					pixelLow = pixel*(1 - rIdx + rLow); 
//					pr[rLow++] += pixelLow; 
//					pr[rLow] += pixel - pixelLow; 
//				}
//				if (m%2)
//					pixelPtr++;
//			}
//		}
//	}
//	free(yTable);
//	free(xTable);
//	free(xCosTable);
//	free(ySinTable);
//
//}
