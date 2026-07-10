function out = adapthisteq(image, clipLimit)
    // MATLAB-style compatibility entry point for adaptive histogram equalization.
    if argn(2) < 2 then clipLimit = 3; end
    out = imadapthistequal(image, clipLimit);
endfunction
