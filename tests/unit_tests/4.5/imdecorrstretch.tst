//==============================================================================
// Allan CORNET - 2012 - DIGITEO
//
// IPCV - Scilab Image Processing and Computer Vision toolbox
// Copyright (C) 2017  Tan Chin Luh
//==============================================================================
// unit test imdecorrstretch
//==============================================================================
S = imread(fullpath(getIPCVpath() + "/images/" + 'baboon.png'));
S2 = imdecorrstretch(S);
subplot(121);imshow(S);
subplot(122);imshow(S2);
//==============================================================================
