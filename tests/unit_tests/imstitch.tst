//==============================================================================
// IPCV - Scilab Image Processing and Computer Vision toolbox
// Copyright (C) 2017  Tan Chin Luh
//==============================================================================
// unit test imsuperres
// <-- NO CHECK REF -->
//==============================================================================

S = list();
S(1) = imread(fullpath(getIPCVpath() + "/images/stitching/sk1.jpg"));
S(2) = imread(fullpath(getIPCVpath() + "/images/stitching/sk2.jpg"));
St  = imstitchimage(S);
stSize = size(St);
assert_checkequal(stSize(1), 592);
assert_checktrue(stSize(2) >= 1090);
assert_checktrue(stSize(2) <= 1100);
assert_checkequal(stSize(3), 3);

//==============================================================================
