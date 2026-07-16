function out = imdeconvreg(image, psf, lambda)
    // Regularized deconvolution using an L2 frequency-domain penalty.
    //
    // Syntax
    //    out = imdeconvreg(image, psf, lambda)
    //
    // Examples
    //    image = imread(fullpath(getIPCVpath() + "/images/balloons_gray.png"));
    //    psf = imfspecial("gaussian", 9, 2);
    //    out = imdeconvreg(image, psf, 0.01);
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
    if argn(2) <> 3 | lambda < 0 then error("imdeconvreg: image, psf, and non-negative lambda are required."); end
    out = imdeconvl2(im2double(image), im2double(psf), lambda);
endfunction
