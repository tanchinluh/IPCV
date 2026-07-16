function disparity = imstereobm(left, right, numDisparities, blockSize)
    // Estimate a disparity map using local block matching.
    rhs = argn(2); if rhs < 2 | rhs > 4 then error("imstereobm: left and right images are required."); end
    if rhs < 3 then numDisparities = 16; end
    if rhs < 4 then blockSize = 5; end
    if size(left, 1) <> size(right, 1) | size(left, 2) <> size(right, 2) then error("imstereobm: images must have matching sizes."); end
    if size(size(left), "*") == 3 then left = rgb2gray(left); end
    if size(size(right), "*") == 3 then right = rgb2gray(right); end
    numDisparities = round(numDisparities); blockSize = round(blockSize);
    if numDisparities < 1 | blockSize < 3 | modulo(blockSize, 2) == 0 then error("imstereobm: invalid disparity or block size."); end
    rows = size(left, 1); cols = size(left, 2); radius = floor(blockSize / 2); disparity = zeros(rows, cols);
    leftValues = double(left); rightValues = double(right);
    for y = radius + 1:rows - radius
        for x = radius + numDisparities + 1:cols - radius
            bestCost = %inf; bestDisparity = 0;
            for d = 0:numDisparities - 1
                cost = 0;
                for yy = y - radius:y + radius
                    for xx = x - radius:x + radius
                        cost = cost + abs(leftValues(yy, xx) - rightValues(yy, xx - d));
                    end
                end
                if cost < bestCost then bestCost = cost; bestDisparity = d; end
            end
            disparity(y, x) = bestDisparity;
        end
    end
endfunction
