//=============================================================================
// IPCV - Scilab Image Processing and Computer Vision toolbox
// Copyright (C) 2018  Tan Chin Luh
//=============================================================================
function net = dnn_readmodel(model,modelinfo,modeltype)
    // Read/Import DNN model from disk
    //
    // Syntax
    //    net = dnn_readmodel(model,modelinfo,modeltype);
    //
    // Parameters
    //    model : Model binary (.caffemodel, .pb, .weights, .onnx, .t7, .tflite).
    //    modelinfo : Model info/config file, if required by the framework.
    //    modeltype : Model type. Use "auto", "caffe", "tensorflow", "yolo", "onnx", "torch", or "tflite".
    //    net : Loaded net with its' pointer and informations. 
    //
    // Description
    //    This function is used for loading DNN model and used in Scilab for inference system.
    //
    // Examples
    //    // Example 1: TensorFlow LeNet
    //    dnn_unloadallmodels();
    //    dnn_path = fullpath(getIPCVpath() + "/images/dnn/");
    //    net = dnn_readmodel(dnn_path + "lenet5.pb", "", "tensorflow");
    //    net = dnn_setpreferable(net, "opencv", "cpu");
    //    info = dnn_info(net, [28, 28], 1);
    //    S = imread(dnn_path + "3.jpg");
    //    out = dnn_forward(net, ~S, [28, 28]);
    //    [score, index] = max(out);
    //    prediction = index - 1
    //    dnn_unloadmodel(net);
    //
    //    // Example 2: ONNX MobileNetV2. The model and labels are downloaded if missing.
    //    model_name = "image_classification_mobilenetv2_2022apr.onnx";
    //    model_file = dnn_path + model_name;
    //    if ~isfile(model_file) then
    //        model_url = "https://github.com/opencv/opencv_zoo/raw/main/models/image_classification_mobilenet/" + model_name;
    //        http_get(model_url, model_file, follow=%t, timeout=300);
    //    end
    //    label_file = dnn_path + "classification_classes_ILSVRC2012.txt";
    //    if ~isfile(label_file) then
    //        label_url = "https://raw.githubusercontent.com/opencv/opencv/5.x/samples/data/dnn/classification_classes_ILSVRC2012.txt";
    //        http_get(label_url, label_file, follow=%t, timeout=120);
    //    end
    //    net = dnn_readmodel(model_file, "", "onnx");
    //    labels = stripblanks(mgetl(label_file));
    //    labels = labels(find(labels <> ""));
    //    S = imread(fullpath(getIPCVpath() + "/images/baboon.png"));
    //    out = dnn_forward(net, S, [224, 224], [], 1 / 127.5, [127.5 127.5 127.5], 1, 0);
    //    [score, index] = max(out);
    //    prediction = labels(index)
    //    scf(); imshow(S);
    //    title("MobileNetV2 ONNX: " + prediction + " (" + msprintf("%.4f", score) + ")");
    //    dnn_unloadmodel(net);
    //
    //    // Example 3: CLIP zero-shot image classification with precomputed text embeddings.
    //    // The CLIP ONNX model is not auto-downloaded because it is not from OpenCV Zoo.
    //    clip_model = dnn_path + "clip_rn50_openai_visual_fp16.onnx";
    //    if ~isfile(clip_model) then
    //        error("Place a trusted local CLIP image encoder at: " + clip_model);
    //    end
    //    net = dnn_readmodel(clip_model, "", "onnx");
    //    prompts = mgetl(dnn_path + "clip_rn50_openai_prompts.txt");
    //    text_embeddings = csvRead(dnn_path + "clip_rn50_openai_text_embeddings.csv");
    //    S = imread(fullpath(getIPCVpath() + "/images/baboon.png"));
    //    S = im2double(imresize(S, [224 224]));
    //    clip_mean = [0.48145466 0.4578275 0.40821073];
    //    clip_std = [0.26862954 0.26130258 0.27577711];
    //    for c = 1:3
    //        S(:,:,c) = (S(:,:,c) - clip_mean(c)) ./ clip_std(c);
    //    end
    //    image_embedding = dnn_forward(net, S, [224, 224], [], 1, [0 0 0], 0, 0);
    //    image_embedding = image_embedding(:)';
    //    image_embedding = image_embedding ./ sqrt(sum(image_embedding .* image_embedding));
    //    scores = text_embeddings * image_embedding';
    //    [score, index] = max(scores);
    //    label = strsplit(prompts(index), "|");
    //    prediction = label(1)
    //    dnn_unloadmodel(net);
    //
    // See also
    //     dnn_readmodel
    //     dnn_list
    //     dnn_unloadmodel
    //     dnn_unloadallmodels
    //     dnn_forward 
    //     dnn_getparam
    //     dnn_info
    //     dnn_setpreferable
    //
    // Authors
    //    CL Tan - Trity Technologies.
    //
    
    rhs=argn(2);
    // Error Checking 
    if rhs < 2; error("At least 2 arguments expected, model file and the model info/config."); end    
    if rhs < 3; modeltype = "auto"; end
    if isempty(modeltype); modeltype = "auto"; end

    supported_model = ["auto","caffe","tensorflow","yolo","onnx","torch","tflite"];
    // Check modeltype
    if type(modeltype) == 1 then
        checkrange(3,modeltype,0,size(supported_model,2) - 1); 
        modelselect = modeltype;
    elseif type(modeltype) == 10 then
        modeltype = convstr(modeltype(1), "l");
        select modeltype
        case "auto" then
            modelselect = 0;
        case "caffe" then
            modelselect = 1;
        case "tensorflow" then
            modelselect = 2;
        case "tf" then
            modelselect = 2;
        case "yolo" then
            modelselect = 3;
        case "darknet" then
            modelselect = 3;
        case "onnx" then
            modelselect = 4;
        case "torch" then
            modelselect = 5;
        case "tflite" then
            modelselect = 6;
        else
            error("Unsupported model type. Use ""auto"", ""caffe"", ""tensorflow"", ""yolo"", ""onnx"", ""torch"", or ""tflite"".");
        end
    else
        error("Model type must be a number from 0 to 6, or a supported model type string."); 
    end
    
    modelname = strsplit(model,['\','/','\\'])

    net.identifier = "dnn"
    net.name = modelname($);
    net.type = supported_model(modelselect + 1);
    net.backend = "opencv";
    net.target = "cpu";
    net.ptr = int_dnn_init(model,modelinfo,modelselect);
   // net.ptr = int_dnn_init(model,modelinfo);
    if net.ptr == -1 then
        error("Error loading DNN model."); 
    end
    net.layername = int_dnn_getLayerNames(net.ptr);
    net.outputname = int_dnn_getUnconnectedOutLayerNames(net.ptr);
    net.layertype = int_dnn_getLayerTypes(net.ptr);
    
    
endfunction
