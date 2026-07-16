function out = medfilt2(image, ksize)
    // MATLAB-compatible grayscale median-filter entry point.
    if argn(2) < 2 then ksize = 3; end
    if size(ksize, "*") <> 1 then error("ksize must be a scalar positive odd integer."); end
    if size(size(image), "*") <> 2 then error("medfilt2 accepts a 2D image."); end
    out = immedian(image, ksize);
endfunction
