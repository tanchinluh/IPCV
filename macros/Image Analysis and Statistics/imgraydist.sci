function out = imgraydist(weights, seedPoints, connectivity)
    // Compute minimum accumulated grayscale cost from one or more seeds.
    rhs = argn(2);
    if rhs < 2 | rhs > 3 then error("imgraydist: weights and seed points are required."); end
    if size(size(weights), "*") <> 2 then error("imgraydist: a 2D weight image is required."); end
    if rhs < 3 then connectivity = 8; end
    if connectivity <> 4 & connectivity <> 8 then error("imgraydist: connectivity must be 4 or 8."); end
    points = seedPoints;
    if size(points, 2) <> 2 then error("imgraydist: seed points must be an N-by-2 [x y] matrix."); end
    rows = size(weights, 1); cols = size(weights, 2); values = double(weights);
    values(values < 0) = 0;
    total = rows * cols;
    distance = ones(total, 1) * %inf;
    inQueue = zeros(total, 1) == 1;
    flatValues = matrix(values, -1, 1);
    queue = zeros(total * 4, 1);
    head = 1;
    tail = 0;

    for k = 1:size(points, 1)
        x = round(points(k, 1)); y = round(points(k, 2));
        if x < 1 | x > cols | y < 1 | y > rows then error("imgraydist: a seed is outside the image."); end
        index = y + (x - 1) * rows;
        distance(index) = 0;
        if ~inQueue(index) then
            tail = tail + 1;
            queue(tail) = index;
            inQueue(index) = %t;
        end
    end
    if connectivity == 4 then directions = [-1 0; 1 0; 0 -1; 0 1]; else directions = [-1 0; 1 0; 0 -1; 0 1; -1 -1; -1 1; 1 -1; 1 1]; end
    updates = 0;
    maxUpdates = total * 200;
    while head <= tail
        index = queue(head);
        head = head + 1;
        inQueue(index) = %f;
        best = distance(index);
        r = modulo(index - 1, rows) + 1; c = floor((index - 1) / rows) + 1;
        for d = 1:size(directions, 1)
            rr = r + directions(d, 1); cc = c + directions(d, 2);
            if rr >= 1 & rr <= rows & cc >= 1 & cc <= cols then
                neighborIndex = rr + (cc - 1) * rows;
                candidate = best + 0.5 * (flatValues(index) + flatValues(neighborIndex));
                if candidate < distance(neighborIndex) then
                    distance(neighborIndex) = candidate;
                    updates = updates + 1;
                    if updates > maxUpdates then
                        error("imgraydist: distance propagation did not converge.");
                    end
                    if ~inQueue(neighborIndex) then
                        tail = tail + 1;
                        if tail > size(queue, "*") then
                            queue($ + total, 1) = 0;
                        end
                        queue(tail) = neighborIndex;
                        inQueue(neighborIndex) = %t;
                    end
                end
            end
        end
    end
    out = matrix(distance, rows, cols);
endfunction
