function properties = imgraycoprops(glcm)
    // Calculate standard GLCM texture properties.
    if argn(2) <> 1 then error("imgraycoprops: one GLCM input is required."); end
    dims = size(glcm); levels = dims(1); count = 1;
    if size(dims, "*") >= 3 then count = dims(3); else glcm = matrix(glcm, levels, levels, 1); end
    properties = struct("Contrast", zeros(1, count), "Correlation", zeros(1, count), "Energy", zeros(1, count), "Homogeneity", zeros(1, count));
    for k = 1:count
        p = double(glcm(:, :, k)); total = sum(matrix(p, -1, 1));
        if total <= 0 then continue; end
        p = p ./ total; rows = (1:levels)'; cols = 1:levels;
        meanRow = sum(rows .* sum(p, 2)); meanCol = sum(cols .* sum(p, 1));
        stdRow = sqrt(sum((rows - meanRow).^2 .* sum(p, 2))); stdCol = sqrt(sum((cols - meanCol).^2 .* sum(p, 1)));
        contrast = 0; energy = 0; homogeneity = 0; correlation = 0;
        for i = 1:levels
            for j = 1:levels
                contrast = contrast + p(i, j) * (i - j)^2;
                energy = energy + p(i, j)^2;
                homogeneity = homogeneity + p(i, j) / (1 + abs(i - j));
                if stdRow > %eps & stdCol > %eps then correlation = correlation + p(i, j) * (i - meanRow) * (j - meanCol) / (stdRow * stdCol); end
            end
        end
        if stdRow <= %eps | stdCol <= %eps then correlation = 1; end
        properties.Contrast(k) = contrast; properties.Correlation(k) = correlation; properties.Energy(k) = sqrt(energy); properties.Homogeneity(k) = homogeneity;
    end
endfunction
