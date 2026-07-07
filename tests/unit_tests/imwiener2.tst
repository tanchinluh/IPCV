//==============================================================================
// Allan CORNET - 2012 - DIGITEO
//
// IPCV - Scilab Image Processing and Computer Vision toolbox
// Copyright (C) 2017  Tan Chin Luh
//==============================================================================
// unit test imwiener2
//==============================================================================
S = imread(fullpath(getIPCVpath() + "/images/measure_gray.jpg"));
S2 = imnoise(S,'gaussian');
imshow(S2);
S3 = imwiener2(S2,[3 3],0.2);
imshow(S3);
//==============================================================================
