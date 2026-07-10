//==============================================================================
// Allan CORNET - 2012 - DIGITEO
//
// IPCV - Scilab Image Processing and Computer Vision toolbox
// Copyright (C) 2017  Tan Chin Luh
//==============================================================================
// unit test imedge
// <-- NO CHECK REF -->
//==============================================================================

im = imread(fullpath(getIPCVpath() + "/images/baboon.png"));
im = rgb2gray(im);
E = imedge(im, 'sobel');
imshow(E);
E = imedge(im, 'canny', [0.06, 0.2]);
imshow(E);
E = imedge(im, 'prewitt');
imshow(immat2gray(E));

//==============================================================================
