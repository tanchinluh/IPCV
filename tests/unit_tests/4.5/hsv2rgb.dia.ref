//==============================================================================
// Allan CORNET - 2012 - DIGITEO
//
// IPCV - Scilab Image Processing and Computer Vision toolbox
// Copyright (C) 2017  Tan Chin Luh
//==============================================================================
// unit test hsv2rgb
//==============================================================================

RGB = imread(fullpath(getIPCVpath() + "/images/baboon.png"));
HSV = rgb2hsv(RGB);
RGB2 = hsv2rgb2(HSV);
assert_checktrue(sum(im2double(RGB) - im2double(RGB2))./prod(size(RGB))<0.01);

//==============================================================================
