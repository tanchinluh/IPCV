function keep = dnn_nms(boxes, scores, scoreThreshold, nmsThreshold)
    // Apply non-maximum suppression to bounding boxes.
    //
    // Syntax
    //    keep = dnn_nms(boxes, scores)
    //    keep = dnn_nms(boxes, scores, scoreThreshold, nmsThreshold)
    //
    // Authors
    //    Tan Chin Luh

    rhs = argn(2);
    if rhs < 2 | rhs > 4 then
        error("dnn_nms: Wrong number of input arguments.");
    end
    if rhs < 3 then scoreThreshold = 0; end
    if rhs < 4 then nmsThreshold = 0.45; end
    if size(boxes, 2) <> 4 then
        error("dnn_nms: boxes must be N-by-4 [x y width height].");
    end

    valid = find(scores(:) >= scoreThreshold);
    if size(valid, "*") == 0 then
        keep = [];
        return;
    end

    candidateScores = scores(valid);
    [dummy, order] = gsort(candidateScores, "g", "d");
    candidates = valid(order);
    keep = [];

    while size(candidates, "*") > 0
        current = candidates(1);
        keep($ + 1) = current;
        if size(candidates, "*") == 1 then
            break;
        end

        rest = candidates(2:$);
        survivors = [];
        for i = 1:size(rest, "*")
            idx = rest(i);
            if ipcv_iou(boxes(current, :), boxes(idx, :)) <= nmsThreshold then
                survivors($ + 1) = idx;
            end
        end
        candidates = survivors;
    end
endfunction

function value = ipcv_iou(a, b)
    ax1 = a(1); ay1 = a(2); ax2 = a(1) + a(3); ay2 = a(2) + a(4);
    bx1 = b(1); by1 = b(2); bx2 = b(1) + b(3); by2 = b(2) + b(4);
    ix1 = max(ax1, bx1); iy1 = max(ay1, by1);
    ix2 = min(ax2, bx2); iy2 = min(ay2, by2);
    iw = max(0, ix2 - ix1);
    ih = max(0, iy2 - iy1);
    inter = iw * ih;
    unionArea = a(3) * a(4) + b(3) * b(4) - inter;
    if unionArea <= 0 then
        value = 0;
    else
        value = inter / unionArea;
    end
endfunction
