//==============================================================================
// Allan CORNET - 2012 - DIGITEO
//
// IPCV - Scilab Image Processing and Computer Vision toolbox
// Copyright (C) 2017  Tan Chin Luh
//==============================================================================
// unit test imidct
//==============================================================================

S = imread(fullpath(getIPCVpath() + "/images/measure_gray.jpg"));
y = imdct(S);
S2 = imidct(y);
assert_checktrue(sum(double(S)-S2)<0.001);
//==============================================================================
