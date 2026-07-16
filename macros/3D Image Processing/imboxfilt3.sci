function out = imboxfilt3(volume, window)
    // Apply a 3-D normalized box filter.
    rhs = argn(2); if rhs < 1 | rhs > 2 then error("imboxfilt3: invalid arguments."); end
    if rhs < 2 then window = [3 3 3]; end
    if size(window, "*") == 1 then window = [window window window]; end
    if size(window, "*") <> 3 | or(window <= 0) then error("imboxfilt3: window must contain three positive dimensions."); end
    values = im2double(volume); if size(size(values), "*") <> 3 then error("imboxfilt3: a 3-D volume is required."); end
    [rows, cols, depth] = size(values); out = zeros(rows, cols, depth); ry = floor(window(1) / 2); rx = floor(window(2) / 2); rz = floor(window(3) / 2);
    for z = 1:depth; for y = 1:rows; for x = 1:cols; total = 0; count = 0; for zz = max(1, z-rz):min(depth, z+rz); for yy = max(1, y-ry):min(rows, y+ry); for xx = max(1, x-rx):min(cols, x+rx); total = total + values(yy, xx, zz); count = count + 1; end; end; end; out(y, x, z) = total / count; end; end; end
endfunction
