//==============================================================================
// Allan CORNET - 2012 - DIGITEO
//
// IPCV - Scilab Image Processing and Computer Vision toolbox
// Copyright (C) 2017  Tan Chin Luh
//==============================================================================
// unit test imroifilt
//==============================================================================

S = imread(fullpath(getIPCVpath() + "/images/coins_gray.jpg"));
mask = zeros(S);
mask(1:80,70:145) = 1;
h = fspecial('average',15);
S2 = imroifilt(S,h,mask);
imshow(S2);

//==============================================================================
