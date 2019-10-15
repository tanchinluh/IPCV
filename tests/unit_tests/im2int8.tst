//==============================================================================
// Allan CORNET - 2012 - DIGITEO
//
// IPCV - Scilab Image Processing and Computer Vision toolbox
// Copyright (C) 2017  Tan Chin Luh
//==============================================================================
// unit test im2int8
//==============================================================================

S = rand(10,10);
S(1) = 1; S(2) = 0;
S2 = im2int8(S);
assert_checkequal(typeof(S2),'int8');
assert_checkequal(double(min(S2)),-2^8/2);
assert_checkequal(double(max(S2)),2^8/2-1);

//==============================================================================
