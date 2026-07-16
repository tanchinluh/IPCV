function descriptor = imhog(image, cellSize, blockSize, bins)
    // Compute a HOG descriptor from image gradients.
    //
    // Syntax
    //    descriptor = imhog(image, cellSize, blockSize, bins)
    //
    // Examples
    //    image = imread(fullpath(getIPCVpath() + "/images/people.jpg"));
    //    descriptor = imhog(image, [8 8], [2 2], 9);
    //    disp(size(descriptor));
    //
    // See also
    //    imgradientxy
    //    imdetect
    //
    // Authors
    //    Tan Chin Luh
    //
    // History
    //    5.0.0: Function introduced.
    rhs = argn(2); if rhs < 1 | rhs > 4 then error("imhog: invalid arguments."); end
    if rhs < 2 then cellSize = [8 8]; end
    if rhs < 3 then blockSize = [2 2]; end
    if rhs < 4 then bins = 9; end
    if size(cellSize, "*") <> 2 | size(blockSize, "*") <> 2 then error("imhog: cellSize and blockSize must have two elements."); end
    gray = image; if size(size(gray), "*") == 3 then gray = rgb2gray(gray); end
    [gx, gy] = imgradientxy(gray); magnitude = sqrt(gx.^2 + gy.^2); angle = modulo(atan(gy, gx) * 180 / %pi + 180, 180);
    rows = floor(size(gray, 1) / cellSize(1)); cols = floor(size(gray, 2) / cellSize(2)); histograms = zeros(rows, cols, bins);
    for r = 1:rows
        for c = 1:cols
            for rr = 1:cellSize(1)
                for cc = 1:cellSize(2)
                    b = min(bins, floor(angle((r - 1) * cellSize(1) + rr, (c - 1) * cellSize(2) + cc) / 180 * bins) + 1);
                    histograms(r, c, b) = histograms(r, c, b) + magnitude((r - 1) * cellSize(1) + rr, (c - 1) * cellSize(2) + cc);
                end
            end
        end
    end
    descriptor = matrix(histograms, -1, 1);
endfunction
