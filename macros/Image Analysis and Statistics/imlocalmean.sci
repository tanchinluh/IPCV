function out = imlocalmean(image, ksize)
    // Compute local mean using a normalized box filter.
    if argn(2) < 2 then ksize = [3 3]; end
    out = imboxfilter(double(image), ksize);
endfunction
