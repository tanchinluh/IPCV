function out = imbwthin(image, method)
    // MATLAB-style binary thinning entry point.
    if argn(2) < 2 then method = "zhang-suen"; end
    mask = ipcv_binary_mask(image, "imbwthin");
    out = double(imthin(uint8(double(mask) * 255), method)) <> 0;
endfunction
