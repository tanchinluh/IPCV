function mask = imcolormask(image, lower, upper, colorSpace)
    // Select pixels within a three-channel RGB or HSV range.
    rhs = argn(2); if rhs < 3 | rhs > 4 then error("imcolormask: image, lower, and upper bounds are required."); end
    if rhs < 4 then colorSpace = "rgb"; end
    if size(size(image), "*") <> 3 | size(image, 3) <> 3 then error("imcolormask: a three-channel image is required."); end
    if size(lower, "*") <> 3 | size(upper, "*") <> 3 then error("imcolormask: bounds must contain three values."); end
    values = im2double(image); if convstr(colorSpace, "l") == "hsv" then values = rgb2hsv(values); elseif convstr(colorSpace, "l") <> "rgb" then error("imcolormask: colorSpace must be rgb or hsv."); end
    mask = (values(:, :, 1) >= lower(1)) & (values(:, :, 1) <= upper(1)) & (values(:, :, 2) >= lower(2)) & (values(:, :, 2) <= upper(2)) & (values(:, :, 3) >= lower(3)) & (values(:, :, 3) <= upper(3));
endfunction
