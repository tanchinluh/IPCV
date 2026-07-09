//=============================================================================
// IPCV - Scilab Image Processing and Computer Vision toolbox
// Copyright (C) 2026  Tan Chin Luh
//=============================================================================
function imshow_detections(image, detections, labels, rgb, titleText)
    // Display an image with detection boxes and optional labels.
    //
    // Syntax
    //    imshow_detections(image, detections)
    //    imshow_detections(image, detections, labels, rgb, titleText)
    //
    // Parameters
    //    image : Input image.
    //    detections : Structure with boxes, scores, and classIds fields.
    //    labels : Optional label vector.
    //    rgb : Optional RGB box color, default [0 255 0].
    //    titleText : Optional figure title.
    //
    // Authors
    //    Tan Chin Luh

    rhs = argn(2);
    if rhs < 2 | rhs > 5 then
        error("imshow_detections: Wrong number of input arguments.");
    end
    if rhs < 3 then labels = []; end
    if rhs < 4 then rgb = [0 255 0]; end
    if rhs < 5 then titleText = "Detections"; end

    out = image;
    if isfield(detections, "boxes") & size(detections.boxes, "*") > 0 then
        out = imdrawboxes(image, detections.boxes, rgb);
    end

    scf();
    imshow(out);
    if titleText <> "" then
        title(titleText);
    end

    if ~isfield(detections, "boxes") | size(detections.boxes, "*") == 0 then
        return;
    end

    boxes = ipcv_detections_boxes_as_rows(detections.boxes);
    h = size(image, 1);
    count = size(boxes, 1);
    for i = 1:count
        box = round(boxes(i, :));
        imageX = max(1, box(1));
        imageY = max(1, box(2));
        if imageY > 20 then
            imageLabelY = imageY - 18;
        else
            imageLabelY = imageY + 6;
        end
        graphY = h - imageLabelY;
        xstring(imageX, graphY, ipcv_detection_label(detections, i, labels));
        txt = get("hdl");
        txt.font_size = 2;
        txt.font_style = 6;
        txt.font_foreground = color("yellow");
        txt.box = "on";
    end
endfunction

function rows = ipcv_detections_boxes_as_rows(boxes)
    if size(boxes, 2) == 4 then
        rows = boxes;
    elseif size(boxes, 1) == 4 then
        rows = boxes';
    else
        error("Detection boxes must be N-by-4 or 4-by-N.");
    end
endfunction

function text = ipcv_detection_label(detections, index, labels)
    classId = [];
    score = [];
    if isfield(detections, "classIds") & size(detections.classIds, "*") >= index then
        classId = round(detections.classIds(index));
    end
    if isfield(detections, "scores") & size(detections.scores, "*") >= index then
        score = detections.scores(index);
    end

    if size(classId, "*") == 0 then
        text = "object";
    elseif size(labels, "*") > 0 & classId >= 1 & classId <= size(labels, "*") then
        text = labels(classId);
    elseif size(labels, "*") > 0 & classId + 1 >= 1 & classId + 1 <= size(labels, "*") then
        text = labels(classId + 1);
    else
        text = "class " + string(classId);
    end

    if size(score, "*") > 0 then
        text = text + " " + msprintf("%.2f", score);
    end
endfunction
