function rgb = label2rgb(labels, cmap)
    // Convert a 2D label matrix to a uint8 RGB image.
    if size(size(labels), "*") <> 2 then error("labels must be a 2D matrix."); end
    maxLabel = max(labels);
    if maxLabel <= 0 then
        rgb = uint8(zeros(size(labels, 1), size(labels, 2), 3));
        return;
    end
    if argn(2) < 2 then cmap = jet(maxLabel); end
    if size(cmap, 2) <> 3 | size(cmap, 1) < maxLabel then error("cmap must have at least max(labels) rows and 3 columns."); end
    if max(cmap) <= 1 then cmap = round(cmap * 255); end
    rgb = uint8(zeros(size(labels, 1), size(labels, 2), 3));
    for i = 1:size(labels, 1)
        for j = 1:size(labels, 2)
            label = round(labels(i, j));
            if label > 0 then rgb(i, j, :) = uint8(cmap(label, :)); end
        end
    end
endfunction
