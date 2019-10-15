//==============================================================================
// Allan CORNET - 2012 - DIGITEO
//
// IPCV - Scilab Image Processing and Computer Vision toolbox
// Copyright (C) 2017  Tan Chin Luh
//==============================================================================
// unit test imcrop
//==============================================================================

im = imread(fullpath(getIPCVpath() + "/images/baboon.png"));
subim = imcrop(im, [20, 30, 200, 300]);
assert_checkequal(size(subim),[300 200 3]);

//==============================================================================
