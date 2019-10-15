//==============================================================================
// Allan CORNET - 2012 - DIGITEO
//
// IPCV - Scilab Image Processing and Computer Vision toolbox
// Copyright (C) 2017  Tan Chin Luh
//==============================================================================
// unit test imhitmiss
//==============================================================================

S = imread(fullpath(getIPCVpath() + "/images/morpex.png"));
se = imcreatese('ellipse',11,11);
S2 = imhitmiss(S,se);
assert_checkequal(typeof(S2),'boolean');

//==============================================================================
