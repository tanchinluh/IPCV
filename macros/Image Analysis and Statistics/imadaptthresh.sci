function threshold = imadaptthresh(image, window, sensitivity)
    // Estimate a local threshold surface from mean and standard deviation.
    rhs = argn(2);
    if rhs < 1 | rhs > 3 then error("imadaptthresh: invalid arguments."); end
    if rhs < 2 then window = [15 15]; end
    if rhs < 3 then sensitivity = 0.5; end
    if size(window, "*") == 1 then window = [window window]; end
    if size(window, "*") <> 2 | or(window <= 0) | or(modulo(window, 2) == 0) then error("imadaptthresh: window must contain positive odd dimensions."); end
    if sensitivity < 0 | sensitivity > 1 then error("imadaptthresh: sensitivity must be in [0, 1]."); end
    values = im2double(image);
    if size(size(values), "*") == 3 then values = rgb2gray(values); end
    localMean = imlocalmean(values, window);
    localStd = imlocalstd(values, window);
    threshold = min(max(localMean - sensitivity .* localStd, 0), 1);
endfunction
