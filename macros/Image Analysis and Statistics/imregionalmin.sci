function out = imregionalmin(image, connectivity)
    // Mark pixels equal to the minimum of their local neighborhood.
    rhs = argn(2);
    if rhs < 1 then error("imregionalmin requires an image."); end
    if rhs < 2 then connectivity = 8; end
    if type(connectivity) <> 1 | size(connectivity, "*") <> 1 | (connectivity <> 4 & connectivity <> 8) then
        error("connectivity must be 4 or 8.");
    end
    dims = size(image);
    if size(dims, "*") <> 2 | size(image, "*") == 0 then error("image must be a non-empty 2D image."); end
    if connectivity == 4 then se = imcreatese("cross", 3, 3); else se = imcreatese("rect", 3, 3); end
    values = double(image);
    neighborsMin = imerode(values, se, 1, [-1 -1], "replicate");
    out = values == double(neighborsMin);
endfunction
