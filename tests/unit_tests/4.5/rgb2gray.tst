//==============================================================================
// Allan CORNET - 2012 - DIGITEO
//
// IPCV - Scilab Image Processing and Computer Vision toolbox
// Copyright (C) 2017  Tan Chin Luh
//==============================================================================
// unit test rgb2gray
//==============================================================================

RGB = imread(fullpath(getIPCVpath() + "/images/baboon.png"));
G = rgb2gray(RGB);
assert_checkequal(size(G),[512 512]);

//==============================================================================
