function [descriptor, codes] = imlbp(image, radius, points)
    // Compute a nearest-neighbor Local Binary Pattern descriptor.
    rhs = argn(2);
    if rhs < 1 | rhs > 3 then error("imlbp: invalid arguments."); end
    if rhs < 2 then radius = 1; end
    if rhs < 3 then points = 8; end
    radius = round(radius); points = round(points);
    if radius < 1 | points < 1 | points > 16 then error("imlbp: invalid radius or point count."); end
    values = im2double(image); if size(size(values), "*") == 3 then values = rgb2gray(values); end
    rows = size(values, 1); cols = size(values, 2); codes = zeros(rows, cols); descriptor = zeros(1, 2^points);
    for r = 1:rows
        for c = 1:cols
            center = values(r, c); code = 0;
            for p = 0:points - 1
                angle = 2 * %pi * p / points; rr = min(max(round(r + radius * sin(angle)), 1), rows); cc = min(max(round(c + radius * cos(angle)), 1), cols);
                if values(rr, cc) >= center then code = code + 2^p; end
            end
            codes(r, c) = code; descriptor(code + 1) = descriptor(code + 1) + 1;
        end
    end
    descriptor = descriptor ./ max(sum(descriptor), 1);
endfunction
