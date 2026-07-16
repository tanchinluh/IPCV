function perimeter = imbwperim(image, connectivity)
    // Return a binary boundary mask.
    if argn(2) < 2 then connectivity = 8; end
    mask = ipcv_binary_mask(image, "imbwperim");
    raw = bwborder(mask, connectivity);
    dims = size(mask);
    perimeter = zeros(dims(1), dims(2)) == 1;
    indices = find(raw <> 0);
    if ~isempty(indices) then perimeter(indices) = %t; end
endfunction
