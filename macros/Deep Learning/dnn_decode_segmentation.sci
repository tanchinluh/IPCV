function mask = dnn_decode_segmentation(output, layout)
    // Convert class-score tensors to a label mask.
    //
    // Syntax
    //    mask = dnn_decode_segmentation(output)
    //    mask = dnn_decode_segmentation(output, layout)
    //
    // Authors
    //    Tan Chin Luh

    rhs = argn(2);
    if rhs < 1 | rhs > 2 then
        error("dnn_decode_segmentation: Wrong number of input arguments.");
    end
    if rhs < 2 then layout = "auto"; end

    dims = size(output);
    if size(dims, "*") < 3 then
        error("dnn_decode_segmentation: output must be H-by-W-by-C, W-by-H-by-C, or C-by-H-by-W.");
    end

    layout = convstr(layout, "l");
    if layout == "auto" then
        if dims(1) <= 256 & dims(2) > 8 & dims(3) > 8 then
            layout = "chw";
        elseif dims(3) <= 256 then
            layout = "whc";
        else
            layout = "whc";
        end
    end

    select layout
    case "whc" then
        w = dims(1);
        h = dims(2);
    case "hwc" then
        h = dims(1);
        w = dims(2);
    case "chw" then
        h = dims(2);
        w = dims(3);
    else
        error("dnn_decode_segmentation: layout must be ""auto"", ""whc"", ""hwc"", or ""chw"".");
    end

    mask = zeros(h, w);
    for row = 1:h
        for col = 1:w
            select layout
            case "whc" then
                scores = matrix(output(col, row, :), -1, 1);
            case "hwc" then
                scores = matrix(output(row, col, :), -1, 1);
            case "chw" then
                scores = matrix(output(:, row, col), -1, 1);
            end
            [dummy, idx] = max(scores);
            mask(row, col) = idx;
        end
    end
endfunction
