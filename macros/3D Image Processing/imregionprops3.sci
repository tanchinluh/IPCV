function props = imregionprops3(labels)
    // Measure connected labeled regions in a 3D volume.
    if argn(2) <> 1 | size(size(labels), "*") <> 3 then error("imregionprops3: one 3D label volume is required."); end
    count = max(matrix(double(labels), -1, 1)); rows = size(labels, 1); cols = size(labels, 2); slices = size(labels, 3);
    props = list();
    for label = 1:count
        indices = find(labels == label);
        if isempty(indices) then continue; end
        row = modulo(indices - 1, rows) + 1;
        column = modulo(floor((indices - 1) / rows), cols) + 1;
        slice = floor((indices - 1) / (rows * cols)) + 1;
        props(label) = struct("Volume", size(indices, "*"), ..
            "Centroid", [mean(column) mean(row) mean(slice)], ..
            "BoundingBox", [min(column) min(row) min(slice) max(column) - min(column) + 1 max(row) - min(row) + 1 max(slice) - min(slice) + 1], ..
            "VoxelIdxList", indices);
    end
endfunction
