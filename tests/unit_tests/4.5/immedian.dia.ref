//==============================================================================
// Allan CORNET - 2012 - DIGITEO
//
// IPCV - Scilab Image Processing and Computer Vision toolbox
// Copyright (C) 2017  Tan Chin Luh
//==============================================================================
// unit test immedian
//==============================================================================
S = imread(fullpath(getIPCVpath() + "/images/coins_gray.jpg"));
S_noise =  imnoise(S,'salt & pepper',0.02);
imshow(S_noise);
S2 = immedian(S_noise,3);
figure; imshow(S2);
//==============================================================================
