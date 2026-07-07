//==============================================================================
// Allan CORNET - 2012 - DIGITEO
//
// IPCV - Scilab Image Processing and Computer Vision toolbox
// Copyright (C) 2017  Tan Chin Luh
//==============================================================================
// unit test imfilter
//==============================================================================
im = imread(fullpath(getIPCVpath() + "/images/baboon.png"));
filter = fspecial('sobel');
imf = imfilter(im, filter);
imshow(imf);
//==============================================================================
