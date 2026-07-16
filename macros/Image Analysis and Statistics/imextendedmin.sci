function out = imextendedmin(image, depth, connectivity)
    // Keep local minima whose contrast to a higher neighbor is at least depth.
    rhs = argn(2);
    if rhs < 2 then error("imextendedmin requires an image and a nonnegative depth."); end
    if type(depth) <> 1 | size(depth, "*") <> 1 | depth < 0 then error("depth must be a nonnegative scalar."); end
    if rhs < 3 then connectivity = 8; end
    if type(connectivity) <> 1 | size(connectivity, "*") <> 1 | (connectivity <> 4 & connectivity <> 8) then error("connectivity must be 4 or 8."); end
    dims = size(image);
    if size(dims, "*") <> 2 | size(image, "*") == 0 then error("image must be a non-empty 2D image."); end
    values = double(image);
    candidates = imregionalmin(values, connectivity);
    out = zeros(size(values, 1), size(values, 2)) == 1;
    for i = 1:size(values, 1)
        for j = 1:size(values, 2)
            if candidates(i, j) then
                contrast = 0;
                for di = -1:1
                    for dj = -1:1
                        isNeighbor = ~(di == 0 & dj == 0);
                        isConnected = connectivity == 8 | abs(di) + abs(dj) == 1;
                        ni = i + di; nj = j + dj;
                        if isNeighbor & isConnected & ni >= 1 & ni <= size(values, 1) & nj >= 1 & nj <= size(values, 2) then
                            if values(ni, nj) > values(i, j) then
                                difference = values(ni, nj) - values(i, j);
                                if difference > contrast then contrast = difference; end
                            end
                        end
                    end
                end
                if contrast >= depth then out(i, j) = %t; end
            end
        end
    end
endfunction
