function out = imdeconvblind(image, psf, iterations)
    // Richardson-Lucy blind-style deconvolution with a fixed PSF estimate.
    //
    // Syntax
    //    out = imdeconvblind(image, psf, iterations)
    //
    // Examples
    //    image = imread(fullpath(getIPCVpath() + "/images/balloons_gray.png"));
    //    psf = imfspecial("gaussian", 9, 2);
    //    out = imdeconvblind(image, psf, 8);
    //    imshow(out);
    //
    // See also
    //    imdeconvl2
    //    imdeconvwiener
    //
    // Authors
    //    Tan Chin Luh
    //
    // History
    //    5.0.0: Function introduced.
    rhs = argn(2); if rhs < 2 | rhs > 3 then error("imdeconvblind: invalid arguments."); end
    if rhs < 3 then iterations = 10; end
    estimate = max(im2double(image), %eps); kernel = im2double(psf); kernel = kernel / sum(kernel); flipped = kernel($:-1:1, $:-1:1);
    for i = 1:round(iterations)
        estimate = max(estimate, %eps);
        relative = im2double(image) ./ max(imfilter(estimate, kernel), %eps);
        estimate = estimate .* imfilter(relative, flipped);
    end
    out = imnormalize(estimate);
endfunction
