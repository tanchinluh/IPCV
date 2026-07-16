function out = imimposemin(image, minima)
    // Impose regional minima at the requested marker pixels.
    if argn(2) <> 2 then error("imimposemin: image and minima mask are required."); end
    if size(image, 1) <> size(minima, 1) | size(image, 2) <> size(minima, 2) then error("imimposemin: image and minima must have the same size."); end
    out = double(image);
    marker = ipcv_binary_mask(minima, "imimposemin");
    floorValue = min(out) - 1;
    markerValues = bool2s(marker);
    out = out .* (1 - markerValues) + floorValue .* markerValues;
endfunction
