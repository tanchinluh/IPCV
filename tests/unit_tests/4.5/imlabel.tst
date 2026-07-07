//==============================================================================
// Allan CORNET - 2012 - DIGITEO
//
// IPCV - Scilab Image Processing and Computer Vision toolbox
// Copyright (C) 2017  Tan Chin Luh
//==============================================================================
// unit test imlabel
//==============================================================================

A = imread(fullpath(getIPCVpath() + "/images/coins_gray.jpg"));
A_edge = edge(A,'canny');
se = imcreatese('ellipse',15,15);
A_dilate = imdilate(A_edge,se);
[A_labeled,n] = imlabel(A_dilate);
assert_checkequal(n,4);

//==============================================================================
