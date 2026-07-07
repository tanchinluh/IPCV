//==============================================================================
// IPCV - Scilab Image Processing and Computer Vision toolbox
// Copyright (C) 2017  Tan Chin Luh
//==============================================================================
// unit test imconvexHull
//==============================================================================

S = imread(fullpath(getIPCVpath() + "/images/hand.jpg"));
Sbw = im2bw(~S,0.5);
Sc = imfindContours(Sbw);
[A, BB, ctr] = imblobprop(Sc);
[maxV,maxI] = max(A);
[row,col] = find(Sc==maxI);
[cart_x,cart_y] = sub2cartesian(size(Sc), row,col);
SS = [(cart_x)',(cart_y)'];
H = imconvexHull(SS);
assert_checkequal(size(H),[20,2]);

//==============================================================================
