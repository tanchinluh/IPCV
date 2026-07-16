function out = imlocalstd(image, ksize)
    // Compute local standard deviation using box-filtered first and second moments.
    if argn(2) < 2 then ksize = [3 3]; end
    values = double(image);
    meanValues = imboxfilter(values, ksize);
    meanSquares = imboxfilter(values .^ 2, ksize);
    variance = meanSquares - meanValues .^ 2;
    variance(variance < 0) = 0;
    out = sqrt(variance);
endfunction
