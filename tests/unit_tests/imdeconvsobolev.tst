//==============================================================================
// Allan CORNET - 2012 - DIGITEO
//
// IPCV - Scilab Image Processing and Computer Vision toolbox
// Copyright (C) 2017  Tan Chin Luh
//==============================================================================
// unit test imdeconvsobolev
//==============================================================================
S = imread(fullpath(getIPCVpath() + "/images/balloons_gray.png"));
S = im2double(S);
h = fspecial('motion',25,45);
S2 = imfilter(S,h,'circular');
imshow(S2);
S3 = imdeconvsobolev(S2,h,0);
figure;imshow(S3);
//==============================================================================
