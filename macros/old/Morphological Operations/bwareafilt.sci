function bwout = bwareafilt(image, areaRange, connectivity)
    // Keep connected foreground components within an inclusive area range.
    rhs = argn(2);
    if rhs < 2 then error("bwareafilt requires an image and an area range."); end
    if type(areaRange) <> 1 | (size(areaRange, "*") <> 1 & size(areaRange, "*") <> 2) then
        error("areaRange must be a positive scalar or [min max].");
    end
    if size(areaRange, "*") == 1 then
        minArea = areaRange;
        maxArea = %inf;
    else
        minArea = areaRange(1);
        maxArea = areaRange(2);
    end
    if minArea < 1 | minArea <> round(minArea) | maxArea < minArea | maxArea <> round(maxArea) then
        error("areaRange must contain positive integer limits with min <= max.");
    end
    if rhs < 3 then connectivity = 8; end
    if type(connectivity) <> 1 | size(connectivity, "*") <> 1 | (connectivity <> 4 & connectivity <> 8) then
        error("connectivity must be 4 or 8.");
    end

    mask = ipcv_binary_mask(image, "bwareafilt");
    [labels, count, stats] = imconnectedcomponents(mask, connectivity);
    bwout = zeros(size(mask, 1), size(mask, 2)) == 1;
    if count == 0 then return; end
    keep = stats(:, 5) >= minArea & stats(:, 5) <= maxArea;
    for i = 1:size(mask, 1)
        for j = 1:size(mask, 2)
            label = labels(i, j);
            if label > 0 & keep(label) then bwout(i, j) = %t; end
        end
    end
endfunction
