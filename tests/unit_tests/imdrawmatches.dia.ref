//==============================================================================
// IPCV - Scilab Image Processing and Computer Vision toolbox
// Copyright (C) 2017  Tan Chin Luh
//==============================================================================
// unit test imdrawmatches  
//==============================================================================

S = imread(fullpath(getIPCVpath() + "/images/balloons_gray.png"));
S2 = imrotate(S,45);
f1 = imdetect_ORB(S);
f2 = imdetect_ORB(S2);
d1 = imextract_DescriptorORB(S,f1);
d2 = imextract_DescriptorORB(S2,f2);
m = immatch_BruteForce(d1,d2,4);
[fout1,fout2,mout] = imbestmatches(f1,f2,m,10);
SS = imdrawmatches(S,S2,fout1,fout2,mout);
assert_checkequal(size(SS),[423.   723.   3.]);

//==============================================================================
