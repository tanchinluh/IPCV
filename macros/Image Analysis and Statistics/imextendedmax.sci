function out = imextendedmax(image, height, connectivity)
    // Keep local maxima whose contrast to a lower neighbor is at least height.
    rhs = argn(2);
    if rhs < 2 then error("imextendedmax requires an image and a nonnegative height."); end
    if type(height) <> 1 | size(height, "*") <> 1 | height < 0 then error("height must be a nonnegative scalar."); end
    if rhs < 3 then connectivity = 8; end
    if type(connectivity) <> 1 | size(connectivity, "*") <> 1 | (connectivity <> 4 & connectivity <> 8) then error("connectivity must be 4 or 8."); end
    dims = size(image);
    if size(dims, "*") <> 2 | size(image, "*") == 0 then error("image must be a non-empty 2D image."); end
    values = double(image);
    candidates = imregionalmax(values, connectivity);
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
                            if values(i, j) > values(ni, nj) then
                                difference = values(i, j) - values(ni, nj);
                                if difference > contrast then contrast = difference; end
                            end
                        end
                    end
                end
                if contrast >= height then out(i, j) = %t; end
            end
        end
    end
endfunction
