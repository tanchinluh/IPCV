function out = imseamlessclone(source, destination, mask, center, mode)
    // Composite a source over a destination using a soft mask.
    rhs = argn(2); if rhs < 3 | rhs > 5 then error("imseamlessclone: source, destination, and mask are required."); end
    if rhs < 4 then center = [size(destination, 2) / 2 size(destination, 1) / 2]; end
    if rhs < 5 then mode = "normal"; end
    if size(source, 1) <> size(destination, 1) | size(source, 2) <> size(destination, 2) then error("imseamlessclone: source and destination must have matching sizes in the macro implementation."); end
    if size(mask, 1) <> size(destination, 1) | size(mask, 2) <> size(destination, 2) then error("imseamlessclone: mask size must match destination."); end
    if size(center, "*") <> 2 then error("imseamlessclone: center must be [x y]."); end
    if typeof(mode) <> "string" then error("imseamlessclone: mode must be a string."); end
    alpha = double(mask <> 0); sourceValues = double(source); destinationValues = double(destination);
    if max(sourceValues) <= 1 then sourceValues = sourceValues * 255; end
    if max(destinationValues) <= 1 then destinationValues = destinationValues * 255; end
    if size(size(source), "*") == 2 then sourceRgb = uint8(cat(3, sourceValues, sourceValues, sourceValues)); else sourceRgb = uint8(sourceValues(:, :, 1:3)); end
    if size(size(destination), "*") == 2 then destinationRgb = uint8(cat(3, destinationValues, destinationValues, destinationValues)); else destinationRgb = uint8(destinationValues(:, :, 1:3)); end
    out = destinationRgb;
    for ch = 1:3
        out(:, :, ch) = uint8(double(destinationRgb(:, :, ch)) .* (1 - alpha) + double(sourceRgb(:, :, ch)) .* alpha);
    end
endfunction
