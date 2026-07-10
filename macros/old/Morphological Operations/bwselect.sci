function selected = bwselect(image, x, y, connectivity)
    // Select components containing one or more [x y] seed locations.
    rhs = argn(2);
    if rhs < 3 then error("bwselect requires image, x, and y seed coordinates."); end
    if rhs < 4 then connectivity = 8; end
    if size(x, "*") <> size(y, "*") then error("x and y must have the same number of elements."); end
    mask = ipcv_binary_mask(image, "bwselect");
    [labels, count] = imconnectedcomponents(mask, connectivity);
    keep = zeros(1, count) == 1;
    for k = 1:size(x, "*")
        col = round(x(k));
        row = round(y(k));
        if col < 1 | col > size(mask, 2) | row < 1 | row > size(mask, 1) then
            error("Seed coordinates must be inside the image.");
        end
        label = labels(row, col);
        if label > 0 then keep(label) = %t; end
    end
    selected = zeros(size(mask, 1), size(mask, 2)) == 1;
    for i = 1:size(mask, 1)
        for j = 1:size(mask, 2)
            label = labels(i, j);
            if label > 0 & keep(label) then selected(i, j) = %t; end
        end
    end
endfunction
