function glcm = imgraycomatrix(image, levels, offsets)
    // Build normalized gray-level co-occurrence matrices.
    rhs = argn(2);
    if rhs < 1 | rhs > 3 then error("imgraycomatrix: invalid arguments."); end
    if rhs < 2 then levels = 8; end
    if rhs < 3 then offsets = [1 0]; end
    levels = round(levels);
    if levels < 2 | size(offsets, 2) <> 2 then error("imgraycomatrix: levels and offsets are invalid."); end
    values = im2double(image);
    if size(size(values), "*") == 3 then values = rgb2gray(values); end
    values = min(max(values, 0), 1);
    quantized = round(values .* (levels - 1)) + 1;
    rows = size(values, 1); cols = size(values, 2); count = size(offsets, 1);
    glcm = zeros(levels, levels, count);
    for k = 1:count
        dx = round(offsets(k, 1)); dy = round(offsets(k, 2));
        for r = 1:rows
            for c = 1:cols
                rr = r + dy; cc = c + dx;
                if rr >= 1 & rr <= rows & cc >= 1 & cc <= cols then
                    glcm(quantized(r, c), quantized(rr, cc), k) = glcm(quantized(r, c), quantized(rr, cc), k) + 1;
                end
            end
        end
        total = sum(matrix(glcm(:, :, k), -1, 1));
        if total > 0 then glcm(:, :, k) = glcm(:, :, k) ./ total; end
    end
    if count == 1 then glcm = glcm(:, :, 1); end
endfunction
