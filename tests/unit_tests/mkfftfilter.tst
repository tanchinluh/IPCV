//==============================================================================
// Allan CORNET - 2012 - DIGITEO
//
// IPCV - Scilab Image Processing and Computer Vision toolbox
// Copyright (C) 2017  Tan Chin Luh
//==============================================================================
// unit test mkfftfilter
//==============================================================================
S = imread(fullpath(getIPCVpath() + "/images/measure_gray.jpg"));
h = mkfftfilter(S,'gauss',0.1);
S2 = fft2(im2double(S));
S3 = S2.*fftshift(h);
S4 = real(ifft(S3));
imshow(S4);

//==============================================================================
