function out = im2uint32(image)
    // Convert an image to the full-range unsigned 32-bit representation.
    if argn(2) <> 1 then error("im2uint32: one image is required."); end
    values = im2double(image);
    values(values < 0) = 0;
    values(values > 1) = 1;
    out = uint32(round(values * (2^32 - 1)));
endfunction
