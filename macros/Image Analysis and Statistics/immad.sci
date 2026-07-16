function value = immad(image)
    // Return the median absolute deviation of image intensities.
    if argn(2) <> 1 then error("immad: one image is required."); end
    values = matrix(double(image), -1, 1);
    center = median(values);
    value = median(abs(values - center));
endfunction
