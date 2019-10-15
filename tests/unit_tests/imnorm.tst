//==============================================================================
// Allan CORNET - 2012 - DIGITEO
//
// IPCV - Scilab Image Processing and Computer Vision toolbox
// Copyright (C) 2017  Tan Chin Luh
//==============================================================================
// unit test imnorm
//==============================================================================

s = rand(5,5);
s2 = imnorm(s);
assert_checkequal(min(s2),0);
assert_checkequal(max(s2),1);

//==============================================================================
