function out = imgaussianblur3(volume, sigma)
    // Apply a separable-style 3-D Gaussian blur using a bounded kernel.
    rhs = argn(2); if rhs < 1 | rhs > 2 then error("imgaussianblur3: invalid arguments."); end
    if rhs < 2 then sigma = 1; end
    if sigma <= 0 then error("imgaussianblur3: sigma must be positive."); end
    values = im2double(volume); if size(size(values), "*") <> 3 then error("imgaussianblur3: a 3-D volume is required."); end
    radius = max(1, ceil(3 * sigma)); axis = (-radius:radius); kernel = exp(-(axis.^2) / (2 * sigma^2)); kernel = kernel / sum(kernel);
    out = values; [rows, cols, depth] = size(values);
    temp = zeros(rows, cols, depth);
    for z = 1:depth; for y = 1:rows; for x = 1:cols; total = 0; for k = -radius:radius; xx = min(max(x + k, 1), cols); total = total + values(y, xx, z) * kernel(k + radius + 1); end; temp(y, x, z) = total; end; end; end
    temp2 = zeros(rows, cols, depth);
    for z = 1:depth; for y = 1:rows; for x = 1:cols; total = 0; for k = -radius:radius; yy = min(max(y + k, 1), rows); total = total + temp(yy, x, z) * kernel(k + radius + 1); end; temp2(y, x, z) = total; end; end; end
    for z = 1:depth; for y = 1:rows; for x = 1:cols; total = 0; for k = -radius:radius; zz = min(max(z + k, 1), depth); total = total + temp2(y, x, zz) * kernel(k + radius + 1); end; out(y, x, z) = total; end; end; end
endfunction
