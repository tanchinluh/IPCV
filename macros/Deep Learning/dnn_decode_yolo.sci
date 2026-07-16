function detections = dnn_decode_yolo(output, imageSize, confThreshold, nmsThreshold, decoderType, inputSize, strides)
    // Decode YOLO-style detection output.
    //
    // Syntax
    //    detections = dnn_decode_yolo(output, imageSize)
    //    detections = dnn_decode_yolo(output, imageSize, confThreshold, nmsThreshold)
    //    detections = dnn_decode_yolo(output, imageSize, confThreshold, nmsThreshold, "yolox", inputSize, strides)
    //
    // Authors
    //    Tan Chin Luh

    rhs = argn(2);
    if rhs < 2 | rhs > 7 then
        error("dnn_decode_yolo: Wrong number of input arguments.");
    end
    if rhs < 3 then confThreshold = 0.25; end
    if rhs < 4 then nmsThreshold = 0.45; end
    if rhs < 5 then decoderType = "simple"; end
    if rhs < 6 then inputSize = [640 640]; end
    if rhs < 7 then strides = [8 16 32]; end

    width = imageSize(1);
    height = imageSize(2);
    boxes = [];
    scores = [];
    classIds = [];
    decoderType = convstr(decoderType, "l");
    if decoderType == "yolox" then
        rows = ipcv_dnn_rows(output, 85);
        if size(rows, 2) < 6 then
            error("dnn_decode_yolo: output must have [cx cy w h objectness class...] columns.");
        end
        inputWidth = inputSize(1);
        inputHeight = inputSize(2);
        rowIndex = 1;
        for stride = strides
            if rowIndex > size(rows, 1) then
                break;
            end
            gridHeight = inputHeight / stride;
            gridWidth = inputWidth / stride;
            for gy = 0:gridHeight - 1
                if rowIndex > size(rows, 1) then
                    break;
                end
                for gx = 0:gridWidth - 1
                    if rowIndex > size(rows, 1) then
                        break;
                    end
                    classScores = rows(rowIndex, 6:$);
                    [classScore, classIndex] = max(classScores);
                    score = rows(rowIndex, 5) * classScore;
                    if score >= confThreshold then
                        cx = (rows(rowIndex, 1) + gx) * stride;
                        cy = (rows(rowIndex, 2) + gy) * stride;
                        boxWidth = exp(rows(rowIndex, 3)) * stride;
                        boxHeight = exp(rows(rowIndex, 4)) * stride;
                        boxes($ + 1, :) = [(cx - boxWidth / 2) * width / inputWidth, ..
                                           (cy - boxHeight / 2) * height / inputHeight, ..
                                           boxWidth * width / inputWidth, ..
                                           boxHeight * height / inputHeight];
                        scores($ + 1, 1) = score;
                        classIds($ + 1, 1) = classIndex;
                    end
                    rowIndex = rowIndex + 1;
                end
            end
        end
    elseif decoderType == "simple" | decoderType == "yolo" then
        if size(output, 2) >= 6 then
            rows = double(output);
        elseif size(output, 1) >= 6 then
            rows = double(output');
        else
            error("dnn_decode_yolo: output must have [cx cy w h objectness class...] columns.");
        end
        for i = 1:size(rows, 1)
            classScores = rows(i, 6:$);
            [classScore, classIndex] = max(classScores);
            score = rows(i, 5) * classScore;
            if score >= confThreshold then
                cx = rows(i, 1) * width;
                cy = rows(i, 2) * height;
                w = rows(i, 3) * width;
                h = rows(i, 4) * height;
                boxes($ + 1, :) = [cx - w / 2, cy - h / 2, w, h];
                scores($ + 1, 1) = score;
                classIds($ + 1, 1) = classIndex;
            end
        end
    else
        error("dnn_decode_yolo: Unsupported decoder type.");
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

function rows = ipcv_dnn_rows(output, colCount)
    dims = size(output);
    if size(dims, "*") >= 2 & dims(1) == colCount then
        rows = matrix(output, colCount, -1)';
    else
        rows = matrix(output, -1, colCount);
    end
endfunction
