function out = immedian3(volume, window)
    // Apply a 3-D median filter.
    rhs = argn(2); if rhs < 1 | rhs > 2 then error("immedian3: invalid arguments."); end
    if rhs < 2 then window = [3 3 3]; end
    if size(window, "*") == 1 then window = [window window window]; end
    if size(window, "*") <> 3 | or(window <= 0) | or(modulo(window, 2) == 0) then error("immedian3: window must contain positive odd dimensions."); end
    values = im2double(volume); if size(size(values), "*") <> 3 then error("immedian3: a 3-D volume is required."); end
    [rows, cols, depth] = size(values); out = zeros(rows, cols, depth); ry = floor(window(1) / 2); rx = floor(window(2) / 2); rz = floor(window(3) / 2);
    for z = 1:depth; for y = 1:rows; for x = 1:cols; samples = []; for zz = max(1, z-rz):min(depth, z+rz); for yy = max(1, y-ry):min(rows, y+ry); samples = [samples; values(yy, max(1, x-rx):min(cols, x+rx), zz)']; end; end; out(y, x, z) = median(samples); end; end; end
endfunction
