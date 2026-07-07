//==============================================================================
// Allan CORNET - 2012 - DIGITEO
//
// IPCV - Scilab Image Processing and Computer Vision toolbox
// Copyright (C) 2017  Tan Chin Luh
//==============================================================================
// unit test imhough
//==============================================================================

S = imread(fullpath(getIPCVpath() + "/images/2lines.png"));
[HM, rho, th] = imhough(S);
assert_checkequal(sum(HM>30),2);
//==============================================================================
