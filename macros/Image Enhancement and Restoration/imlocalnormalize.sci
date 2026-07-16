function out = imlocalnormalize(image, window, epsilon)
    // Normalize intensity by local mean and standard deviation.
    rhs = argn(2); if rhs < 1 | rhs > 3 then error("imlocalnormalize: invalid arguments."); end
    if rhs < 2 then window = [7 7]; end
    if rhs < 3 then epsilon = 0.01; end
    if epsilon <= 0 then error("imlocalnormalize: epsilon must be positive."); end
    values = im2double(image); meanValues = imlocalmean(values, window); stdValues = imlocalstd(values, window);
    normalized = (values - meanValues) ./ (stdValues + epsilon); low = min(normalized); high = max(normalized);
    out = (normalized - low) ./ max(high - low, %eps);
endfunction
