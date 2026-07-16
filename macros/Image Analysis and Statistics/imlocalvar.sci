function out = imlocalvar(image, window)
    // Calculate local intensity variance.
    rhs = argn(2); if rhs < 1 | rhs > 2 then error("imlocalvar: invalid arguments."); end
    if rhs < 2 then window = [3 3]; end
    out = imlocalstd(image, window).^2;
endfunction
