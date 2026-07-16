function bwout = imclearborder(image, connectivity)
    // Remove foreground objects connected to the image border.
    rhs = argn(2);
    if rhs < 1 then
        error("imclearborder requires an image.");
    end
    if rhs < 2 then connectivity = 8; end
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

    [labels, count] = imconnectedcomponents(mask, connectivity);
    bwout = mask;
    if count == 0 then
        return;
    end

    remove = zeros(1, count) == 1;
    rows = size(mask, 1);
    cols = size(mask, 2);
    for j = 1:cols
        if labels(1, j) > 0 then remove(labels(1, j)) = %t; end
        if labels(rows, j) > 0 then remove(labels(rows, j)) = %t; end
    end
    for i = 1:rows
        if labels(i, 1) > 0 then remove(labels(i, 1)) = %t; end
        if labels(i, cols) > 0 then remove(labels(i, cols)) = %t; end
    end
    for i = 1:rows
        for j = 1:cols
            label = labels(i, j);
            if label > 0 & remove(label) then
                bwout(i, j) = %f;
            end
        end
    end
endfunction
