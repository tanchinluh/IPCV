////////////////////////////////////////////////////////////
// IPCV - Scilab Image Processing and Computer Vision toolbox
////////////////////////////////////////////////////////////
function demo_dnn_onnx()

    function model_file = ensure_opencv_zoo_model(dnn_path)
        model_name = "image_classification_mobilenetv2_2022apr.onnx";
        model_file = dnn_path + model_name;
        model_url = "https://github.com/opencv/opencv_zoo/raw/main/models/image_classification_mobilenet/" + model_name;

        if ~isfile(model_file) then
            mprintf("Downloading %s from OpenCV Zoo...\n", model_name);
            http_get(model_url, model_file, follow=%t, timeout=300);
        end

        info = fileinfo(model_file);
        if info == [] | info(1) < 1000000 then
            error("OpenCV Zoo MobileNetV2 model download failed or is incomplete: " + model_file);
        end
    endfunction

    function label_file = ensure_imagenet_labels(dnn_path)
        label_file = dnn_path + "classification_classes_ILSVRC2012.txt";
        legacy_label_file = dnn_path + "labelsimagenet1k.h";

        if isfile(label_file) then
            return;
        end

        if isfile(legacy_label_file) then
            label_file = legacy_label_file;
            return;
        end

        error("ImageNet labels are missing. Expected: " + label_file);
    endfunction

    function labels = read_imagenet_labels(label_file)
        raw_labels = mgetl(label_file);

        if grep(raw_labels, "std::vector") <> [] then
            label_lines = raw_labels(grep(raw_labels, "        """));
            labels = stripblanks(label_lines);
            labels = strsubst(labels, """,", "");
            labels = strsubst(labels, """", "");
        else
            labels = stripblanks(raw_labels);
            labels = labels(find(labels <> ""));
        end
    endfunction

    dnn_unloadallmodels();

    dnn_path = fullpath(getIPCVpath() + "/images/dnn/");
    model_file = ensure_opencv_zoo_model(dnn_path);
    label_file = ensure_imagenet_labels(dnn_path);

    net = dnn_readmodel(model_file, "", "onnx");
    net = dnn_setpreferable(net, "opencv", "cpu");

    info = dnn_info(net, [224, 224], 3);
    mprintf("\nONNX model: %s\n", info.name);
    mprintf("Output layer: %s\n", info.outputname($));
    mprintf("Layer count: %d\n", info.layercount);

    labels = read_imagenet_labels(label_file);

    // Example 1: run MobileNetV2 and map output index to ImageNet labels.
    S = imread(fullpath(getIPCVpath() + "/images/baboon.png"));
    out = dnn_forward(net, S, [224, 224], [], 1 / 127.5, [127.5 127.5 127.5], 1, 0);

    mprintf("Input size: %s\n", strcat(string(size(S)), " x "));
    mprintf("Output vector size: %s\n\n", strcat(string(size(out)), " x "));
    mprintf("Example 1 - Top 5 predictions:\n");

    scores = out(:);
    for k = 1:min(5, size(scores, "*"))
        [score, index] = max(scores);
        if index <= size(labels, "*") then
            label = labels(index);
        else
            label = "class " + string(index - 1);
        end
        mprintf("%d. %s (class %d, score %.4f)\n", k, label, index - 1, score);
        scores(index) = -%inf;
    end

    // Example 2: show the input image with the top prediction in the figure title.
    [top_score, top_index] = max(out);
    if top_index <= size(labels, "*") then
        top_label = labels(top_index);
    else
        top_label = "class " + string(top_index - 1);
    end

    scf();
    imshow(S);
    title("MobileNetV2 ONNX: " + top_label + " (" + msprintf("%.4f", top_score) + ")");

    dnn_unloadmodel(net);
endfunction
// ====================================================================
demo_dnn_onnx();
clear demo_dnn_onnx;
// ====================================================================
