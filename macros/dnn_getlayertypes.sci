//=============================================================================
// IPCV - Scilab Image Processing and Computer Vision toolbox
//=============================================================================
function types = dnn_getlayertypes(net)
    // Get DNN layer types used by a loaded model
    //
    // Syntax
    //    types = dnn_getlayertypes(net)
    //
    // Parameters
    //    net : DNN object loaded by dnn_readmodel
    //    types : layer type names
    //
    // Examples
    //    dnn_path = fullpath(getIPCVpath() + "/images/dnn/");
    //    net = dnn_readmodel(dnn_path + "lenet5.pb", "", "tensorflow");
    //    types = dnn_getlayertypes(net)
    //    dnn_unloadmodel(net);
    //

    rhs = argn(2);
    if rhs <> 1; error("Function expects one DNN model input."); end
    if type(net) <> 17 | ~isfield(net, "ptr"); error("Input must be a DNN object."); end

    types = int_dnn_getLayerTypes(net.ptr);
endfunction
