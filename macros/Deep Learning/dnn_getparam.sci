//=============================================================================
// IPCV - Scilab Image Processing and Computer Vision toolbox
// Copyright (C) 2018  Tan Chin Luh
//=============================================================================
function out = dnn_getparam(net,layer_name,numParam)
    // Reports learned-parameter access availability
    //
    // Syntax
    //    out = dnn_getparam(net,layer_name,numParam)
    //
    // Parameters
    //    net : DNN object loaded in Scilab
    //    layer_name : Name for layer which output is needed to get
    //    numParam : index of the layer parameter in the layer
    //    out : Output matrix of the results depending on the type of DNN loaded.
    //
    // Description
    //    OpenCV 5.1 does not expose learned layer parameters through its graph engine.
    //
    // Examples
    //    // Initialize
    //    dnn_unloadallmodels
    //    dnn_path = fullpath(getIPCVpath() + '/images/dnn/');
    //    net = dnn_readmodel(dnn_path + 'lenet5.onnx','','onnx');
    //     
    //     
    //    // OpenCV 5.1 does not expose learned layer parameters.
    //     
    //    // Clean Up 
    //    dnn_unloadallmodels();
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
    if rhs < 2; error("At least 2 arguments expected, DNN model and the layer name in which parameters to be extracted"); end    
    if rhs < 3; numParam = 0; end

    // Check for empty optional inputs
    if isempty(numParam); numParam = 0; end

     
    // Check for empty optional inputs
    if type(layer_name) ~= 10 
        error("Input layer_name must be a string"); 
    end
    
    if sum(net.layername==layer_name)~=1 then
        error("Layer name not found in the DNN structure."); 
    end
    
    error("dnn_getparam is unavailable because the OpenCV 5.1 graph engine does not expose learned layer parameters.");
endfunction
