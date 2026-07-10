function boundaries = imbwboundaries(image, rmode, method)
    // MATLAB-style contour extraction entry point.
    rhs = argn(2);
    if rhs < 2 then rmode = 2; end
    if rhs < 3 then method = 1; end
    mask = ipcv_binary_mask(image, "imbwboundaries");
    boundaries = imfindContours(mask, rmode, method);
endfunction
