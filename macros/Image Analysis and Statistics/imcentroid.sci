function centroid = imcentroid(image)
    // Return the [x y] centroid of all foreground pixels.
    mask = ipcv_binary_mask(image, "imcentroid");
    [rows, cols] = find(mask);
    if isempty(rows) then
        centroid = [%nan %nan];
    else
        centroid = [mean(cols) mean(rows)];
    end
endfunction
