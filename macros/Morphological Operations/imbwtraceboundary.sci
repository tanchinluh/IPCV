function boundary = imbwtraceboundary(image, startPoint, connectivity)
    // Return the contour nearest to an [x y] seed point.
    rhs = argn(2);
    if rhs < 2 | rhs > 3 then
        error("imbwtraceboundary: image and start point are required.");
    end
    if rhs < 3 then connectivity = 8; end
    if size(startPoint, "*") <> 2 then
        error("imbwtraceboundary: startPoint must be [x y].");
    end
    if connectivity <> 4 & connectivity <> 8 then
        error("imbwtraceboundary: connectivity must be 4 or 8.");
    end

    mask = ipcv_binary_mask(image, "imbwtraceboundary");
    [labels, count] = imconnectedcomponents(mask, connectivity);
    best = %inf;
    boundary = [];

    for label = 1:count
        contours = imfindContours(labels == label, 1, 1);
        for contourIndex = 1:length(contours)
            current = contours(contourIndex);
            if size(current, 2) < 2 then continue; end
            offsets = current - ones(size(current, 1), 1) * startPoint;
            distance = min(sum(offsets.^2, "c"));
            if distance < best then
                best = distance;
                boundary = current;
            end
        end
    end
endfunction
