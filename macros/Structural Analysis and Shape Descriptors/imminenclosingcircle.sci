function result = imminenclosingcircle(points)
    // Estimate a minimum enclosing circle for 2D points.
    if argn(2) <> 1 | size(points, 2) <> 2 | size(points, 1) < 1 then error("imminenclosingcircle: an N-by-2 point matrix is required."); end
    n = size(points, 1); center = points(1, :); radius = 0;
    if n > 1 then
        maxDistance = -1; pair = [1 1];
        for i = 1:n - 1
            for j = i + 1:n
                distance = sum((points(i, :) - points(j, :)).^2);
                if distance > maxDistance then maxDistance = distance; pair = [i j]; end
            end
        end
        center = (points(pair(1), :) + points(pair(2), :)) / 2; radius = sqrt(maxDistance) / 2;
        for i = 1:n
            delta = points(i, :) - center; distance = sqrt(sum(delta.^2));
            if distance > radius & distance > %eps then
                newRadius = (radius + distance) / 2;
                center = center + delta * ((newRadius - radius) / distance);
                radius = newRadius;
            end
        end
    end
    result = struct("Center", center, "Radius", radius);
endfunction
