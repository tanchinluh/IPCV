function out = imundistort(image, cameraMatrix, distortion)
    // Correct radial and tangential lens distortion with nearest-neighbor sampling.
    if argn(2) <> 3 then error("imundistort: image, camera matrix, and distortion coefficients are required."); end
    if size(cameraMatrix, 1) <> 3 | size(cameraMatrix, 2) <> 3 then error("imundistort: camera matrix must be 3-by-3."); end
    if size(distortion, "*") < 4 then error("imundistort: at least four distortion coefficients are required."); end
    rows = size(image, 1); cols = size(image, 2); dims = size(image); channels = 1;
    if size(dims, "*") == 3 then channels = dims(3); end
    fx = cameraMatrix(1, 1); fy = cameraMatrix(2, 2); cx = cameraMatrix(1, 3); cy = cameraMatrix(2, 3);
    k1 = distortion(1); k2 = distortion(2); p1 = distortion(3); p2 = distortion(4); k3 = 0; if size(distortion, "*") >= 5 then k3 = distortion(5); end
    out = zeros(rows, cols, channels);
    for y = 1:rows
        for x = 1:cols
            xn = (x - cx) / fx; yn = (y - cy) / fy; r2 = xn * xn + yn * yn; r4 = r2 * r2; r6 = r4 * r2;
            radial = 1 + k1 * r2 + k2 * r4 + k3 * r6;
            xd = xn * radial + 2 * p1 * xn * yn + p2 * (r2 + 2 * xn * xn);
            yd = yn * radial + p1 * (r2 + 2 * yn * yn) + 2 * p2 * xn * yn;
            sx = round(fx * xd + cx); sy = round(fy * yd + cy);
            if sx >= 1 & sx <= cols & sy >= 1 & sy <= rows then
                if channels == 1 then out(y, x, 1) = double(image(sy, sx)); else for ch = 1:channels; out(y, x, ch) = double(image(sy, sx, ch)); end; end
            end
        end
    end
    if channels == 1 then out = out(:, :, 1); end
endfunction
