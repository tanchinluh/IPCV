//==============================================================================
// IPCV - Scilab Image Processing and Computer Vision toolbox
// Copyright (C) 2017  Tan Chin Luh
//==============================================================================
// unit test imextract_DescriptorBRIEF 
//==============================================================================

S = imcreatechecker(8,8,[1 0.5]);
fobj = imdetect_BRISK(S);
des = imextract_DescriptorBRIEF(S,fobj);
assert_checkequal(size(des),[11 32]);

//==============================================================================
