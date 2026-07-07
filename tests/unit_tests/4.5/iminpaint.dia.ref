//==============================================================================
// Allan CORNET - 2012 - DIGITEO
//
// IPCV - Scilab Image Processing and Computer Vision toolbox
// Copyright (C) 2017  Tan Chin Luh
//==============================================================================
// unit test iminpaint
//==============================================================================
S = imread(fullpath(getIPCVpath() + "/images/coins_gray.jpg"));
mask = zeros(S);
mask(1:80,70:145) = 1;
imout = iminpaint(S,im2uint8(mask),1,1);
imshow(S);
figure(); imshow(imout);
//==============================================================================
