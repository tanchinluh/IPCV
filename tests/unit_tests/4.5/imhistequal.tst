//==============================================================================
// Allan CORNET - 2012 - DIGITEO
//
// IPCV - Scilab Image Processing and Computer Vision toolbox
// Copyright (C) 2017  Tan Chin Luh
//==============================================================================
// unit test imhistequal
//==============================================================================
S = imread(fullpath(getIPCVpath() + "/images/Lena_dark.png"));
J = imhistequal(S);
imshow(S);
figure(); imshow(J);
//==============================================================================
