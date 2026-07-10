function out = imbwhitmiss(image, se, iterations)
    // MATLAB-style binary hit-miss entry point.
    if argn(2) < 2 then error("imbwhitmiss requires an image and structuring element."); end
    if argn(2) < 3 then iterations = 1; end
    mask = ipcv_binary_mask(image, "imbwhitmiss");
    out = double(imhitmiss(mask, se, iterations)) <> 0;
endfunction
