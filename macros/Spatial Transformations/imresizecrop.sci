function out = imresizecrop(image, outputSize)
    // Resize an image to cover outputSize, then center-crop it.
    if argn(2) <> 2 then error("imresizecrop: image and outputSize are required."); end
    if size(outputSize, "*") == 1 then outputSize = [outputSize outputSize]; end
    if size(outputSize, "*") <> 2 | or(outputSize <= 0) then error("imresizecrop: outputSize must be positive [rows cols]."); end
    outputSize = round(outputSize); rows = size(image, 1); cols = size(image, 2); scale = max(outputSize(1) / rows, outputSize(2) / cols);
    resized = imresize(image, [round(rows * scale) round(cols * scale)]); r0 = floor((size(resized, 1) - outputSize(1)) / 2) + 1; c0 = floor((size(resized, 2) - outputSize(2)) / 2) + 1;
    if size(size(resized), "*") == 3 then out = resized(r0:r0 + outputSize(1) - 1, c0:c0 + outputSize(2) - 1, :); else out = resized(r0:r0 + outputSize(1) - 1, c0:c0 + outputSize(2) - 1); end
endfunction
