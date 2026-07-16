function mask = imroi2mask(roi, imageSize, shape)
    // Convert rectangle, ellipse, or polygon ROI coordinates to a mask.
    if argn(2) < 2 | argn(2) > 3 then error("imroi2mask: roi and imageSize are required."); end
    if size(imageSize, "*") <> 2 then error("imroi2mask: imageSize must be [rows cols]."); end
    if argn(2) < 3 then shape = "polygon"; end
    rows = imageSize(1); cols = imageSize(2); shape = convstr(shape, "l"); mask = zeros(rows, cols) == 1;
    select shape
    case "rectangle" then
        if size(roi, "*") <> 4 then error("imroi2mask: rectangle roi must be [x y width height]."); end
        x1 = max(1, floor(roi(1))); y1 = max(1, floor(roi(2))); x2 = min(cols, ceil(roi(1) + roi(3))); y2 = min(rows, ceil(roi(2) + roi(4)));
        if x2 >= x1 & y2 >= y1 then mask(y1:y2, x1:x2) = %t; end
    case "ellipse" then
        if size(roi, "*") <> 4 then error("imroi2mask: ellipse roi must be [x y width height]."); end
        cx = roi(1) + roi(3) / 2; cy = roi(2) + roi(4) / 2; rx = max(roi(3) / 2, %eps); ry = max(roi(4) / 2, %eps);
        for y = 1:rows
            for x = 1:cols
                mask(y, x) = ((x - cx) / rx)^2 + ((y - cy) / ry)^2 <= 1;
            end
        end
    case "polygon" then
        if size(roi, 2) <> 2 then error("imroi2mask: polygon roi must be N-by-2 [x y] points."); end
        for y = 1:rows
            for x = 1:cols
                inside = %f; j = size(roi, 1);
                for i = 1:size(roi, 1)
                    if ((roi(i, 2) > y) <> (roi(j, 2) > y)) & (x < (roi(j, 1) - roi(i, 1)) * (y - roi(i, 2)) / (roi(j, 2) - roi(i, 2) + %eps) + roi(i, 1)) then inside = ~inside; end
                    j = i;
                end
                mask(y, x) = inside;
            end
        end
    else
        error("imroi2mask: shape must be rectangle, ellipse, or polygon.");
    end
endfunction
