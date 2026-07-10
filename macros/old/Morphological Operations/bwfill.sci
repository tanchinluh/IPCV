function out = bwfill(image)
    // MATLAB-style binary hole-filling entry point.
    mask = ipcv_binary_mask(image, "bwfill");
    raw = imfill(mask);
    dims = size(mask);
    out = zeros(dims(1), dims(2)) == 1;
    indices = find(raw <> 0);
    if ~isempty(indices) then out(indices) = %t; end
endfunction
