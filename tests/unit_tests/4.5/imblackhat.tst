//==============================================================================
// Allan CORNET - 2012 - DIGITEO
//
// IPCV - Scilab Image Processing and Computer Vision toolbox
// Copyright (C) 2017  Tan Chin Luh
//==============================================================================
// unit test imblackhat
//==============================================================================

S = imread(fullpath(getIPCVpath() + "/images/morpex.png"));
se = imcreatese('ellipse',7,7);
S2 = imblackhat(S,se);
assert_checkequal(typeof(S2),'boolean');

//==============================================================================
