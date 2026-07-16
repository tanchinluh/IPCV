function out = bwhitmiss(image, se, iterations)
    // MATLAB-style binary hit-miss entry point.
    if argn(2) < 2 then error("bwhitmiss requires an image and structuring element."); end
    if argn(2) < 3 then iterations = 1; end
    mask = ipcv_binary_mask(image, "bwhitmiss");
    out = double(imhitmiss(mask, se, iterations)) <> 0;
endfunction
