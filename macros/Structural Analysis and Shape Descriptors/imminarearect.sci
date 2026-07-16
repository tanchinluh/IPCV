function result = imminarearect(points)
    // Estimate the minimum-area rotated rectangle around 2D points.
    if argn(2) <> 1 | size(points, 2) <> 2 | size(points, 1) < 2 then error("imminarearect: an N-by-2 point matrix is required."); end
    n = size(points, 1); bestArea = %inf; bestAngle = 0; bestBounds = [0 0 0 0];
    for i = 1:n - 1
        for j = i + 1:n
            dx = points(j, 1) - points(i, 1); dy = points(j, 2) - points(i, 2);
            if abs(dx) < %eps then angle = %pi / 2; else angle = atan(dy / dx); end
            ca = cos(angle); sa = sin(angle);
            u = points(:, 1) * ca + points(:, 2) * sa;
            v = -points(:, 1) * sa + points(:, 2) * ca;
            umin = min(u); umax = max(u); vmin = min(v); vmax = max(v); area = (umax - umin) * (vmax - vmin);
            if area < bestArea then bestArea = area; bestAngle = angle; bestBounds = [umin umax vmin vmax]; end
        end
    end
    ca = cos(bestAngle); sa = sin(bestAngle); umin = bestBounds(1); umax = bestBounds(2); vmin = bestBounds(3); vmax = bestBounds(4);
    cornersUV = [umin vmin; umax vmin; umax vmax; umin vmax];
    corners = zeros(4, 2);
    corners(:, 1) = cornersUV(:, 1) * ca - cornersUV(:, 2) * sa;
    corners(:, 2) = cornersUV(:, 1) * sa + cornersUV(:, 2) * ca;
    result = struct("Center", mean(corners, "r"), "Size", [umax - umin vmax - vmin], "Angle", bestAngle * 180 / %pi, "Area", bestArea, "Corners", corners);
endfunction
