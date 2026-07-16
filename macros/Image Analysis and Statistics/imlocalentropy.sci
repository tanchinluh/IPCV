function out = imlocalentropy(image, window)
    // Estimate local Shannon entropy in a sliding window.
    if argn(2) < 1 | argn(2) > 2 then error("imlocalentropy: invalid arguments."); end
    if argn(2) < 2 then window = [9 9]; end
    if size(window, "*") == 1 then window = [window window]; end
    if or(window <= 0) | or(modulo(window, 2) == 0) then error("imlocalentropy: window dimensions must be positive odd values."); end
    out = imcolfilt(im2double(image), window, "ipcv_entropy_window");
endfunction
