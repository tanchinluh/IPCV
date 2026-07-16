function ref = imref2d(imageSize, xWorldLimits, yWorldLimits)
    // Create a 2D image-coordinate reference structure.
    rhs = argn(2); if rhs < 1 | rhs > 3 then error("imref2d: image size is required."); end
    if size(imageSize, "*") <> 2 then error("imref2d: imageSize must be [rows cols]."); end
    if rhs < 2 then xWorldLimits = [1 imageSize(2)]; end
    if rhs < 3 then yWorldLimits = [1 imageSize(1)]; end
    if size(xWorldLimits, "*") <> 2 | size(yWorldLimits, "*") <> 2 then error("imref2d: world limits must be two-element vectors."); end
    ref = struct("ImageSize", imageSize, "XWorldLimits", xWorldLimits, "YWorldLimits", yWorldLimits, ..
        "PixelExtentInWorldX", (xWorldLimits(2) - xWorldLimits(1)) / imageSize(2), ..
        "PixelExtentInWorldY", (yWorldLimits(2) - yWorldLimits(1)) / imageSize(1));
endfunction
