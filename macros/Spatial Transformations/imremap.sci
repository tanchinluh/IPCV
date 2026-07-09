function imout = imremap(imin, mapx, mapy, method)
    // Remap an image using x/y coordinate maps.
    //
    // Syntax
    //    imout = imremap(imin, mapx, mapy)
    //    imout = imremap(imin, mapx, mapy, method)
    //
    // Authors
    //    Tan Chin Luh

    rhs = argn(2);
    if rhs < 3 | rhs > 4 then
        error("imremap: Wrong number of input arguments.");
    end
    if rhs < 4 then method = "nearest"; end
    if convstr(method, "l") <> "nearest" then
        error("imremap: Only nearest interpolation is supported by this macro implementation.");
    end
    if or(size(mapx) <> size(mapy)) then
        error("imremap: mapx and mapy must have the same size.");
    end

    rows = size(mapx, 1);
    cols = size(mapx, 2);
    dims = size(imin);
    if size(dims, "*") < 3 then channels = 1; else channels = dims(3); end
    imout = zeros(rows, cols, channels);

    for r = 1:rows
        for c = 1:cols
            x = round(mapx(r, c));
            y = round(mapy(r, c));
            if x >= 1 & x <= size(imin, 2) & y >= 1 & y <= size(imin, 1) then
                if channels == 1 then
                    imout(r, c, 1) = double(imin(y, x));
                else
                    for ch = 1:channels
                        imout(r, c, ch) = double(imin(y, x, ch));
                    end
                end
            end
        end
    end
    if channels == 1 then imout = imout(:, :, 1); end

    select typeof(imin)
    case "uint8" then
        imout = uint8(imout);
    case "uint16" then
        imout = uint16(imout);
    case "int8" then
        imout = int8(imout);
    case "int16" then
        imout = int16(imout);
    case "int32" then
        imout = int32(imout);
    end
endfunction
