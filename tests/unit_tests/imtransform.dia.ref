//==============================================================================
// Allan CORNET - 2012 - DIGITEO
//
// IPCV - Scilab Image Processing and Computer Vision toolbox
// Copyright (C) 2017  Tan Chin Luh
//==============================================================================
// unit test imtransform
//==============================================================================

S = imread(fullpath(getIPCVpath() + "/images/measure_gray.jpg"));
src = [261 412; 170 348; 213 282];
tgt = [175 412; 170 308; 251 308];
mat = imgettransform(src,tgt,'affine');
S2 = imtransform(S,mat,'affine');
imshow(S);
figure();imshow(S2);

//==============================================================================
