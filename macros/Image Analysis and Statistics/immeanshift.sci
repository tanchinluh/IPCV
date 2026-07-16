function out = immeanshift(image, spatialRadius, colorRadius, iterations)
    // Approximate mean-shift smoothing with iterative local means.
    rhs = argn(2); if rhs < 1 | rhs > 4 then error("immeanshift: invalid arguments."); end
    if rhs < 2 then spatialRadius = 5; end
    if rhs < 3 then colorRadius = 0.1; end
    if rhs < 4 then iterations = 3; end
    if spatialRadius < 1 | colorRadius < 0 | iterations < 1 then error("immeanshift: invalid radius or iteration count."); end
    ksize = 2 * floor(spatialRadius) + 1; out = im2double(image);
    for k = 1:iterations
        local = im2double(imgaussianblur(out, ksize, spatialRadius));
        delta = local - out; weight = exp(-abs(delta) ./ max(colorRadius, %eps));
        out = (1 - weight) .* out + weight .* local;
    end
    out = min(max(out, 0), 1);
endfunction
