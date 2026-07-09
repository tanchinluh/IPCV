function detections = dnn_decode_nanodet(outputs, imageSize, inputSize, confThreshold, nmsThreshold, strides, regMax)
    // Decode OpenCV Zoo NanoDet outputs into boxes, scores, and class ids.
    //
    // Syntax
    //    detections = dnn_decode_nanodet(outputs, imageSize)
    //    detections = dnn_decode_nanodet(outputs, imageSize, inputSize, confThreshold, nmsThreshold)
    //
    // Authors
    //    Tan Chin Luh

    rhs = argn(2);
    if rhs < 2 | rhs > 7 then
        error("dnn_decode_nanodet: Wrong number of input arguments.");
    end
    if rhs < 3 | isempty(inputSize) then inputSize = [416 416]; end
    if rhs < 4 | isempty(confThreshold) then confThreshold = 0.35; end
    if rhs < 5 | isempty(nmsThreshold) then nmsThreshold = 0.60; end
    if rhs < 6 | isempty(strides) then strides = [8 16 32 64]; end
    if rhs < 7 | isempty(regMax) then regMax = 7; end

    if typeof(outputs) <> "list" then
        error("dnn_decode_nanodet: outputs must be a list alternating class-score and bbox-regression tensors.");
    end
    if modulo(length(outputs), 2) <> 0 then
        error("dnn_decode_nanodet: outputs must contain class/bbox pairs.");
    end

    boxes = [];
    scores = [];
    classIds = [];
    project = 0:regMax;
    scaleX = imageSize(1) / inputSize(1);
    scaleY = imageSize(2) / inputSize(2);
    pairCount = length(outputs) / 2;

    for level = 1:pairCount
        stride = strides(min(level, size(strides, "*")));
        clsScore = double(outputs(2 * level - 1));
        bboxPred = double(outputs(2 * level));
        clsScore = matrix(clsScore, size(clsScore, 1), -1);
        bboxPred = matrix(bboxPred, size(bboxPred, 1), -1);

        if size(bboxPred, 2) <> 4 * (regMax + 1) then
            error("dnn_decode_nanodet: bbox tensor width must be 4 * (regMax + 1).");
        end

        featW = round(inputSize(1) / stride);
        featH = round(inputSize(2) / stride);
        anchorCount = min(size(clsScore, 1), size(bboxPred, 1));
        anchorCount = min(anchorCount, featW * featH);

        for anchor = 1:anchorCount
            classScores = clsScore(anchor, :);
            [score, classIndex] = max(classScores);
            if score < confThreshold then
                continue;
            end

            gridX = modulo(anchor - 1, featW);
            gridY = floor((anchor - 1) / featW);
            cx = gridX * stride + 0.5 * (stride - 1);
            cy = gridY * stride + 0.5 * (stride - 1);
            distances = zeros(1, 4);

            for side = 1:4
                first = (side - 1) * (regMax + 1) + 1;
                last = side * (regMax + 1);
                prob = dnn_softmax(bboxPred(anchor, first:last)');
                distances(side) = sum(prob(:)' .* project) * stride;
            end

            x1 = max(0, cx - distances(1));
            y1 = max(0, cy - distances(2));
            x2 = min(inputSize(1), cx + distances(3));
            y2 = min(inputSize(2), cy + distances(4));
            boxes($ + 1, :) = [x1 * scaleX, y1 * scaleY, (x2 - x1) * scaleX, (y2 - y1) * scaleY];
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
