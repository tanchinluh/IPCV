function out = impadarray(image, padSize, method, padValue)
    // Pad a 2D or RGB image.
    //
    // Syntax
    //    out = impadarray(image, padSize)
    //    out = impadarray(image, padSize, method)
    //    out = impadarray(image, padSize, "constant", padValue)
    //
    // padSize is a scalar, [vertical horizontal], or [top bottom left right].
    // method is "constant" or "replicate". Constant padding defaults to zero.
    //
    // Examples
    //    image = imread(fullpath(getIPCVpath() + "/images/coins_gray.jpg"));
    //    out = impadarray(image, [30 45], "replicate");
    //    imshow(out);
    //
    // See also
    //    imcrop
    //    imresize
    //
    // Authors
    //    Tan Chin Luh
    //
    // History
    //    5.0.0: Function introduced.

    rhs = argn(2);
    if rhs < 2 | rhs > 4 then error("impadarray: Wrong number of input arguments."); end
    if size(padSize, "*") == 1 then
        top = round(padSize); bottom = top; left = top; right = top;
    elseif size(padSize, "*") == 2 then
        top = round(padSize(1)); bottom = top; left = round(padSize(2)); right = left;
    elseif size(padSize, "*") == 4 then
        top = round(padSize(1)); bottom = round(padSize(2)); left = round(padSize(3)); right = round(padSize(4));
    else
        error("impadarray: padSize must have 1, 2, or 4 elements.");
    end
    if min([top bottom left right]) < 0 then error("impadarray: padding must be non-negative."); end
    if rhs < 3 then method = "constant"; end
    method = convstr(method, "l");
    if rhs < 4 then padValue = 0; end

    dims = size(image);
    if size(dims, "*") <> 2 & size(dims, "*") <> 3 then error("impadarray: image must be 2D or 3D."); end
    rows = dims(1); cols = dims(2); channels = 1;
    if size(dims, "*") == 3 then channels = dims(3); end
    if method == "replicate" then
        rowIndex = [ones(1, top) 1:rows rows * ones(1, bottom)];
        colIndex = [ones(1, left) 1:cols cols * ones(1, right)];
        if channels == 1 then out = image(rowIndex, colIndex); else out = image(rowIndex, colIndex, :); end
    elseif method == "constant" then
        outputRows = rows + top + bottom;
        outputCols = cols + left + right;
        rowIndex = ones(1, outputRows);
        colIndex = ones(1, outputCols);
        if channels == 1 then
            out = image(rowIndex, colIndex);
        else
            out = image(rowIndex, colIndex, :);
        end
        out(:) = padValue;
        if channels == 1 then out(top + 1:top + rows, left + 1:left + cols) = image;
        else out(top + 1:top + rows, left + 1:left + cols, :) = image; end
    else
        error("impadarray: method must be constant or replicate.");
    end
endfunction
