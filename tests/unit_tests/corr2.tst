//==============================================================================
// Allan CORNET - 2012 - DIGITEO
//
// IPCV - Scilab Image Processing and Computer Vision toolbox
// Copyright (C) 2017  Tan Chin Luh
//==============================================================================
// unit test imcorr2
//==============================================================================

y = imcorr2(uint8(rand(5,5).*100),uint8(rand(5,5).*100));
assert_checkequal(size(y), [1 1]);
y = imcorr2(rand(5,5),rand(5,5));
assert_checkequal(size(y), [1 1]);

//==============================================================================
