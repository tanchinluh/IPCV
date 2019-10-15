//==============================================================================
// IPCV - Scilab Image Processing and Computer Vision toolbox
// Copyright (C) 2017  Tan Chin Luh
//==============================================================================
// unit test imdrawContours
//==============================================================================

S = imread(fullpath(getIPCVpath() + "/images/coins_gray.jpg"));
Sbw = im2bw(S,0.5);
Sc = imfindContours(Sbw);
So = imdrawContours(Sc);
assert_checkequal(size(So),[210,255,3]);

//==============================================================================
