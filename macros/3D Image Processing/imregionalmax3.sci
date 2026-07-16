function out = imregionalmax3(volume, connectivity)
    // Mark strict regional maxima in a 3D volume.
    rhs = argn(2);
    if rhs < 1 | rhs > 2 then error("imregionalmax3: invalid arguments."); end
    if size(size(volume), "*") <> 3 then error("imregionalmax3: a 3D volume is required."); end
    if rhs < 2 then connectivity = 26; end
    if connectivity <> 6 & connectivity <> 18 & connectivity <> 26 then error("imregionalmax3: connectivity must be 6, 18, or 26."); end

    rows = size(volume, 1);
    cols = size(volume, 2);
    slices = size(volume, 3);
    values = double(volume);
    isMaximum = values * 0 + 1;
    hasLowerNeighbor = values * 0;

    for dz = -1:1
        for dy = -1:1
            for dx = -1:1
                if dx == 0 & dy == 0 & dz == 0 then continue; end
                distance = abs(dx) + abs(dy) + abs(dz);
                if (connectivity == 6 & distance <> 1) | (connectivity == 18 & distance > 2) then continue; end

                dstY = max(1, 1 - dy):min(rows, rows - dy);
                dstX = max(1, 1 - dx):min(cols, cols - dx);
                dstZ = max(1, 1 - dz):min(slices, slices - dz);
                srcY = dstY + dy;
                srcX = dstX + dx;
                srcZ = dstZ + dz;

                current = values(dstY, dstX, dstZ);
                neighbor = values(srcY, srcX, srcZ);
                isMaximum(dstY, dstX, dstZ) = isMaximum(dstY, dstX, dstZ) .* double(neighbor <= current);
                hasLowerNeighbor(dstY, dstX, dstZ) = hasLowerNeighbor(dstY, dstX, dstZ) + double(neighbor < current);
            end
        end
    end

    out = (isMaximum <> 0) & (hasLowerNeighbor <> 0);
endfunction
