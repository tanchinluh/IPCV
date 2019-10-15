//==============================================================================
// Allan CORNET - 2012 - DIGITEO
//
// IPCV - Scilab Image Processing and Computer Vision toolbox
// Copyright (C) 2017  Tan Chin Luh
//==============================================================================
// unit test rgb2ind
//==============================================================================

S = imread(fullpath(getIPCVpath() + "/images/puffin.png"));
[X,map] = rgb2ind(S,8);
assert_checkequal(size(map),[512 3]);

//==============================================================================
