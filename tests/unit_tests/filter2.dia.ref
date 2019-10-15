//==============================================================================
// Allan CORNET - 2012 - DIGITEO
//
// IPCV - Scilab Image Processing and Computer Vision toolbox
// Copyright (C) 2017  Tan Chin Luh
//==============================================================================
// unit test filter2
//==============================================================================
im = imread(fullpath(getIPCVpath() + "/images/baboon.png"));
filter = fspecial('sobel');
imf = filter2(im,filter);
assert_checkequal(type(imf),1);
//==============================================================================
