function mask = dnn_decode_segmentation(output)
    // Convert class-score tensors to a label mask.
    //
    // Syntax
    //    mask = dnn_decode_segmentation(output)
    //
    // Authors
    //    Tan Chin Luh

    rhs = argn(2);
    if rhs <> 1 then
        error("dnn_decode_segmentation: Wrong number of input arguments.");
    end
    dims = size(output);
    if size(dims, "*") < 3 then
        error("dnn_decode_segmentation: output must be H-by-W-by-C.");
    end

    w = dims(1);
    h = dims(2);
    cnum = dims(3);
    mask = zeros(h, w);
    for row = 1:h
        for col = 1:w
            [dummy, idx] = max(matrix(output(col, row, :), -1, 1));
            mask(row, col) = idx;
        end
    end
endfunction
