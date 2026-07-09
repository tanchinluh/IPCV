function detections = dnn_decode_yolo(output, imageSize, confThreshold, nmsThreshold)
    // Decode a simple YOLO-style [cx cy w h objectness class...] output matrix.
    //
    // Syntax
    //    detections = dnn_decode_yolo(output, imageSize)
    //    detections = dnn_decode_yolo(output, imageSize, confThreshold, nmsThreshold)
    //
    // Authors
    //    Tan Chin Luh

    rhs = argn(2);
    if rhs < 2 | rhs > 4 then
        error("dnn_decode_yolo: Wrong number of input arguments.");
    end
    if rhs < 3 then confThreshold = 0.25; end
    if rhs < 4 then nmsThreshold = 0.45; end
    if size(output, 2) < 6 then
        error("dnn_decode_yolo: output must have [cx cy w h objectness class...] columns.");
    end

    width = imageSize(1);
    height = imageSize(2);
    boxes = [];
    scores = [];
    classIds = [];
    for i = 1:size(output, 1)
        classScores = output(i, 6:$);
        [classScore, classIndex] = max(classScores);
        score = output(i, 5) * classScore;
        if score >= confThreshold then
            cx = output(i, 1) * width;
            cy = output(i, 2) * height;
            w = output(i, 3) * width;
            h = output(i, 4) * height;
            boxes($ + 1, :) = [cx - w / 2, cy - h / 2, w, h];
            scores($ + 1, 1) = score;
            classIds($ + 1, 1) = classIndex;
        end
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
