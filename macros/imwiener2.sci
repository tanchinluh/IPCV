//=============================================================================
// IPCV - Scilab Image Processing and Computer Vision toolbox
// Copyright (C) 2017  Tan Chin Luh
//=============================================================================
function imout = imwiener2(imin,mn,noise)
    // Wiener filter for image
    //
    // Syntax
    //    imout = imwiener2(imin,mn,noise)
    //
    // Parameters
    //    imin : Source Image
    //    mn : Block size
    //    noise : Noise ratio
    //    imout : Output Image
    //
    // Description
    //    Wiener filter is used tp filter out noise that has corrupted an image based on a statistical approach.
    //
    // Examples
    //    S = imread(fullpath(getIPCVpath() + "/images/measure_gray.jpg"));
    //    S2 = imnoise(S,'gaussian');
    //    imshow(S2);
    //    S3 = imwiener2(S2,[3 3],0.2);
    //    imshow(S3);
    //
    // See also
    //    imfilter
    //
    // Authors
    //    Tan Chin Luh
    //


    //

    block_sz = prod(mn);

    loc_mean = filter2(imin,ones(mn(1),mn(2))) / block_sz;
    loc_var = filter2(imin.^2,ones(mn(1),mn(2))) / block_sz - loc_mean.^2;

    // Estimate the noise power if necessary.
    if (isempty(noise))
        noise = mean(loc_var);
    end

    // Compute result
    imout = loc_mean + (max(0, loc_var - noise) ./ max(loc_var, noise)) .* (imin - loc_mean);

endfunction



