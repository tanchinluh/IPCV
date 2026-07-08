//=============================================================================
// IPCV - Scilab Image Processing and Computer Vision toolbox
// Copyright (C) 2017  Tan Chin Luh
//=============================================================================
function y = imidct(x)
    // Inverse discrete cosine transform (DCT) 
    //
    // Syntax
    //      y = imdct(x);
    //
    // Parameters
    //     x : Input Matrix (1D or 2D)
    //     y : Output Matrix same dimension with x
    //
    // Description
    //    Performs an inverse discrete Cosine transform of 1D or 2D array.
    //
    // Examples
    //    S = imread(fullpath(getIPCVpath() + "/images/measure_gray.jpg"));
    //    y = imdct(S);
    //    y2 = zeros(y);
    //    y2(1:100,1:100) = y(1:100,1:100);
    //    imshow(y2,jet(256));
    //    S2 = imidct(y2);
    //    imshow(S2./255);
    //
    // See also
    //     imdct
    //     fft2pad
    //
    // Authors
    //    Tan Chin Luh
    //




    if length(size(x)) > 2 then
        error('Matrix must be either 1-D or 2-D');
    end

    if type(x) == 8 then
        y = int_imidct(double(x));    
    elseif type(x) == 1
        y = int_imidct(x);
    else
        error('Wrong datatype');
    end


endfunction








