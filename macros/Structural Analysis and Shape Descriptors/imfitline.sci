function line = imfitline(points)
    // Fit a 2D line and return [vx vy x0 y0].
    if argn(2) <> 1 | size(points, 2) <> 2 | size(points, 1) < 2 then error("imfitline: points must be an N-by-2 matrix with at least two rows."); end
    x = points(:, 1); y = points(:, 2); x0 = mean(x); y0 = mean(y); dx = x - x0; dy = y - y0;
    a = sum(dx .* dx); b = sum(dx .* dy); c = sum(dy .* dy); angle = 0.5 * atan(2 * b / max(a - c, %eps));
    line = [cos(angle) sin(angle) x0 y0];
endfunction
