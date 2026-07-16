function out = imlocallapfilt(image, sigma, amount)
    // Apply a practical local Laplacian-style edge enhancement.
    rhs = argn(2);
    if rhs < 1 | rhs > 3 then error("imlocallapfilt: invalid arguments."); end
    if rhs < 2 then sigma = 2; end
    if rhs < 3 then amount = 1; end
    if sigma <= 0 | amount < 0 then error("imlocallapfilt: sigma must be positive and amount nonnegative."); end
    values = im2double(image);
    kernelSize = 2 * max(1, ceil(3 * sigma)) + 1;
    base = im2double(imgaussianblur(image, kernelSize, sigma));
    out = min(max(base + amount .* (values - base), 0), 1);
endfunction
