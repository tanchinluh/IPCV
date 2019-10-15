//==============================================================================
// Allan CORNET - 2012 - DIGITEO
//
// IPCV - Scilab Image Processing and Computer Vision toolbox
// Copyright (C) 2017  Tan Chin Luh
//==============================================================================
// unit test imadjust
//==============================================================================
I = imread(fullpath(getIPCVpath() + "/images/balloons_gray.png"));
J = imadjust(I,[0 0.5],[0.5 1]);
assert_checktrue(sum(im2double(J-I))./prod(size(J))>0.3);
//==============================================================================
