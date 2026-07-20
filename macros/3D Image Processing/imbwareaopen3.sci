function out = imbwareaopen3(volume, minSize, connectivity)
    // Remove small connected components from a 3D binary volume.
    rhs = argn(2);
    if rhs < 2 | rhs > 3 then error("imbwareaopen3: volume and minSize are required."); end
    if size(size(volume), "*") <> 3 then error("imbwareaopen3: a 3D volume is required."); end
    if rhs < 3 then connectivity = 6; end
    if minSize < 1 | (connectivity <> 6 & connectivity <> 18 & connectivity <> 26) then
        error("imbwareaopen3: use a positive minSize and 6, 18, or 26 connectivity.");
    end
    if typeof(volume) == "boolean" then mask = volume; else mask = volume <> 0; end
    out = int_imbwareaopen3(mask, round(minSize), connectivity);
endfunction