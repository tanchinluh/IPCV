/***********************************************************************
*  Copyright (C) Trity Technologies - 2012 -
* http://www.gnu.org/licenses/gpl-2.0.txt
***********************************************************************/

#include "common.h"

/**********************************************************************
* This function is using the OpenCV highgui function for plotting image
* imdisplay(imin);
**********************************************************************/
int sci_iminspect(char * fname,void* pvApiCtx)
{

	CheckInputArgument(pvApiCtx, 1, 2);
	CheckOutputArgument(pvApiCtx, 0, 1);

	/////////////////
	// First Input //
	/////////////////
	Mat pSrcImg;
	GetImage(1,pSrcImg,pvApiCtx);

	
	char *pstName = NULL;

	if(nbInputArgument(pvApiCtx) == 2)
	{
		GetString(2, pstName,pvApiCtx);
	}
	else
	{
		pstName = "Inspect Window";		
	}
	 
	for(;;)
	{

	namedWindow(pstName, WINDOW_NORMAL | WINDOW_KEEPRATIO | WINDOW_GUI_EXPANDED);// Create a window for display.
	imshow(pstName, pSrcImg );   
	// Show our image inside it.

	if(waitKey(30) >= 0) break;

	}
	
	destroyWindow(pstName);

	return 0;


}
