function detections = dnn_decode_ssd(output, imageSize, confThreshold, nmsThreshold)
    // Decode SSD-style [batch class confidence x1 y1 x2 y2] detections.
    //
    // Syntax
    //    detections = dnn_decode_ssd(output, imageSize)
    //    detections = dnn_decode_ssd(output, imageSize, confThreshold, nmsThreshold)
    //
    // Authors
    //    Tan Chin Luh

    rhs = argn(2);
    if rhs < 2 | rhs > 4 then
        error("dnn_decode_ssd: Wrong number of input arguments.");
    end
    if rhs < 3 then confThreshold = 0.25; end
    if rhs < 4 then nmsThreshold = 0.45; end

    dims = size(output);
    if size(dims, "*") >= 2 & dims(1) == 7 then
        values = matrix(double(output), 7, -1)';
    else
        values = matrix(double(output), -1, 7);
    end
    width = imageSize(1);
    height = imageSize(2);
    boxes = [];
    scores = [];
    classIds = [];

    for i = 1:size(values, 1)
        score = values(i, 3);
        if score < confThreshold then
            continue;
        end

        coords = values(i, 4:7);
        if max(abs(coords)) <= 2 then
            x1 = coords(1) * width;
            y1 = coords(2) * height;
            x2 = coords(3) * width;
            y2 = coords(4) * height;
        else
            x1 = coords(1);
            y1 = coords(2);
            x2 = coords(3);
            y2 = coords(4);
        end
        boxes($ + 1, :) = [x1, y1, max(0, x2 - x1), max(0, y2 - y1)];
        scores($ + 1, 1) = score;
        classIds($ + 1, 1) = values(i, 2);
    end

    if size(scores, "*") == 0 then
        detections.boxes = [];
        detections.scores = [];
        detections.classIds = [];
        return;
    end

    keep = dnn_nms(boxes, scores, confThreshold, nmsThreshold);
    detections.boxes = boxes(keep, :);
    detections.scores = scores(keep);
    detections.classIds = classIds(keep);
endfunction
