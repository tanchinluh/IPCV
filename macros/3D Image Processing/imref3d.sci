function ref = imref3d(volumeSize, xWorldLimits, yWorldLimits, zWorldLimits)
    // Create a 3D volume-coordinate reference structure.
    rhs = argn(2); if rhs < 1 | rhs > 4 then error("imref3d: volume size is required."); end
    if size(volumeSize, "*") <> 3 then error("imref3d: volumeSize must be [rows cols slices]."); end
    if rhs < 2 then xWorldLimits = [1 volumeSize(2)]; end
    if rhs < 3 then yWorldLimits = [1 volumeSize(1)]; end
    if rhs < 4 then zWorldLimits = [1 volumeSize(3)]; end
    ref = struct("ImageSize", volumeSize, "XWorldLimits", xWorldLimits, "YWorldLimits", yWorldLimits, "ZWorldLimits", zWorldLimits, ..
        "PixelExtentInWorldX", (xWorldLimits(2) - xWorldLimits(1)) / volumeSize(2), ..
        "PixelExtentInWorldY", (yWorldLimits(2) - yWorldLimits(1)) / volumeSize(1), ..
        "PixelExtentInWorldZ", (zWorldLimits(2) - zWorldLimits(1)) / volumeSize(3));
endfunction
