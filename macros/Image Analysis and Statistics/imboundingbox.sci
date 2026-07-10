function box = imboundingbox(image)
    // Return the foreground bounding box as [x y width height].
    mask = ipcv_binary_mask(image, "imboundingbox");
    [rows, cols] = find(mask);
    if isempty(rows) then
        box = [0 0 0 0];
    else
        minRow = min(rows);
        maxRow = max(rows);
        minCol = min(cols);
        maxCol = max(cols);
        box = [minCol minRow maxCol - minCol + 1 maxRow - minRow + 1];
    end
endfunction
