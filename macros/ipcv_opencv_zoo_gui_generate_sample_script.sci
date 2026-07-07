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
        "if ~isfile(model_file) then";
        "    error(""Model file not found: "" + model_file);";
        "end";
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
        "// OpenCV Zoo models need model-specific input size and preprocessing.";
        "// Check the model documentation link above before using this block for real inference.";
        "input_image = fullpath(getIPCVpath() + ""/images/baboon.png"");";
        "if isfile(input_image) then";
        "    try";
        "        S = imread(input_image);";
        "        input_size = [224, 224];";
        "        out = dnn_forward(net, S, input_size);";
        "        mprintf(""Forward output size: %s\n"", strcat(string(size(out)), "" x ""));";
        "    catch";
        "        mprintf(""Model loaded. Update input_size and preprocessing for this model before running dnn_forward.\n"");";
        "    end";
        "end";
        "";
        "// dnn_unloadmodel(net);"
    ];

    mputl(lines, script_file);
endfunction
