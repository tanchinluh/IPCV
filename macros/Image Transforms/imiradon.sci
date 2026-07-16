function out = imiradon(projection, theta, outputSize)
    // Reconstruct an image by simple filtered-back-projection accumulation.
    //
    // Syntax
    //    out = imiradon(projection, theta)
    //    out = imiradon(projection, theta, outputSize)
    //
    // Examples
    //    image = imread(fullpath(getIPCVpath() + "/images/coins_gray.jpg"));
    //    [projection, radius] = imradon(image, 0:179);
    //    out = imiradon(projection, 0:179, 256);
    //    imshow(out);
    //
    // See also
    //    imradon
    //    imhough
    //
    // Authors
    //    Tan Chin Luh
    //
    // History
    //    5.0.0: Function introduced.
    rhs = argn(2); if rhs < 2 | rhs > 3 then error("imiradon: invalid arguments."); end
    if rhs < 3 then outputSize = size(projection, 1); end
    rows = round(outputSize); cols = rows; out = zeros(rows, cols);
    center = (rows + 1) / 2; radiusCenter = (size(projection, 1) + 1) / 2;
    for r = 1:rows
        for c = 1:cols
            x = c - center; y = r - center; total = 0;
            for k = 1:min(size(theta, "*"), size(projection, 2))
                index = round(x * cos(theta(k) * %pi / 180) + y * sin(theta(k) * %pi / 180) + radiusCenter);
                if index >= 1 & index <= size(projection, 1) then total = total + projection(index, k); end
            end
            out(r, c) = total / size(theta, "*");
        end
    end
    out = imnormalize(out);
endfunction
