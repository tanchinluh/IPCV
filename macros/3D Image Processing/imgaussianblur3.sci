function out = imgaussianblur3(volume, sigma)
    // Apply native separable Gaussian smoothing across all volume axes.
    rhs = argn(2);
    if rhs < 1 | rhs > 2 then error("imgaussianblur3: invalid arguments."); end
    if rhs < 2 then sigma = 1; end
    if type(sigma) <> 1 | size(sigma, "*") <> 1 | sigma <= 0 then
        error("imgaussianblur3: sigma must be a positive scalar.");
    end
    if typeof(volume(1)) == "constant" then values = double(volume); else values = im2double(volume); end;
    if size(size(values), "*") <> 3 then error("imgaussianblur3: a 3D volume is required."); end
    out = int_imgaussianblur3(values, sigma);
endfunction