function out = imridge(image, threshold)
    // Detect ridge-like responses from second-order image derivatives.
    rhs = argn(2);
    if rhs < 1 | rhs > 2 then error("imridge: invalid arguments."); end
    if rhs < 2 then threshold = 0; end
    values = im2double(image);
    if size(size(values), "*") == 3 then values = rgb2gray(values); end
    dxx = imfilter2(values, [1 -2 1]);
    dyy = imfilter2(values, [1; -2; 1]);
    dxy = imfilter2(values, [1 0 -1; 0 0 0; -1 0 1] / 4);
    trace = dxx + dyy;
    discriminant = sqrt(max((dxx - dyy) .* (dxx - dyy) + 4 * dxy .* dxy, 0));
    eigenvalue = abs((trace - discriminant) / 2);
    out = eigenvalue;
    if threshold > 0 then out = out > threshold; end
endfunction
