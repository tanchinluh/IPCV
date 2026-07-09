function detections = dnn_decode_yunet(output, imageSize, confThreshold, nmsThreshold)
    // Decode YuNet-style face rows [x y w h landmarks... score].
    //
    // Syntax
    //    detections = dnn_decode_yunet(output, imageSize)
    //    detections = dnn_decode_yunet(output, imageSize, confThreshold, nmsThreshold)
    //
    // Authors
    //    Tan Chin Luh

    rhs = argn(2);
    if rhs < 2 | rhs > 4 then
        error("dnn_decode_yunet: Wrong number of input arguments.");
    end
    if rhs < 3 then confThreshold = 0.25; end
    if rhs < 4 then nmsThreshold = 0.45; end

    values = double(output);
    values = matrix(values, size(values, 1), -1);
    if size(values, 2) < 5 then
        error("dnn_decode_yunet: output must have at least [x y w h score] columns.");
    end

    width = imageSize(1);
    height = imageSize(2);
    boxes = [];
    scores = [];
    landmarks = [];

    for i = 1:size(values, 1)
        score = values(i, $);
        if score < confThreshold then
            continue;
        end

        box = values(i, 1:4);
        scaleBox = max(abs(box)) <= 2;
        if scaleBox then
            box = [box(1) * width, box(2) * height, box(3) * width, box(4) * height];
        end
        boxes($ + 1, :) = box;
        scores($ + 1, 1) = score;

        if size(values, 2) >= 14 then
            lm = values(i, 5:14);
            if scaleBox then
                for k = 1:2:10
                    lm(k) = lm(k) * width;
                    lm(k + 1) = lm(k + 1) * height;
                end
            end
            landmarks($ + 1, :) = lm;
        end
    end

    if size(scores, "*") == 0 then
        detections.boxes = [];
        detections.scores = [];
        detections.landmarks = [];
        return;
    end

    keep = dnn_nms(boxes, scores, confThreshold, nmsThreshold);
    detections.boxes = boxes(keep, :);
    detections.scores = scores(keep);
    if size(landmarks, "*") > 0 then
        detections.landmarks = landmarks(keep, :);
    else
        detections.landmarks = [];
    end
endfunction
