function out = imregionalmax3(volume, connectivity)
    // Mark complete regional-maximum plateaus in a 3D volume.
    rhs = argn(2);
    if rhs < 1 | rhs > 2 then error("imregionalmax3: invalid arguments."); end
    if size(size(volume), "*") <> 3 then error("imregionalmax3: a 3D volume is required."); end
    if rhs < 2 then connectivity = 26; end
    if connectivity <> 6 & connectivity <> 18 & connectivity <> 26 then
        error("imregionalmax3: connectivity must be 6, 18, or 26.");
    end
    out = int_imregionalmax3(volume, connectivity);
endfunction