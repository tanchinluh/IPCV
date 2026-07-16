function out = imdiffusefilt(image, iterations, conductance, step)
    // Apply an edge-preserving diffusion approximation.
    rhs = argn(2); if rhs < 1 | rhs > 4 then error("imdiffusefilt: invalid arguments."); end
    if rhs < 2 then iterations = 5; end
    if rhs < 3 then conductance = 0.1; end
    if rhs < 4 then step = 0.25; end
    if iterations < 1 | conductance <= 0 | step <= 0 | step > 1 then error("imdiffusefilt: invalid diffusion parameters."); end
    out = im2double(image);
    for k = 1:iterations
        local = im2double(imgaussianblur(out, [3 3], 0.8));
        detail = out - local; weight = exp(-abs(detail) / conductance);
        out = out + step .* weight .* (local - out);
    end
    out = min(max(out, 0), 1);
endfunction
