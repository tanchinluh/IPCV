function out = imfillholes(image)
    // Explicit name for binary hole filling.
    mask = ipcv_binary_mask(image, "imfillholes");
    raw = imfill(mask);
    dims = size(mask);
    out = zeros(dims(1), dims(2)) == 1;
    indices = find(raw <> 0);
    if ~isempty(indices) then out(indices) = %t; end
endfunction
