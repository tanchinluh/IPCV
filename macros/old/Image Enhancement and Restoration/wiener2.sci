function out = wiener2(image, window, noise)
    // MATLAB-compatible local Wiener-filter entry point.
    rhs = argn(2);
    if rhs < 2 then window = [3 3]; end
    if rhs < 3 then noise = []; end
    if size(window, "*") <> 2 then error("window must be [rows cols]."); end
    out = imwiener2(image, window, noise);
endfunction
