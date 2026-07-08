//=============================================================================
// IPCV - Scilab Image Processing and Computer Vision toolbox
// Copyright (C) 2017  Tan Chin Luh
//=============================================================================
function y = imdct(x)
    // Discrete cosine transform (DCT) 
    //
    // Syntax
    //      y = imdct(x);
    //
    // Parameters
    //     x : Input Matrix (1D or 2D)
    //     y : Output Matrix same dimension with x
    //
    // Description
    //    Performs a forward discrete Cosine transform of 1D or 2D array.
    //
    // Examples
    //    S = imread(fullpath(getIPCVpath() + "/images/measure_gray.jpg"));
    //    y = imdct(S);
    //    imshow(y,jet(256));
    //
    // See also
    //     imidct
    //     fft2pad
    //
    // Authors
    //    Tan Chin Luh
    //




    if length(size(x)) > 2 then
        error('Matrix must be either 1-D or 2-D');
    end

    // 2022-Sep-27 : Add to handle odd size image 
    if modulo(size(x,1),2) ~= 0
        x = x(1:$-1,:);
    end
    if modulo(size(x,2),2) ~= 0
        x = x(:,1:$-1);
    end


    if type(x) == 8 then
        y = int_imdct(double(x));    
    elseif type(x) == 1
        y = int_imdct(x);
    else
        error('Wrong datatype');
    end


endfunction








