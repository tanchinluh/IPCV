function value = imkurtosis(image)
    // Return excess kurtosis of image intensities.
    if argn(2) <> 1 then error("imkurtosis: one image is required."); end
    values = matrix(double(image), -1, 1);
    center = mean(values);
    scale = stdev(values);
    if scale <= %eps then value = 0; else value = mean(((values - center) / scale) .^ 4) - 3; end
endfunction
