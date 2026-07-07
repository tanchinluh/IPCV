//==============================================================================
// IPCV - Scilab Image Processing and Computer Vision toolbox
// Copyright (C) 2017  Tan Chin Luh
//==============================================================================
// unit test imextract_DescriptorSURF 
//==============================================================================

S = imcreatechecker(8,8,[1 0.5]);
fobj = imdetect_SURF(S);
des = imextract_DescriptorSURF(S,fobj);
assert_checkequal(size(des),[392 64]);

//==============================================================================
