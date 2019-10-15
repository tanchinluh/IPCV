//==============================================================================
// IPCV - Scilab Image Processing and Computer Vision toolbox
// Copyright (C) 2017  Tan Chin Luh
//==============================================================================
// unit test imdetect_ORB
//==============================================================================

S = imcreatechecker(8,8,[1 0.5]);
fobj = imdetect_ORB(S);
assert_checkequal(fobj.n,244);

//==============================================================================
