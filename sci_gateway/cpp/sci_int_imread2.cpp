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


extern "C" 
{
#include "sci_malloc.h"
#include <sciprint.h>
#include <ctype.h>
#include "api_scilab.h"
#include "Scierror.h"
#include "localization.h"
#include "sciprint.h"
#include "sci_malloc.h"
#include "os_string.h"

int sci_int_imread2(scilabEnv env, int nin, scilabVar* in, int nopt, scilabOpt opt, int nout, scilabVar* out);
}

const char fname[] = "int_imread2";

int sci_int_imread2(scilabEnv env, int nin, scilabVar* in, int nopt, scilabOpt opt, int nout, scilabVar* out)
{
	sciprint("1 \n ");
	//char *pstName = NULL;
	wchar_t* in2 = 0;
	//char *in2 = NULL;
	//Mat pImage;
	sciprint("2 \n ");
	//CheckInputArgument(pvApiCtx, 1, 1);
	//CheckOutputArgument(pvApiCtx, 1, 1);

	//GetString(1, pstName,pvApiCtx);
	//if (scilab_isString(env, in[0]) == 0 || scilab_isScalar(env, in[0]) == 0)
	//{
	//	Scierror(999, _("%s: Wrong type for input argument #%d: A double expected.\n"), fname, 2);
	//	return STATUS_ERROR;
	//}
	sciprint("3 \n ");
	scilab_getString(env, in[0], &in2);
	sciprint("4 \n ");
	sciprint("fn : %s \n : ",*in2);
	sciprint("5 \n ");

	//pImage = imread(pstName,CV_LOAD_IMAGE_ANYDEPTH|CV_LOAD_IMAGE_ANYCOLOR);

	/* if load image failed */
	//if(!pImage.data)
	//{
	//	Scierror(999, "%s: Can not open file %s.\r\n", fname, pstName);
	//	return -1;
	//}


	//SetImage(1,pImage,pvApiCtx);




	return 0;
}

