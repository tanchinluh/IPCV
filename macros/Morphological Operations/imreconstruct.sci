function out = imreconstruct(marker, mask, connectivity)
    // Reconstruct a binary marker under a binary mask by geodesic dilation.
    rhs = argn(2);
    if rhs < 2 then error("imreconstruct requires marker and mask images."); end
    if rhs < 3 then connectivity = 8; end
    if type(connectivity) <> 1 | size(connectivity, "*") <> 1 | (connectivity <> 4 & connectivity <> 8) then
        error("connectivity must be 4 or 8.");
    end
    marker = ipcv_binary_mask(marker, "imreconstruct");
    mask = ipcv_binary_mask(mask, "imreconstruct");
    if size(marker, 1) <> size(mask, 1) | size(marker, 2) <> size(mask, 2) then
        error("marker and mask must have the same size.");
    end
    if sum(matrix(marker & ~mask, -1, 1)) <> 0 then
        error("marker must be a subset of mask.");
    end

    if connectivity == 4 then
        se = imcreatese("cross", 3, 3);
    else
        se = imcreatese("rect", 3, 3);
    end
    out = marker;
    maxIterations = size(mask, "*") + 1;
    for iteration = 1:maxIterations
        next = (imdilate(out, se) <> 0) & mask;
        if sum(matrix(next <> out, -1, 1)) == 0 then return; end
        out = next;
    end
    error("imreconstruct did not converge within the image-size limit.");
endfunction
