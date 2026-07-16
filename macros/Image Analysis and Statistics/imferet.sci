function result = imferet(image)
    // Estimate the maximum Feret span from the foreground bounding box.
    if argn(2) <> 1 then error("imferet: one binary image input is required."); end
    if typeof(image) == "boolean" then
        mask = image;
    else
        mask = image <> 0;
    end
    [rowIndices, columnIndices] = find(mask);
    if isempty(rowIndices) then
        result = struct("MaxDiameter", 0, "Angle", 0, "BoundingBox", [0 0 0 0]);
        return;
    end

    rowIndices = matrix(rowIndices, -1, 1);
    columnIndices = matrix(columnIndices, -1, 1);
    minimumX = min(columnIndices);
    maximumX = max(columnIndices);
    minimumY = min(rowIndices);
    maximumY = max(rowIndices);
    deltaX = maximumX - minimumX;
    deltaY = maximumY - minimumY;
    diameter = sqrt(deltaX * deltaX + deltaY * deltaY);
    angle = atan(deltaY, deltaX) * 180 / %pi;

    result = struct( ..
        "MaxDiameter", diameter, ..
        "Angle", angle, ..
        "BoundingBox", [minimumX minimumY deltaX + 1 deltaY + 1] ..
    );
endfunction
