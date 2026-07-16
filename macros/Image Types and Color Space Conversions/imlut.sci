function out = imlut(image, lut)
    // Apply a 256-entry lookup table to a uint8 image.
    if argn(2) <> 2 then error("imlut: image and a lookup table are required."); end
    if typeof(image) <> "uint8" then error("imlut: the input image must be uint8."); end
    if size(lut, "*") <> 256 then error("imlut: the lookup table must contain 256 entries."); end
    table = matrix(lut, -1, 1);
    mapped = table(double(image(:)) + 1);
    out = matrix(mapped, size(image));
endfunction
