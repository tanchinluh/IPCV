//==============================================================================
// Allan CORNET - 2012 - DIGITEO
//
// IPCV - Scilab Image Processing and Computer Vision toolbox
// Copyright (C) 2017  Tan Chin Luh
//==============================================================================
// unit test imblockproc
//==============================================================================
A = testmatrix('mag',15);
deff('y=myfunc(x)','y = mean(x)');
y = imblockproc(A,[3 3],'myfunc');
assert_checkequal(size(y),[5 5]);
//==============================================================================
