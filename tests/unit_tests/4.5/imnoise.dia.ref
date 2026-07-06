//==============================================================================
// Allan CORNET - 2012 - DIGITEO
//
// IPCV - Scilab Image Processing and Computer Vision toolbox
// Copyright (C) 2017  Tan Chin Luh
//==============================================================================
// unit test imnoise
//==============================================================================
im = imread(fullpath(getIPCVpath() + "/images/" + 'baboon.png'));

imn = imnoise(im, 'gaussian');
imshow(imn);

imn = imnoise(im, 'salt & pepper');
imshow(imn);

imn = imnoise(im(:,:,1), 'salt & pepper', 0.2);
imshow(imn);

lowtri = tril(ones(im(:,:,1)));
imn = imnoise( im(:,:,1), 'localvar', lowtri/5);
imshow(imn);

imn = imnoise( im(:,:,1), 'localvar', [0:0.1:1], [0:0.1:1].^3);
imshow(imn);

imn = imnoise(im, 'speckle' );
imshow(imn);
//==============================================================================
