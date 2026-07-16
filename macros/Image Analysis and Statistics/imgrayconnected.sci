function out = imgrayconnected(image, seed, tolerance, connectivity)
    // Grow a connected region around a seed pixel within an intensity tolerance.
    //
    // Syntax
    //    out = imgrayconnected(image, [x y], tolerance)
    //    out = imgrayconnected(image, [x y], tolerance, connectivity)
    //
    // Examples
    //    image = imread(fullpath(getIPCVpath() + "/images/coins_gray.jpg"));
    //    out = imgrayconnected(image, [120 100], 20, 8);
    //    imshow(out);
    //
    // See also
    //    imconnectedcomponents
    //    imreconstruct
    //
    // Authors
    //    Tan Chin Luh
    //
    // History
    //    5.0.0: Function introduced.
    rhs = argn(2);
    if rhs < 3 | rhs > 4 then error("imgrayconnected: image, seed, and tolerance are required."); end
    if rhs < 4 then connectivity = 8; end
    if size(seed, "*") <> 2 | tolerance < 0 | (connectivity <> 4 & connectivity <> 8) then error("imgrayconnected: invalid seed, tolerance, or connectivity."); end
    if size(size(image), "*") <> 2 then error("imgrayconnected: image must be grayscale."); end
    values = double(image);
    rows = size(values, 1); cols = size(values, 2);
    x = round(seed(1)); y = round(seed(2));
    if x < 1 | x > cols | y < 1 | y > rows then error("imgrayconnected: seed is outside the image."); end
    out = zeros(rows, cols) == 1;
    queue = [y x]; head = 1; out(y, x) = %t; target = values(y, x);
    if connectivity == 4 then directions = [-1 0; 1 0; 0 -1; 0 1]; else directions = [-1 0; 1 0; 0 -1; 0 1; -1 -1; -1 1; 1 -1; 1 1]; end
    while head <= size(queue, 1)
        r = queue(head, 1); c = queue(head, 2); head = head + 1;
        for d = 1:size(directions, 1)
            rr = r + directions(d, 1); cc = c + directions(d, 2);
            if rr >= 1 & rr <= rows & cc >= 1 & cc <= cols then
                if ~out(rr, cc) & abs(values(rr, cc) - target) <= tolerance then
                    out(rr, cc) = %t; queue = [queue; rr cc];
                end
            end
        end
    end
endfunction
