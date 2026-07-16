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
assert_checkequal(typeof(S3), typeof(S2));
assert_checkequal(size(S3), size(S2));
imshow(S3);

S4 = imwiener2(im2double(S2), [3 3], 0.01);
assert_checkequal(typeof(S4), "constant");
assert_checktrue(min(S4) >= 0);
assert_checktrue(max(S4) <= 1);
//==============================================================================
