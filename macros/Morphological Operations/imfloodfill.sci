function mask = imfloodfill(image, seed, tolerance, connectivity)
    // Flood-fill a grayscale region from an [x y] seed.
    rhs = argn(2); if rhs < 2 | rhs > 4 then error("imfloodfill: image and seed are required."); end
    if rhs < 3 then tolerance = 0; end
    if rhs < 4 then connectivity = 4; end
    if size(seed, "*") <> 2 | tolerance < 0 | (connectivity <> 4 & connectivity <> 8) then error("imfloodfill: invalid seed, tolerance, or connectivity."); end
    rows = size(image, 1); cols = size(image, 2); values = double(image);
    x = round(seed(1)); y = round(seed(2));
    if x < 1 | x > cols | y < 1 | y > rows then error("imfloodfill: seed is outside the image."); end
    mask = zeros(rows, cols) == 1; queue = zeros(rows * cols, 2); head = 1; tail = 1; queue(1, :) = [y x]; mask(y, x) = %t; target = values(y, x);
    if connectivity == 4 then directions = [-1 0; 1 0; 0 -1; 0 1]; else directions = [-1 0; 1 0; 0 -1; 0 1; -1 -1; -1 1; 1 -1; 1 1]; end
    while head <= tail
        current = queue(head, :); head = head + 1;
        for d = 1:size(directions, 1)
            rr = current(1) + directions(d, 1); cc = current(2) + directions(d, 2);
            if rr >= 1 & rr <= rows & cc >= 1 & cc <= cols then
                if ~mask(rr, cc) & abs(values(rr, cc) - target) <= tolerance then
                    mask(rr, cc) = %t; tail = tail + 1; queue(tail, :) = [rr cc];
                end
            end
        end
    end
endfunction
