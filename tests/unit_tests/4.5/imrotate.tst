//==============================================================================
// Allan CORNET - 2012 - DIGITEO
//
// IPCV - Scilab Image Processing and Computer Vision toolbox
// Copyright (C) 2017  Tan Chin Luh
//==============================================================================
// unit test imrotate
//==============================================================================

S = imread(fullpath(getIPCVpath() + "/images/puffin.png"));
J = imrotate(S,45);
assert_checkfalse(isempty(J));

//==============================================================================
