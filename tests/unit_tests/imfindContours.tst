//==============================================================================
// IPCV - Scilab Image Processing and Computer Vision toolbox
// Copyright (C) 2017  Tan Chin Luh
//==============================================================================
// unit test imfindContours
//==============================================================================

S = imread(fullpath(getIPCVpath() + "/images/coins_gray.jpg"));
Sbw = im2bw(S,0.5);
Sc = imfindContours(Sbw);
assert_checktrue(size(Sc) > 0);
firstContour = Sc(1);
assert_checkequal(size(firstContour, 2), 2);
assert_checktrue(size(firstContour, 1) >= 3);

//==============================================================================
