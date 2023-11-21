//==============================================================================
// IPCV - Scilab Image Processing and Computer Vision toolbox
// Copyright (C) 2017  Tan Chin Luh
//==============================================================================
// unit test imextract_DescriptorFREAK  
//==============================================================================

S = imcreatechecker(8,8,[1 0.5]);
fobj = imdetect_ORB(S);
des = imextract_DescriptorFREAK (S,fobj);
assert_checkequal(size(des),[1 64]);

//==============================================================================
