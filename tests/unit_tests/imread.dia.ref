//==============================================================================
// Allan CORNET - 2012 - DIGITEO
//
// IPCV - Scilab Image Processing and Computer Vision toolbox
// Copyright (C) 2017  Tan Chin Luh
//==============================================================================
// unit test imread
//==============================================================================

S =  imread(getIPCVpath() + '/images/baboon.png');
assert_checkequal(size(S), [512 512 3]);

bwPath = fullpath(getIPCVpath() + "/images/big_sq.png");
Sgray = imread(bwPath, IMREAD_GRAYSCALE=1);
assert_checkequal(typeof(Sgray), "uint8");
assert_checkequal(size(Sgray, "*"), prod(size(Sgray)));

Sbin = imread(bwPath, IMREAD_GRAYSCALE=1, IMREAD_BINARY=1);
assert_checkequal(typeof(Sbin), "boolean");
assert_checkequal(size(Sbin), size(Sgray));

//==============================================================================
