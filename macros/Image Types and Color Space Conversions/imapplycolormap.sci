function out = imapplycolormap(image, palette)
    // Convert a scalar image to a uint8 RGB visualization.
    rhs = argn(2);
    if rhs < 1 | rhs > 2 then error("imapplycolormap: invalid arguments."); end
    if size(size(image), "*") <> 2 then error("imapplycolormap: a 2D image is required."); end
    if rhs < 2 then palette = "jet"; end
    if typeof(palette) == "string" then
        key = convstr(palette, "l");
        select key
        case "jet" then cmap = jet(256);
        case "hot" then cmap = hot(256);
        case "gray" then cmap = graycolormap(256);
        else error("imapplycolormap: palette must be jet, hot, gray, or an N-by-3 matrix.");
        end
    else
        cmap = double(palette);
        if size(cmap, 2) <> 3 then error("imapplycolormap: palette must have three columns."); end
        if max(cmap) > 1 then cmap = cmap / 255; end
    end
    if size(cmap, 1) < 2 then error("imapplycolormap: palette must contain at least two colors."); end
    values = immat2gray(double(image));
    indices = round(values * (size(cmap, 1) - 1)) + 1;
    rows = size(image, 1); cols = size(image, 2); linearIndices = matrix(indices, -1, 1);
    out = uint8(zeros(rows, cols, 3));
    out(:, :, 1) = matrix(uint8(round(cmap(linearIndices, 1) * 255)), rows, cols);
    out(:, :, 2) = matrix(uint8(round(cmap(linearIndices, 2) * 255)), rows, cols);
    out(:, :, 3) = matrix(uint8(round(cmap(linearIndices, 3) * 255)), rows, cols);
endfunction
