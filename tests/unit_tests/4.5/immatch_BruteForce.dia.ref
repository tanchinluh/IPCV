//==============================================================================
// IPCV - Scilab Image Processing and Computer Vision toolbox
// Copyright (C) 2017  Tan Chin Luh
//==============================================================================
// unit test immatch_BruteForce  
//==============================================================================

S = imread(fullpath(getIPCVpath() + "/images/balloons_gray.png"));
S2 = imrotate(S,45);
f1 = imdetect_ORB(S);
f2 = imdetect_ORB(S2);
d1 = imextract_DescriptorORB(S,f1);
d2 = imextract_DescriptorORB(S2,f2);
m = immatch_BruteForce(d1,d2,4);
assert_checkequal(size(m),[4 289]);

//==============================================================================
