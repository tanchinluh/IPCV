function out = imboxfilt(image, ksize)
    // MATLAB-style compatibility entry point for normalized box filtering.
    if argn(2) < 2 then ksize = [3 3]; end
    out = imboxfilter(image, ksize);
endfunction
