//==============================================================================
// Allan CORNET - 2012 - DIGITEO
//
// IPCV - Scilab Image Processing and Computer Vision toolbox
// Copyright (C) 2017  Tan Chin Luh
//==============================================================================
// unit test imresize
//==============================================================================

im = imread(fullpath(getIPCVpath() + "/images/baboon.png"));
ima = imresize(im, 1.5);
assert_checkequal(size(ima),[size(im,1).*1.5,size(im,2).*1.5,size(im,3)]);
ima = imresize(im, 0.5);
assert_checkequal(size(ima),[size(im,1).*0.5,size(im,2).*0.5,size(im,3)]);
ima = imresize(im, [150 150]);
assert_checkequal(size(ima),[150 150 3]);

//==============================================================================
