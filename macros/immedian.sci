//=============================================================================
// IPCV - Scilab Image Processing and Computer Vision toolbox
// Copyright (C) 2017  Tan Chin Luh
//=============================================================================
function imout = immedian(imin,sz)
    // Image median filter
    //
    // Syntax
    //    imout = immedian(imin,sz)
    //
    // Parameters
    //    imin : Input image
    //    sz : Size of the filter block
    //
    // Description
    //    This function perform median filtering for an image, which effectively remove
    //    pepper and salt noise.
    //
    // Examples
    //    S = imread(fullpath(getIPCVpath() + "/images/coins_gray.jpg"));
    //    S_noise =  imnoise(S,'salt & pepper',0.02);
    //    imshow(S_noise);
    //    S2 = immedian(S_noise,3);
    //    scf; imshow(S2);
    //
    // See also
    //    imfilter
    //
    // Authors
    //    Tan Chin Luh
    //


    //

    rhs=argn(2);

    if rhs < 2; error("Expect 2 arguments, input image and filter size"); end
    // End of Error Checking

    if ~pmodulo(sz,2) | sz <= 0 then
        error('Second argument must be in positive odd number --> 1,3,5...');
    end

    if type(imin(1)) == 1 then
        imin = im2uint8(imin);
        imout = im2double(int_immedian(imin,sz));

    else type(imin(1)) == 8
        imout = int_immedian(imin,sz);
    end



endfunction

