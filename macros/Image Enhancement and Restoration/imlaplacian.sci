function out = imlaplacian(image, alpha)
    // Apply a Laplacian filter and return the numeric response.
    if argn(2) < 2 then alpha = 0.2; end
    if type(alpha) <> 1 | size(alpha, "*") <> 1 | alpha < 0 | alpha > 1 then error("alpha must be in the range 0 to 1."); end
    out = imfilter(double(image), imfspecial("laplacian", alpha));
endfunction
