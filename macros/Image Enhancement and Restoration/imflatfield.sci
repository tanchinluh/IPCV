function out = imflatfield(image, sigma)
    // Correct smooth, uneven illumination using a flat-field estimate.
    //
    // Syntax
    //    out = imflatfield(image)
    //    out = imflatfield(image, sigma)
    //
    // sigma controls the Gaussian background estimate and defaults to 25.
    // The result is normalized to the input image range.
    //
    // Examples
    //    image = imread(fullpath(getIPCVpath() + "/images/Lena_dark.png"));
    //    out = imflatfield(image, 25);
    //    imshow(out);
    //
    // See also
    //    imnormalize
    //    imgaussianblur
    //    imadjust
    //
    // Authors
    //    Tan Chin Luh
    //
    // History
    //    5.0.0: Function introduced.

    rhs = argn(2);
    if rhs < 1 | rhs > 2 then error("imflatfield: Wrong number of input arguments."); end
    if rhs < 2 then sigma = 25; end
    if sigma <= 0 then error("imflatfield: sigma must be positive."); end
    source = im2double(image);
    k = max(3, 2 * ceil(sigma / 3) + 1);
    background = imgaussianblur(source, [k k], sigma, sigma);
    meanBackground = mean(matrix(background, -1, 1));
    corrected = source .* (meanBackground ./ max(background, %eps));
    corrected(corrected < 0) = 0;
    corrected(corrected > 1) = 1;
    if typeof(image) == "uint8" then out = im2uint8(corrected); else out = corrected; end
endfunction
