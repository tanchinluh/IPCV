//==============================================================================
// Allan CORNET - 2012 - DIGITEO
//
// IPCV - Scilab Image Processing and Computer Vision toolbox
// Copyright (C) 2017  Tan Chin Luh
//==============================================================================
// unit test edge
//==============================================================================

im = imread(fullpath(getIPCVpath() + "/images/baboon.png"));
im = rgb2gray(im);
E = edge(im, 'sobel');
imshow(E);
E = edge(im, 'canny', [0.06, 0.2]);
imshow(E);
E = edge(im, 'prewitt');
imshow(mat2gray(E));

//==============================================================================
