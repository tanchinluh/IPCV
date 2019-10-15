//==============================================================================
// Allan CORNET - 2012 - DIGITEO
//
// IPCV - Scilab Image Processing and Computer Vision toolbox
// Copyright (C) 2017  Tan Chin Luh
//==============================================================================
// unit test imcolproc
//==============================================================================
A = testmatrix('mag',15);
deff('y=myfunc(x)','y = mean(x,1)');
y = imcolproc(A,[3 3],'myfunc');
E = imfilter(PadImage(A,0,1,1,1,1),1/9*ones(3,3));
assert_checkalmostequal(y,E(2:$-1,2:$-1));
//==============================================================================
