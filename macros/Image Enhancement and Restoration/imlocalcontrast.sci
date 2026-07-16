function out = imlocalcontrast(image, sigma, amount)
    // Enhance local contrast by subtracting a smooth local background.
    rhs = argn(2); if rhs < 1 | rhs > 3 then error("imlocalcontrast: invalid arguments."); end
    if rhs < 2 then sigma = 3; end
    if rhs < 3 then amount = 1; end
    if sigma <= 0 | amount < 0 then error("imlocalcontrast: sigma must be positive and amount nonnegative."); end
    ksize = 2 * max(1, ceil(3 * sigma)) + 1;
    values = im2double(image); background = im2double(imgaussianblur(image, ksize, sigma));
    out = values + amount .* (values - background);
    out = min(max(out, 0), 1);
endfunction
