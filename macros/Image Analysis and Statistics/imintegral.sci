function out = imintegral(image)
    // Compute a 2D summed-area table with a zero border.
    if argn(2) <> 1 then error("imintegral: one 2D image is required."); end
    if size(size(image), "*") <> 2 then error("imintegral: a 2D image is required."); end
    rows = size(image, 1); cols = size(image, 2);
    values = double(image);
    out = zeros(rows + 1, cols + 1);
    for r = 1:rows
        rowSum = 0;
        for c = 1:cols
            rowSum = rowSum + values(r, c);
            out(r + 1, c + 1) = out(r, c + 1) + rowSum;
        end
    end
endfunction
