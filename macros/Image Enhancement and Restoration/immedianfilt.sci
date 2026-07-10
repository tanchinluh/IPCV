function out = immedianfilt(image, ksize)
    // MATLAB-style compatibility entry point for median filtering.
    if argn(2) < 2 then ksize = 3; end
    if size(ksize, "*") <> 1 then error("ksize must be a scalar positive odd integer."); end
    out = immedian(image, ksize);
endfunction
