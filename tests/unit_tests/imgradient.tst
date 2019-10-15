//==============================================================================
// Allan CORNET - 2012 - DIGITEO
//
// IPCV - Scilab Image Processing and Computer Vision toolbox
// Copyright (C) 2017  Tan Chin Luh
//==============================================================================
// unit test imgradient
//==============================================================================

a = zeros(10,10);
a(4:7,4:7) = 1;
se = imcreatese('rect',3,3);
b = imgradient(a,se);
assert_checkequal(type(b),type(a));

//==============================================================================
