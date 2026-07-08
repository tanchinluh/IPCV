//=============================================================================
// IPCV - Scilab Image Processing and Computer Vision toolbox
// Copyright (C) 2017  Tan Chin Luh
//=============================================================================
function y = fft2pad(x,r,c)
    // Pad smaller matrix with zeros to the given size before transformation.
    //
    // Syntax
    //    y = fft2pad(x,r,c)
    //
    // Parameters
    //    x : Source matrix
    //    r : Number of rows for the output image
    //    c : Number of columns for the output image
    //    y : Output matric with rxc size
    //
    // Description
    //    FFT2PAD will pad the input matrix to the given r x c size, and perform fft2
    //    after the padding. This will yield the output matrix at the same size given.
    //    This is useful in the frequency domain filtering.
    //
    // Examples
    //    x = testmatrix('magic',5);
    //    y = fft2pad(x,8,8);
    //
    // See also
    //    imdct
    //    imidct
    //
    // Authors
    //    Tan Chin Luh
    
    // Error Checking
    rhs=argn(2);
    dim = size(x);
    rows = dim(1);
    cols = dim(2);

    if length(dim) == 3 then
        deps = dim(3);
    else
        deps = 1;
    end


    if rhs < 1; error("Expect 1 arguments, source matrix"); end
    if rhs < 2; r = rows; end
    if rhs < 3; c = cols; end
    if deps > 1; error("Matrix must be in 2D"); end
    if r == []; r = rows; end
    if c == []; c = cols; end
    // End of Error Checking

    sz = size(x);

    x2 = PadImage(x,0,0,c-sz(2),0,r-sz(1));
    y = fft2(x2);


endfunction




