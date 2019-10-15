//==============================================================================
// IPCV - Scilab Image Processing and Computer Vision toolbox
// Copyright (C) 2017  Tan Chin Luh
//==============================================================================
// unit test imextract_DescriptorSIFT 
//==============================================================================

S = imcreatechecker(8,8,[1 0.5]);
fobj = imdetect_SIFT(S);
des = imextract_DescriptorSIFT(S,fobj);
assert_checkequal(size(des),[308 128]);

//==============================================================================
