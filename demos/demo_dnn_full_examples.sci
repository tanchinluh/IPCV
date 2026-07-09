////////////////////////////////////////////////////////////
// IPCV - Scilab Image Processing and Computer Vision toolbox
////////////////////////////////////////////////////////////
function demo_dnn_full_examples(selection, show_output)
    rhs = argn(2);
    if rhs < 1 then
        selection = "all";
    end
    if rhs < 2 then
        show_output = %t;
    end
    selection = convstr(selection, "l");

    function file = ensure_download(folder, name, url, min_bytes)
        file = folder + name;
        if ~isfile(file) then
            mprintf("Downloading %s...\n", name);
            http_get(url, file, follow=%t, timeout=900);
        end

        info = fileinfo(file);
        if info == [] | info(1) < min_bytes then
            error("Download failed or incomplete: " + file);
        end
    endfunction

    function labels = read_plain_labels(file)
        labels = stripblanks(mgetl(file));
        labels = labels(find(labels <> ""));
    endfunction

    function labels = read_quoted_labels(file)
        raw = mgetl(file);
        labels = [];
        for i = 1:size(raw, "*")
            q = strindex(raw(i), """");
            if size(q, "*") >= 2 then
                labels($ + 1, 1) = part(raw(i), q(1) + 1:q(2) - 1);
            end
        end
    endfunction

    function rows = dnn_tensor_rows(output, col_count)
        dims = size(output);
        if size(dims, "*") >= 2 & dims(1) == col_count then
            rows = matrix(output, col_count, -1)';
        else
            rows = matrix(output, -1, col_count);
        end
    endfunction

    function detections = decode_yolox(output, image_size, conf_threshold, nms_threshold)
        rows = dnn_tensor_rows(output, 85);
        input_w = 640;
        input_h = 640;
        boxes = [];
        scores = [];
        class_ids = [];
        row_index = 1;

        for stride = [8 16 32]
            grid_h = input_h / stride;
            grid_w = input_w / stride;
            for gy = 0:grid_h - 1
                for gx = 0:grid_w - 1
                    if row_index > size(rows, 1) then
                        break;
                    end

                    class_scores = rows(row_index, 6:$);
                    [class_score, class_index] = max(class_scores);
                    score = rows(row_index, 5) * class_score;
                    if score >= conf_threshold then
                        cx = (rows(row_index, 1) + gx) * stride;
                        cy = (rows(row_index, 2) + gy) * stride;
                        bw = exp(rows(row_index, 3)) * stride;
                        bh = exp(rows(row_index, 4)) * stride;
                        x = (cx - bw / 2) * image_size(1) / input_w;
                        y = (cy - bh / 2) * image_size(2) / input_h;
                        boxes($ + 1, :) = [x y bw * image_size(1) / input_w bh * image_size(2) / input_h];
                        scores($ + 1, 1) = score;
                        class_ids($ + 1, 1) = class_index;
                    end
                    row_index = row_index + 1;
                end
            end
        end

        if size(scores, "*") == 0 then
            detections.boxes = [];
            detections.scores = [];
            detections.classIds = [];
            return;
        end

        keep = dnn_nms(boxes, scores, conf_threshold, nms_threshold);
        detections.boxes = boxes(keep, :);
        detections.scores = scores(keep);
        detections.classIds = class_ids(keep);
    endfunction

    function detections = decode_ssd_output(output, image_size, conf_threshold, nms_threshold)
        values = dnn_tensor_rows(output, 7);
        width = image_size(1);
        height = image_size(2);
        boxes = [];
        scores = [];
        class_ids = [];

        for i = 1:size(values, 1)
            score = values(i, 3);
            if score < conf_threshold then
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
            class_ids($ + 1, 1) = values(i, 2);
        end

        if size(scores, "*") == 0 then
            detections.boxes = [];
            detections.scores = [];
            detections.classIds = [];
            return;
        end

        keep = dnn_nms(boxes, scores, conf_threshold, nms_threshold);
        detections.boxes = boxes(keep, :);
        detections.scores = scores(keep);
        detections.classIds = class_ids(keep);
    endfunction

    function mask = decode_segmentation_output(output)
        dims = size(output);
        if size(dims, "*") < 3 then
            error("decode_segmentation_output: output must be W-by-H-by-C.");
        end

        w = dims(1);
        h = dims(2);
        mask = zeros(h, w);
        for row = 1:h
            for col = 1:w
                [dummy, idx] = max(matrix(output(col, row, :), -1, 1));
                mask(row, col) = idx;
            end
        end
    endfunction

    function mask = clean_binary_mask(mask)
        se = imcreatese("ellipse", 5, 5);
        mask = uint8(double(mask > 0));
        mask = imclose(mask, se);
        mask = imopen(mask, se);
        mask = uint8(double(mask > 0));
    endfunction

    function label = detection_label(class_id, score, labels)
        class_id = round(class_id);
        label = "class " + string(class_id);
        if class_id >= 1 & class_id <= size(labels, "*") then
            label = labels(class_id);
        elseif class_id + 1 >= 1 & class_id + 1 <= size(labels, "*") then
            label = labels(class_id + 1);
        end
        label = label + " " + msprintf("%.2f", score);
    endfunction

    function out = draw_detections(image, detections, labels, figure_title, show_output)
        out = image;
        h = size(image, 1);
        w = size(image, 2);
        if size(detections.scores, "*") == 0 then
            if show_output then
                scf();
                imshow(out);
                title(figure_title + ": no detection");
            end
            return;
        end

        count = min(8, size(detections.scores, "*"));
        label_text = [];
        label_x = [];
        label_y = [];
        for i = 1:count
            box = round(detections.boxes(i, :));
            x = max(1, min(w - 2, box(1)));
            y = max(1, min(h - 2, box(2)));
            bw = max(2, min(w - x, box(3)));
            bh = max(2, min(h - y, box(4)));
            out = rectangle(out, [x y bw bh], [0 255 0]);
            label_text($ + 1, 1) = detection_label(detections.classIds(i), detections.scores(i), labels);
            label_x($ + 1, 1) = x;
            if y > 20 then
                label_y($ + 1, 1) = y - 18;
            else
                label_y($ + 1, 1) = y + 6;
            end
        end

        if show_output then
            scf();
            imshow(out);
            for i = 1:size(label_text, "*")
                xstring(label_x(i), label_y(i), label_text(i));
                t = get("hdl");
                t.font_size = 2;
                t.font_style = 6;
                t.font_foreground = color("yellow");
                t.box = "on";
            end
            title(figure_title);
        end
    endfunction

    function show_classification_example(dnn_path, show_output)
        model = ensure_download(dnn_path, "image_classification_mobilenetv2_2022apr.onnx", ..
            "https://github.com/opencv/opencv_zoo/raw/main/models/image_classification_mobilenet/image_classification_mobilenetv2_2022apr.onnx", 1000000);
        label_file = ensure_download(dnn_path, "labelsimagenet1k.h", ..
            "https://raw.githubusercontent.com/opencv/opencv_zoo/main/models/image_classification_mobilenet/labelsimagenet1k.h", 1000);
        image_file = ensure_download(dnn_path, "fruits.jpg", ..
            "https://raw.githubusercontent.com/opencv/opencv/master/samples/data/fruits.jpg", 1000);

        labels = read_quoted_labels(label_file);
        image = imread(image_file);
        net = dnn_readmodel(model, "", "onnx");
        net = dnn_setpreferable(net, "opencv", "cpu");
        scores = dnn_forward(net, image, [224 224], [], 1 / 255, [123.675 116.28 103.53], 1, 0, [0.229 0.224 0.225]);
        result = dnn_decode_classification(scores, labels, 5, %f);

        label = result.labels(1) + " " + msprintf("%.3f", result.scores(1));
        mprintf("Classification - MobileNetV2: %s\n", label);
        if show_output then
            scf();
            imshow(image);
            xstring(12, 20, label);
            t = get("hdl");
            t.font_size = 4;
            t.font_style = 6;
            t.font_foreground = color("yellow");
            t.box = "on";
            title("Classification - MobileNetV2");
        end
        dnn_unloadmodel(net);
    endfunction

    function show_yolox_example(dnn_path, show_output)
        model = ensure_download(dnn_path, "object_detection_yolox_2022nov.onnx", ..
            "https://github.com/opencv/opencv_zoo/raw/main/models/object_detection_yolox/object_detection_yolox_2022nov.onnx", 1000000);
        label_file = ensure_download(dnn_path, "object_detection_classes_yolo.txt", ..
            "https://raw.githubusercontent.com/opencv/opencv/master/samples/data/dnn/object_detection_classes_yolo.txt", 100);
        image_file = ensure_download(dnn_path, "dog416.png", ..
            "https://raw.githubusercontent.com/opencv/opencv_extra/master/testdata/dnn/dog416.png", 1000);

        labels = read_plain_labels(label_file);
        image = imread(image_file);
        net = dnn_readmodel(model, "", "onnx");
        net = dnn_setpreferable(net, "opencv", "cpu");
        output = dnn_forward(net, image, [640 640], [], 1, [0 0 0], 0, 0, [1 1 1]);
        detections = decode_yolox(output, [size(image, 2) size(image, 1)], 0.35, 0.50);
        mprintf("YOLOX Object Detection: %d detection(s)\n", size(detections.scores, "*"));
        draw_detections(image, detections, labels, "YOLOX Object Detection", show_output);
        dnn_unloadmodel(net);
    endfunction

    function show_ssd_example(dnn_path, show_output)
        model = ensure_download(dnn_path, "opencv_face_detector_uint8.pb", ..
            "https://github.com/opencv/opencv_3rdparty/raw/dnn_samples_face_detector_20180220_uint8/opencv_face_detector_uint8.pb", 1000000);
        model_index = ensure_download(dnn_path, "opencv_face_detector.pbtxt", ..
            "https://raw.githubusercontent.com/opencv/opencv/master/samples/dnn/face_detector/opencv_face_detector.pbtxt", 1000);
        image_file = ensure_download(dnn_path, "lena.jpg", ..
            "https://raw.githubusercontent.com/opencv/opencv/master/samples/data/lena.jpg", 1000);

        labels = ["face"];
        image = imread(image_file);
        net = dnn_readmodel(model, model_index, "tensorflow");
        net = dnn_setpreferable(net, "opencv", "cpu");
        output = dnn_forward(net, image, [300 300], [], 1, [104 177 123], 0, 0, [1 1 1]);
        detections = decode_ssd_output(output, [size(image, 2) size(image, 1)], 0.50, 0.45);
        mprintf("SSD Face Detection: %d detection(s)\n", size(detections.scores, "*"));
        draw_detections(image, detections, labels, "SSD Face Detection", show_output);
        dnn_unloadmodel(net);
    endfunction

    function show_segmentation_example(dnn_path, show_output)
        model = ensure_download(dnn_path, "human_segmentation_pphumanseg_2023mar.onnx", ..
            "https://github.com/opencv/opencv_zoo/raw/main/models/human_segmentation_pphumanseg/human_segmentation_pphumanseg_2023mar.onnx", 1000000);
        model_info_file = ensure_download(dnn_path, "human_segmentation_pphumanseg_README.md", ..
            "https://raw.githubusercontent.com/opencv/opencv_zoo/main/models/human_segmentation_pphumanseg/README.md", 100);
        image_file = ensure_download(dnn_path, "messi5.jpg", ..
            "https://raw.githubusercontent.com/opencv/opencv/master/samples/data/messi5.jpg", 1000);

        image = imread(image_file);
        net = dnn_readmodel(model, "", "onnx");
        net = dnn_setpreferable(net, "opencv", "cpu");
        output = dnn_forward(net, image, [192 192], [], 1 / 255, [127.5 127.5 127.5], 1, 0, [0.5 0.5 0.5]);
        mask = decode_segmentation_output(output);
        mask = uint8(double(imresize(mask > 1, [size(image, 1) size(image, 2)], "nearest")));
        mask = clean_binary_mask(mask);

        overlay = image;
        alpha = 0.35;
        mask_alpha = double(mask) * alpha;
        overlay(:, :, 1) = uint8(double(image(:, :, 1)) .* (1 - mask_alpha) + 255 * mask_alpha);
        overlay(:, :, 2) = uint8(double(image(:, :, 2)) .* (1 - mask_alpha));
        overlay(:, :, 3) = uint8(double(image(:, :, 3)) .* (1 - mask_alpha));

        boundary = imgradient(mask, imcreatese("ellipse", 3, 3)) > 0;
        overlay(:, :, 1) = uint8(double(overlay(:, :, 1)) .* double(~boundary) + 255 * double(boundary));
        overlay(:, :, 2) = uint8(double(overlay(:, :, 2)) .* double(~boundary) + 80 * double(boundary));
        overlay(:, :, 3) = uint8(double(overlay(:, :, 3)) .* double(~boundary));
        mprintf("Segmentation - PP-HumanSeg: mask size %d x %d\n", size(mask, 1), size(mask, 2));
        if show_output then
            scf();
            imshow(overlay);
            xstring(12, 20, "human segmentation");
            t = get("hdl");
            t.font_size = 4;
            t.font_style = 6;
            t.font_foreground = color("yellow");
            t.box = "on";
            title("Segmentation - PP-HumanSeg");
        end
        dnn_unloadmodel(net);
    endfunction

    dnn_unloadallmodels();
    dnn_path = fullpath(getIPCVpath() + "/images/dnn/");

    if selection == "all" | selection == "classification" then
        show_classification_example(dnn_path, show_output);
    end
    if selection == "all" | selection == "yolox" | selection == "yolo" then
        show_yolox_example(dnn_path, show_output);
    end
    if selection == "all" | selection == "ssd" then
        show_ssd_example(dnn_path, show_output);
    end
    if selection == "all" | selection == "segmentation" then
        show_segmentation_example(dnn_path, show_output);
    end
endfunction

// ====================================================================
demo_dnn_full_examples();
clear demo_dnn_full_examples;
// ====================================================================
