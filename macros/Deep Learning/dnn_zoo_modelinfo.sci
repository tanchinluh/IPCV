function info = dnn_zoo_modelinfo(modelName, groupName)
    // Return IPCV hints for OpenCV Zoo model families.
    //
    // Syntax
    //    info = dnn_zoo_modelinfo(modelName)
    //    info = dnn_zoo_modelinfo(modelName, groupName)
    //
    // Authors
    //    Tan Chin Luh

    rhs = argn(2);
    if rhs < 1 | rhs > 2 then
        error("dnn_zoo_modelinfo: Wrong number of input arguments.");
    end
    if rhs < 2 then groupName = ""; end

    text = convstr(groupName + " " + modelName, "l");

    info.name = modelName;
    info.group = groupName;
    info.task = "general";
    info.inputSize = [224 224];
    info.scale = 1;
    info.mean = [0 0 0];
    info.swapRB = 1;
    info.crop = 0;
    info.decoder = "raw";
    info.notes = "Model loaded; inspect output size and the OpenCV Zoo README for model-specific preprocessing.";

    if ipcv_dnn_zoo_contains(text, "classification") | ipcv_dnn_zoo_contains(text, "mobilenet") | ipcv_dnn_zoo_contains(text, "ppresnet") then
        info.task = "classification";
        info.inputSize = [224 224];
        info.scale = 1 / 127.5;
        info.mean = [127.5 127.5 127.5];
        info.swapRB = 1;
        info.decoder = "classification";
        info.notes = "Runs ImageNet-style classification and decodes top labels when a companion label/class file is available.";
    end

    if ipcv_dnn_zoo_contains(text, "yolo") then
        info.task = "object_detection";
        info.inputSize = [640 640];
        info.scale = 1 / 255;
        info.mean = [0 0 0];
        info.swapRB = 1;
        info.decoder = "yolo";
        info.notes = "Runs YOLO-style output through dnn_decode_yolo when the output is [cx cy w h objectness class...].";
    elseif ipcv_dnn_zoo_contains(text, "object_detection") | ipcv_dnn_zoo_contains(text, "license_plate_detection") then
        info.task = "object_detection";
        info.inputSize = [320 320];
        info.scale = 1 / 255;
        info.mean = [0 0 0];
        info.swapRB = 1;
        info.decoder = "raw";
        info.notes = "Detection model family identified; output layout can vary by model, so the sample prints raw output size.";
    end

    if ipcv_dnn_zoo_contains(text, "segmentation") | ipcv_dnn_zoo_contains(text, "humanseg") then
        info.task = "segmentation";
        info.inputSize = [512 512];
        info.scale = 1 / 255;
        info.mean = [0 0 0];
        info.swapRB = 1;
        info.decoder = "segmentation";
        info.notes = "Runs class-score maps through dnn_decode_segmentation when the output is H-by-W-by-C.";
    end

    if ipcv_dnn_zoo_contains(text, "face_detection_yunet") then
        info.task = "face_detection";
        info.inputSize = [320 320];
        info.scale = 1;
        info.mean = [0 0 0];
        info.swapRB = 1;
        info.decoder = "raw";
        info.notes = "YuNet uses a dedicated face-detection output layout; the sample loads and forwards the model.";
    end

    if ipcv_dnn_zoo_contains(text, "handpose") | ipcv_dnn_zoo_contains(text, "palm_detection") | ipcv_dnn_zoo_contains(text, "pose") then
        info.task = "pose_landmark";
        info.inputSize = [256 256];
        info.scale = 1 / 255;
        info.mean = [0 0 0];
        info.swapRB = 1;
        info.decoder = "raw";
        info.notes = "Pose/landmark models need model-specific coordinate decoding; the sample reports output tensors.";
    end
endfunction

function tf = ipcv_dnn_zoo_contains(text, pattern)
    tf = size(strindex(text, pattern), "*") > 0;
endfunction
