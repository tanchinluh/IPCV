function result = imellipsefit(points)
    // Fit an ellipse from the covariance of 2D points.
    if argn(2) <> 1 | size(points, 2) <> 2 | size(points, 1) < 5 then error("imellipsefit: at least five N-by-2 points are required."); end
    x = points(:, 1); y = points(:, 2); center = [mean(x) mean(y)]; dx = x - center(1); dy = y - center(2);
    a = mean(dx .* dx); b = mean(dx .* dy); c = mean(dy .* dy); delta = sqrt((a - c) ^ 2 + 4 * b ^ 2);
    majorVariance = max((a + c + delta) / 2, 0); minorVariance = max((a + c - delta) / 2, 0); angle = 0.5 * atan(2 * b, a - c);
    result = struct("Center", center, "Axes", [2 * sqrt(2 * majorVariance) 2 * sqrt(2 * minorVariance)], "Angle", angle);
endfunction
