function [labels, count, stats, centroids] = imconnectedcomponents(image, connectivity)
    // Label connected components and return measurements.
    rhs = argn(2);
    if rhs < 2 then connectivity = 8; end
    if type(connectivity) <> 1 | size(connectivity, "*") <> 1 | (connectivity <> 4 & connectivity <> 8) then
        error("connectivity must be 4 or 8.");
    end
    if size(size(image), "*") <> 2 then
        error("image must be a 2D binary or intensity matrix.");
    end

    if typeof(image) == "boolean" then
        mask = image;
    else
        mask = image <> 0;
    end
    [labels, count, stats, centroids] = int_imconnectedcomponents(mask, connectivity);
endfunction
