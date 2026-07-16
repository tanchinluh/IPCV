function out = imordfilt(image, order, window)
    // Apply an order-statistic filter to a grayscale image.
    //
    // Syntax
    //    out = imordfilt(image, order, window)
    //
    // order 1 is the minimum and order m*n is the maximum. Window dimensions
    // must be positive odd integers. Replicate padding is used at the border.
    // Integer input images return the same integer class as the input.
    //
    // Examples
    //    image = imread(fullpath(getIPCVpath() + "/images/coins_gray.jpg"));
    //    out = imordfilt(image, 7, [3 3]);
    //    imshow(out);
    //
    // See also
    //    immedian
    //    imcolfilt
    //
    // Authors
    //    Tan Chin Luh
    //
    // History
    //    5.0.0: Function introduced.

    if argn(2) <> 3 then error("imordfilt: image, order, and window are required."); end
    if size(size(image), "*") <> 2 then error("imordfilt: image must be grayscale."); end
    if size(window, "*") <> 2 then error("imordfilt: window must be [rows cols]."); end
    m = round(window(1)); n = round(window(2));
    if m < 1 | n < 1 | modulo(m, 2) == 0 | modulo(n, 2) == 0 then error("imordfilt: window dimensions must be positive odd values."); end
    count = m * n;
    if order < 1 | order > count | order <> round(order) then error("imordfilt: order is outside the window."); end
    inputType = typeof(image(1));
    padded = impadarray(image, [floor(m / 2) floor(n / 2)], "replicate");
    out = zeros(size(image, 1), size(image, 2));
    for r = 1:size(image, 1)
        for c = 1:size(image, 2)
            values = matrix(padded(r:r + m - 1, c:c + n - 1), -1, 1);
            values = gsort(values, "g", "i");
            out(r, c) = values(order);
        end
    end

    select inputType
    case "uint8" then
        out = uint8(round(min(max(out, 0), 255)));
    case "uint16" then
        out = uint16(round(min(max(out, 0), 65535)));
    case "int8" then
        out = int8(round(min(max(out, -128), 127)));
    case "int16" then
        out = int16(round(min(max(out, -32768), 32767)));
    case "int32" then
        out = int32(round(out));
    case "uint32" then
        out = uint32(round(max(out, 0)));
    end
endfunction
