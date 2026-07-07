//==============================================================================
// Allan CORNET - 2012 - DIGITEO
//
// IPCV - Scilab Image Processing and Computer Vision toolbox
// Copyright (C) 2017  Tan Chin Luh
//==============================================================================
// unit test imwrite
//==============================================================================

im = rand(200,300);
imwrite(im, fullpath(TMPDIR + '/rand.png'));
S = imread(fullpath(TMPDIR + '/rand.png'));
assert_checkequal(im2uint8(im),S);


//==============================================================================
