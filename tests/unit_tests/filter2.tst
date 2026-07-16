//==============================================================================
// Allan CORNET - 2012 - DIGITEO
//
// IPCV - Scilab Image Processing and Computer Vision toolbox
// Copyright (C) 2017  Tan Chin Luh
//==============================================================================
// unit test imfilter2
//==============================================================================
im = imread(fullpath(getIPCVpath() + "/images/baboon.png"));
filter = imfspecial('sobel');
imf = imfilter2(im,filter);
assert_checkequal(type(imf),1);
//==============================================================================
