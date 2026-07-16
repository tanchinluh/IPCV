function out = imtranslate3(volume, offset, fillValue)
    // Translate a 3D volume by integer or fractional offsets using nearest-neighbor sampling.
    rhs = argn(2);
    if rhs < 2 | rhs > 3 then error("imtranslate3: volume and [dx dy dz] offset are required."); end
    if size(size(volume), "*") <> 3 | size(offset, "*") <> 3 then error("imtranslate3: invalid volume or offset."); end
    if rhs < 3 then fillValue = 0; end
    rows = size(volume, 1); cols = size(volume, 2); slices = size(volume, 3); source = double(volume);
    out = ones(rows, cols, slices) * fillValue;
    for z = 1:slices
        sz = round(z - offset(3));
        if sz < 1 | sz > slices then continue; end
        for y = 1:rows
            sy = round(y - offset(2));
            if sy < 1 | sy > rows then continue; end
            for x = 1:cols
                sx = round(x - offset(1));
                if sx >= 1 & sx <= cols then out(y, x, z) = source(sy, sx, sz); end
            end
        end
    end
endfunction
