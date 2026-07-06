//==============================================================================
// IPCV - Scilab Image Processing and Computer Vision toolbox
// Copyright (C) 2017  Tan Chin Luh
//==============================================================================
// unit test imfindContours
//==============================================================================

S = imread(fullpath(getIPCVpath() + "/images/coins_gray.jpg"));
Sbw = im2bw(S,0.5);
Sc = imfindContours(Sbw);
assert_checkequal(max(Sc),51);

//==============================================================================
