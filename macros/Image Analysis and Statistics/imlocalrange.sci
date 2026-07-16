function out = imlocalrange(image, window)
    // Return the local maximum minus local minimum intensity.
    if argn(2) < 1 | argn(2) > 2 then error("imlocalrange: invalid arguments."); end
    if argn(2) < 2 then window = [3 3]; end
    if size(window, "*") == 1 then window = [window window]; end
    if size(window, "*") <> 2 then error("imlocalrange: window must be a scalar or [rows cols]."); end
    rows = round(window(1));
    cols = round(window(2));
    if rows < 1 | cols < 1 | modulo(rows, 2) == 0 | modulo(cols, 2) == 0 then
        error("imlocalrange: window dimensions must be positive odd values.");
    end

    se = imcreatese("rect", rows, cols);
    localMax = imdilate(image, se, 1, [-1 -1], "replicate");
    localMin = imerode(image, se, 1, [-1 -1], "replicate");
    out = double(localMax) - double(localMin);
endfunction
