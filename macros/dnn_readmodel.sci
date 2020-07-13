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
    //    model : Model binary (Caffe -> .caffemodel file, TF -> .pb file).
    //    modelinfo : Model info (Caffe - > .prototxt file. TF -> .pbtxt file).
    //    modeltype : Model type, currently support Caffe and Tensorflow model.
    //    net : Loaded net with its' pointer and informations. 
    //
    // Description
    //    This function is used for loading DNN model and used in Scilab for inference system.
    //
    // Examples
    //    dnn_path = fullpath(getIPCVpath() + '/images/dnn/');
    //    net = dnn_readmodel(dnn_path + 'lenet5.pb','','tensorflow');
    //    S = imread(dnn_path + '3.jpg');
    //    imshow(S);
    //    out = dnn_forward(net,~S,[28,28]);
    //    [maxV,maxI]=max(out);
    //    xnumb(10,10,maxI-1);
    //    e = gce();
    //    e.font_size = 10;
    //    e.font_color = 5;
    //
    // See also
    //     dnn_readmodel
    //     dnn_list
    //     dnn_unloadmodel
    //     dnn_unloadallmodels
    //     dnn_forward 
    //     dnn_getparam
    //
    // Authors
    //    CL Tan - Trity Technologies.
    //
    
    rhs=argn(2);
    // Error Checking 
    if rhs < 2; error("At least 2 arguments expected, model file and the prototext."); end    
    if rhs < 3; modeltype = 1; end
    if isempty(modeltype); modeltype = 1; end
    
    
    supported_model = ["caffe","tensorflow","yolo","onnx","torch"];
    // Check modeltype
    if type(modeltype) == 1 then
        checkrange(3,modeltype,1,size(supported_model,2)); 
        modelselect = modeltype;
    elseif type(modeltype) == 10 then
        modelselect = grep(supported_model,modeltype);
        checkrange(3,modelselect,1,size(supported_model,2));
    else
        error("Only model type in number, 1 to 5, or model string ""caffe"", ""tensor"" , ""yolo"" , ""onnx"" and ""torch"" are allowed."); 
    end
    
    modelname = strsplit(model,['\','/','\\','//'])

    net.identifier = "dnn"
    net.name = modelname($);
    net.type = supported_model(modelselect);
    net.ptr = int_dnn_init(model,modelinfo,modelselect);
   // net.ptr = int_dnn_init(model,modelinfo);
    if net.ptr == -1 then
        error("Error loading DNN model."); 
    end
    net.layername = int_dnn_getLayerNames(net.ptr);
    
    
endfunction
