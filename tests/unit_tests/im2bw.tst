//==============================================================================
// Allan CORNET - 2012 - DIGITEO
//
// IPCV - Scilab Image Processing and Computer Vision toolbox
// Copyright (C) 2017  Tan Chin Luh
//==============================================================================
// unit test im2bw
//==============================================================================

S = imread(fullpath(getIPCVpath() + "/images/balloons.png"));
S2 = rgb2gray(S);
Sbin = im2bw(S2,0.5);
assert_checkequal(type(Sbin),4);

//==============================================================================
