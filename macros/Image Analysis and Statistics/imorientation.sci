function angle = imorientation(image)
    // Return the principal orientation of image intensity in degrees.
    if argn(2) <> 1 then error("imorientation: one image input is required."); end
    moments = immoments(image); angle = 0.5 * atan(2 * moments.Mu11, moments.Mu20 - moments.Mu02) * 180 / %pi;
endfunction
