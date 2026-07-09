function script_file = ipcv_opencv_zoo_gui_generate_sample_script(model_file, model_name, group_name, model_path, model_url, target_dir, asset_files)
    if argn(2) < 7 then
        asset_files = emptystr(0, 1);
    end

    base_name = model_name;
    if length(base_name) > 5 then
        if ipcv_opencv_zoo_gui_ends_with(convstr(base_name, "l"), ".onnx") then
            base_name = part(base_name, 1:length(base_name) - 5);
        end
    end

    script_name = ipcv_opencv_zoo_gui_sanitize_filename(base_name) + "_sample.sce";
    script_file = fullfile(target_dir, script_name);

    model_file_script = strsubst(model_file, "\", "/");
    loader_file = strsubst(fullpath(getIPCVpath() + "/loader.sce"), "\", "/");
    zoo_model_page = "https://github.com/opencv/opencv_zoo/tree/main/models/" + group_name;

    companion_lines = emptystr(0, 1);
    for i = 1:size(asset_files, "*")
        companion_lines($ + 1) = "    """ + strsubst(asset_files(i), "\", "/") + """;";
    end
    if size(companion_lines, "*") == 0 then
        companion_block = [
            "companion_files = [];";
            "label_file = """";"
        ];
    else
        companion_block = [
            "companion_files = [";
            companion_lines;
            "];";
            "label_file = """";";
            "for k = 1:size(companion_files, ""*"")";
            "    lower_name = convstr(companion_files(k), ""l"");";
            "    if strindex(lower_name, ""label"") <> [] | strindex(lower_name, ""class"") <> [] | strindex(lower_name, "".names"") <> [] then";
            "        label_file = companion_files(k);";
            "        break;";
            "    end";
            "end";
            "if label_file <> """" then";
            "    mprintf(""Companion label file: %s\n"", label_file);";
            "end"
        ];
    end

    lines = [
        "// IPCV OpenCV Zoo sample script";
        "// Model: " + model_name;
        "// Category: " + group_name;
        "// OpenCV Zoo path: " + model_path;
        "// Download URL: " + model_url;
        "// Model documentation: " + zoo_model_page;
        "";
        "if ~exists(""getIPCVpath"") then";
        "    exec(""" + loader_file + """, -1);";
        "end";
        "";
        "model_file = """ + model_file_script + """;";
        "model_name = """ + model_name + """;";
        "group_name = """ + group_name + """;";
        "if ~isfile(model_file) then";
        "    error(""Model file not found: "" + model_file);";
        "end";
        "";
        "model_info = dnn_zoo_modelinfo(model_name, group_name);";
        "mprintf(""Model task: %s\n"", model_info.task);";
        "mprintf(""Suggested input: %d x %d\n"", model_info.inputSize(1), model_info.inputSize(2));";
        "mprintf(""Sample decoder: %s\n"", model_info.decoder);";
        "mprintf(""Notes: %s\n"", model_info.notes);";
        "";
        companion_block;
        "";
        "dnn_unloadallmodels();";
        "net = dnn_readmodel(model_file, """", ""onnx"");";
        "net = dnn_setpreferable(net, ""opencv"", ""cpu"");";
        "";
        "info = dnn_info(net);";
        "mprintf(""Loaded ONNX model: %s\n"", model_file);";
        "mprintf(""Layer count: %d\n"", info.layercount);";
        "if size(info.outputname, ""*"") > 0 then";
        "    mprintf(""Output layers:\n"");";
        "    disp(info.outputname);";
        "end";
        "";
        "// This sample uses IPCV best known defaults for common OpenCV Zoo families.";
        "// Check the model documentation link above when accuracy or exact post-processing matters.";
        "input_image = fullpath(getIPCVpath() + ""/images/baboon.png"");";
        "if isfile(input_image) then";
        "    try";
        "        S = imread(input_image);";
        "        out = dnn_forward(net, S, model_info.inputSize, [], model_info.scale, model_info.mean, model_info.swapRB, model_info.crop);";
        "        mprintf(""Forward output size: %s\n"", strcat(string(size(out)), "" x ""));";
        "        select model_info.decoder";
        "        case ""classification"" then";
        "            labels = [];";
        "            if label_file <> """" then";
        "                labels = mgetl(label_file);";
        "            end";
        "            prediction = dnn_decode_classification(out, labels, 5, %t);";
        "            disp(prediction);";
        "        case ""yolo"" then";
        "            detections = dnn_decode_yolo(matrix(out, -1, size(out, ""*"")), [size(S, 2) size(S, 1)]);";
        "            disp(detections);";
        "        case ""ssd"" then";
        "            detections = dnn_decode_ssd(out, [size(S, 2) size(S, 1)]);";
        "            disp(detections);";
        "        case ""yunet"" then";
        "            detections = dnn_decode_yunet(out, [size(S, 2) size(S, 1)]);";
        "            disp(detections);";
        "        case ""segmentation"" then";
        "            if size(size(out), ""*"") >= 3 then";
        "                mask = dnn_decode_segmentation(out);";
        "                scf(); imshow(mask);";
        "            else";
        "                mprintf(""Segmentation decoder expects H-by-W-by-C class scores.\n"");";
        "            end";
        "        else";
        "            mprintf(""No generic decoder is available for this model family yet.\n"");";
        "        end";
        "    catch";
        "        mprintf(""Model loaded. Update preprocessing or decoder for this model before running full inference.\n"");";
        "    end";
        "end";
        "";
        "// dnn_unloadmodel(net);"
    ];

    mputl(lines, script_file);
endfunction
