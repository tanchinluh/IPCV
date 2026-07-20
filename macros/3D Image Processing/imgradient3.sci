function [magnitude, gx, gy, gz] = imgradient3(volume)
    // Return central-difference gradients for a 3D volume.
    if argn(2) <> 1 | size(size(volume), "*") <> 3 then error("imgradient3: one 3D volume is required."); end
    if typeof(volume(1)) == "constant" then values = double(volume); else values = im2double(volume); end; rows = size(values, 1); cols = size(values, 2); slices = size(values, 3);
    gx = zeros(rows, cols, slices); gy = gx; gz = gx;
    if rows > 2 then gy(2:$-1, :, :) = (values(3:$, :, :) - values(1:$-2, :, :)) / 2; end
    if cols > 2 then gx(:, 2:$-1, :) = (values(:, 3:$, :) - values(:, 1:$-2, :)) / 2; end
    if slices > 2 then gz(:, :, 2:$-1) = (values(:, :, 3:$) - values(:, :, 1:$-2)) / 2; end
    magnitude = sqrt(gx .* gx + gy .* gy + gz .* gz);
endfunction
