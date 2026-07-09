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

    function mask = clean_binary_mask(mask)
        se = imcreatese("ellipse", 5, 5);
        mask = uint8(double(mask > 0));
        mask = imclose(mask, se);
        mask = imopen(mask, se);
        mask = uint8(double(mask > 0));
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
        detections = dnn_decode_yolo(output, [size(image, 2) size(image, 1)], 0.35, 0.50, "yolox", [640 640], [8 16 32]);
        mprintf("YOLOX Object Detection: %d detection(s)\n", size(detections.scores, "*"));
        if show_output then
            imshow_detections(image, detections, labels, [0 255 0], "YOLOX Object Detection");
        end
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
        detections = dnn_decode_ssd(output, [size(image, 2) size(image, 1)], 0.50, 0.45);
        mprintf("SSD Face Detection: %d detection(s)\n", size(detections.scores, "*"));
        if show_output then
            imshow_detections(image, detections, labels, [0 255 0], "SSD Face Detection");
        end
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
        mask = dnn_decode_segmentation(output, "whc");
        mask = uint8(double(imresize(mask > 1, [size(image, 1) size(image, 2)], "nearest")));
        mask = clean_binary_mask(mask);
        mprintf("Segmentation - PP-HumanSeg: mask size %d x %d\n", size(mask, 1), size(mask, 2));
        if show_output then
            imshow_segmentation(image, mask, [255 0 0], 0.35, "Segmentation - PP-HumanSeg");
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
