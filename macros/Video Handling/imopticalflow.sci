function flow = imopticalflow(first, second, blockSize, searchRadius)
    // Estimate a dense constant translation field using phase correlation.
    rhs = argn(2); if rhs < 2 | rhs > 4 then error("imopticalflow: two images are required."); end
    if rhs < 3 then blockSize = [8 8]; end
    if rhs < 4 then searchRadius = 8; end
    if size(first, 1) <> size(second, 1) | size(first, 2) <> size(second, 2) then error("imopticalflow: images must have matching sizes."); end
    if size(size(first), "*") == 3 then first = rgb2gray(first); end
    if size(size(second), "*") == 3 then second = rgb2gray(second); end
    try
        [_, translation, _, _] = imphasecorr(first, second);
        dx = translation(1); dy = translation(2);
    catch
        dx = 0; dy = 0;
    end
    flow = list(dx * ones(size(first, 1), size(first, 2)), dy * ones(size(first, 1), size(first, 2)));
endfunction
