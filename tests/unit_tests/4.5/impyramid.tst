//==============================================================================
// Allan CORNET - 2012 - DIGITEO
//
// IPCV - Scilab Image Processing and Computer Vision toolbox
// Copyright (C) 2017  Tan Chin Luh
//==============================================================================
// unit test impyramid
//==============================================================================

im0 = imread(fullpath(getIPCVpath() + "/images/" + 'baboon.png'));
im1 = impyramid(im0, 'reduce');
im2 = impyramid(im1, 'reduce');
im3 = impyramid(im2, 'reduce');

assert_checkequal(size(im0),[512 512 3]); 
assert_checkequal(size(im1),[512/2 512/2 3]); 
assert_checkequal(size(im2),[512/4 512/4 3]); 
assert_checkequal(size(im3),[512/8 512/8 3]); 

//==============================================================================
