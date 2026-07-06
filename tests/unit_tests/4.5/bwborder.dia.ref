//==============================================================================
// Allan CORNET - 2012 - DIGITEO
//
// IPCV - Scilab Image Processing and Computer Vision toolbox
// Copyright (C) 2017  Tan Chin Luh
//==============================================================================
// unit test bwborder
//==============================================================================

inm = imread(fullpath(getIPCVpath() + "/images/big_sq.png"));
outm = bwborder(im2bw(inm,0.5), 4);
assert_checkequal(min(outm),0);
assert_checkequal(max(outm),1);

//==============================================================================
