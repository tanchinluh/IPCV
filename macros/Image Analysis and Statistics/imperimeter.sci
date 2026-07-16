function perimeter = imperimeter(image)
    // Count foreground-to-background pixel edges using 4-neighborhoods.
    mask = ipcv_binary_mask(image, "imperimeter");
    rows = size(mask, 1);
    cols = size(mask, 2);
    perimeter = 0;
    for i = 1:rows
        for j = 1:cols
            if mask(i, j) then
                if i == 1 | ~mask(i - 1, j) then perimeter = perimeter + 1; end
                if i == rows | ~mask(i + 1, j) then perimeter = perimeter + 1; end
                if j == 1 | ~mask(i, j - 1) then perimeter = perimeter + 1; end
                if j == cols | ~mask(i, j + 1) then perimeter = perimeter + 1; end
            end
        end
    end
endfunction
