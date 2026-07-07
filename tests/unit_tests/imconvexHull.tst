//==============================================================================
// IPCV - Scilab Image Processing and Computer Vision toolbox
// Copyright (C) 2017  Tan Chin Luh
//==============================================================================
// unit test imconvexHull
//==============================================================================

S = imread(fullpath(getIPCVpath() + "/images/hand.jpg"));
Sbw = im2bw(~S,0.5);
Sc = imfindContours(Sbw);
H = imconvexHull(Sc);
assert_checkequal(size(H), size(Sc));
firstHull = H(1);
assert_checkequal(size(firstHull, 2), 2);
assert_checktrue(size(firstHull, 1) >= 3);

//==============================================================================
