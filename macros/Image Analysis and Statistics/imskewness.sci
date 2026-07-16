function value = imskewness(image)
    // Return the standardized third central moment.
    if argn(2) <> 1 then error("imskewness: one image is required."); end
    values = matrix(double(image), -1, 1);
    center = mean(values);
    scale = stdev(values);
    if scale <= %eps then value = 0; else value = mean(((values - center) / scale) .^ 3); end
endfunction
