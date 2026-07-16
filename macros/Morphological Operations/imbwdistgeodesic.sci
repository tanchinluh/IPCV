function distance = imbwdistgeodesic(image, seed, connectivity)
    // Compute geodesic distance from a seed inside a binary mask.
    //
    // Syntax
    //    distance = imbwdistgeodesic(image, [x y])
    //    distance = imbwdistgeodesic(image, [x y], connectivity)
    //
    // Examples
    //    image = imread(fullpath(getIPCVpath() + "/images/circbw.tif"));
    //    distance = imbwdistgeodesic(image, [50 50], 8);
    //    imshow(distance, hot(64));
    //
    // See also
    //    imdistransf
    //    imreconstruct
    //
    // Authors
    //    Tan Chin Luh
    //
    // History
    //    5.0.0: Function introduced.
    rhs = argn(2); if rhs < 2 | rhs > 3 then error("imbwdistgeodesic: invalid arguments."); end
    if rhs < 3 then connectivity = 8; end
    mask = ipcv_binary_mask(image, "imbwdistgeodesic"); rows = size(mask, 1); cols = size(mask, 2);
    if size(seed, "*") <> 2 | (connectivity <> 4 & connectivity <> 8) then error("imbwdistgeodesic: invalid seed or connectivity."); end
    distance = %inf * ones(rows, cols); x = round(seed(1)); y = round(seed(2));
    if x < 1 | x > cols | y < 1 | y > rows | ~mask(y, x) then error("imbwdistgeodesic: seed must be inside the mask."); end
    distance(y, x) = 0; queue = [y x]; head = 1;
    if connectivity == 4 then directions = [-1 0; 1 0; 0 -1; 0 1]; else directions = [-1 0; 1 0; 0 -1; 0 1; -1 -1; -1 1; 1 -1; 1 1]; end
    while head <= size(queue, 1)
        r = queue(head, 1); c = queue(head, 2); head = head + 1;
        for d = 1:size(directions, 1)
            rr = r + directions(d, 1); cc = c + directions(d, 2);
            if rr >= 1 & rr <= rows & cc >= 1 & cc <= cols then
                if mask(rr, cc) & distance(rr, cc) == %inf then
                    distance(rr, cc) = distance(r, c) + 1; queue = [queue; rr cc];
                end
            end
        end
    end
endfunction
