function bwout = bwareaopen(image, minSize, connectivity)
    // Remove connected foreground objects smaller than minSize.
    rhs = argn(2);
    if rhs < 2 then
        error("bwareaopen requires an image and a positive minimum size.");
    end
    if type(minSize) <> 1 | size(minSize, "*") <> 1 | minSize <> round(minSize) | minSize < 1 then
        error("minSize must be a positive integer scalar.");
    end
    if rhs < 3 then connectivity = 8; end
    if type(connectivity) <> 1 | size(connectivity, "*") <> 1 | (connectivity <> 4 & connectivity <> 8) then
        error("connectivity must be 4 or 8.");
    end

    if typeof(image) == "boolean" then
        mask = image;
    else
        mask = image <> 0;
    end
    if size(mask, "*") == 0 | size(size(mask), "*") <> 2 then
        error("image must be a non-empty 2D binary image.");
    end

    [labels, count, stats] = imconnectedcomponents(mask, connectivity);
    bwout = zeros(size(mask, 1), size(mask, 2)) == 1;
    if count == 0 then
        return;
    end
    keep = stats(:, 5) >= minSize;
    for i = 1:size(mask, 1)
        for j = 1:size(mask, 2)
            label = labels(i, j);
            if label > 0 & keep(label) then
                bwout(i, j) = %t;
            end
        end
    end
endfunction
