//=============================================================================
// IPCV - Scilab Image Processing and Computer Vision toolbox
// Copyright (C) 2018  Tan Chin Luh
//=============================================================================
function out = dnn_forward(net,img,input_size,layer_name,scalefactor,rgb_mean,swapRB,crop,rgb_std)
    // Runs inference and returns a final model output
    //
    // Syntax
    //    out = dnn_forward(net,img,input_size)
    //    out = dnn_forward(net,img,input_size,layer_name,scalefactor,rgb_mean,swapRB,crop)
    //    out = dnn_forward(net,img,input_size,layer_name,scalefactor,rgb_mean,swapRB,crop,rgb_std)
    //
    // Parameters
    //    net : DNN object loaded in Scilab
    //    img : Image in Scilab format 
    //    input_size : DNN input size
    //    layer_name : Optional final output tensor name from net.outputname
    //    scalefactor : Spatial size for input image
    //    rgb_mean : Vector with mean values which are subtracted from channels. Values are intended to be in (mean-R, mean-G, mean-B) order if image has BGR ordering and swapRB is true.
    //    rgb_std : Optional vector with per-channel standard deviation values applied after mean subtraction. Use [1, 1, 1] for no per-channel standardization.
    //    swapRB : Flag which indicates that swap first and last channels in 3-channel image is necessary.
    //    crop : flag which indicates whether image will be cropped after resize or not
    //    out : Output matrix of the results depending on the type of DNN loaded.
    //
    // Description
    //    OpenCV 5.1 exposes final model outputs only; intermediate activations are unavailable.
    //
    // Examples
    //    dnn_path = fullpath(getIPCVpath() + "/images/dnn/");
    //    net = dnn_readmodel(dnn_path + "lenet5.onnx", "", "onnx");
    //    S = rgb2gray(imread(dnn_path + "3.jpg"));
    //    out = dnn_forward(net, ~S, [28, 28]);
    //    [score, index] = max(out);
    //    prediction = index - 1
    //    named_output = dnn_forward(net, ~S, [28, 28], net.outputname(1));
    //    size(named_output)
    //    dnn_unloadmodel(net);
    //
    // See also
    //     dnn_readmodel
    //     dnn_list
    //     dnn_unloadmodel
    //     dnn_unloadallmodels
    //     dnn_forward 
    //     dnn_getparam
    //     dnn_getoutputs
    //
    // Authors
    //    CL Tan - Trity Technologies.
    //

    
    rhs=argn(2);
    // Error Checking 
    if rhs < 3; error("At least 3 arguments expected, DNN model, input image, and the dnn input size"); end    
    if rhs < 4 then
        layer_name = net.layername($);
        if isfield(net, "outputname") then
            if size(net.outputname, "*") > 0 then
                layer_name = net.outputname($);
            end
        end
    end
    if rhs < 5; scalefactor = 1; end
    if rhs < 6; rgb_mean = [0, 0, 0]; end
    if rhs < 7; swapRB = 1; end
    if rhs < 8; crop = 0; end
    if rhs < 9; rgb_std = [1, 1, 1]; end

    // Check for empty optional inputs
    if isempty(layer_name) then
        layer_name = net.layername($);
        if isfield(net, "outputname") then
            if size(net.outputname, "*") > 0 then
                layer_name = net.outputname($);
            end
        end
    end
    if isempty(scalefactor); scalefactor = 1; end
    if isempty(rgb_mean); rgb_mean = [0, 0, 0]; end
    if isempty(swapRB); swapRB = 1; end
    if isempty(crop); crop = 0; end
    if isempty(rgb_std); rgb_std = [1, 1, 1]; end
    
    
     
    // Check for empty optional inputs
    if type(scalefactor) ~= 1 | ~isscalar(scalefactor)
        error("Input scalefactor must be a double scalar"); 
    end   
    if type(rgb_mean) ~= 1 | length(rgb_mean)<3
        error("Input rgb_mean must be vector of [R,G,B]"); 
    end
    if type(rgb_std) ~= 1 | length(rgb_std)<3
        error("Input rgb_std must be vector of [R,G,B]");
    end
    if or(rgb_std(1:3) == 0) then
        error("Input rgb_std values must be nonzero");
    end
    checkrange(7,swapRB,0,1);
    checkrange(8,crop,0,1);
    
    if type(layer_name) ~= 10 
        error("Input layer_name must be a string"); 
    end
    
    if ~isfield(net, "outputname") | sum(net.outputname == layer_name) < 1 then
        error("OpenCV 5.1 supports final model outputs only; intermediate activations are not exposed by the graph engine.");
    end
    
    out = int_dnn_forward(net.ptr,img,input_size,layer_name,scalefactor,rgb_mean,swapRB,crop,rgb_std);
    
    
endfunction
