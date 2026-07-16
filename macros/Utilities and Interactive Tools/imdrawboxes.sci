//=============================================================================
// IPCV - Scilab Image Processing and Computer Vision toolbox
// Copyright (C) 2026  Tan Chin Luh
//=============================================================================
function out = imdrawboxes(image, boxes, rgb)
    // Draw image-space bounding boxes into an image matrix.
    //
    // Syntax
    //    out = imdrawboxes(image, boxes)
    //    out = imdrawboxes(image, boxes, rgb)
    //
    // Parameters
    //    image : Input image.
    //    boxes : N-by-4 or 4-by-N bounding boxes in [x y width height].
    //    rgb : Optional RGB color, default [0 255 0].
    //    out : Image with box borders drawn.
    //
    // Authors
    //    Tan Chin Luh

    rhs = argn(2);
    if rhs < 2 | rhs > 3 then
        error("imdrawboxes: Wrong number of input arguments.");
    end
    if rhs < 3 then rgb = [0 255 0]; end

    out = image;
    if size(boxes, "*") == 0 then
        return;
    end
    boxes = ipcv_boxes_as_rows(boxes);
    h = size(out, 1);
    w = size(out, 2);

    for i = 1:size(boxes, 1)
        box = round(boxes(i, :));
        x = max(1, min(w - 2, box(1)));
        y = max(1, min(h - 2, box(2)));
        bw = max(2, min(w - x, box(3)));
        bh = max(2, min(h - y, box(4)));
        out = rectangle(out, [x y bw bh], rgb);
    end
endfunction

function rows = ipcv_boxes_as_rows(boxes)
    if size(boxes, 2) == 4 then
        rows = boxes;
    elseif size(boxes, 1) == 4 then
        rows = boxes';
    else
        error("Bounding boxes must be N-by-4 or 4-by-N.");
    end
endfunction
