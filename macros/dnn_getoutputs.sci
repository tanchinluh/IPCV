//=============================================================================
// IPCV - Scilab Image Processing and Computer Vision toolbox
//=============================================================================
function names = dnn_getoutputs(net)
    // Get DNN unconnected output layer names
    //
    // Syntax
    //    names = dnn_getoutputs(net)
    //
    // Parameters
    //    net : DNN object loaded by dnn_readmodel
    //    names : output layer names
    //
    // Examples
    //    dnn_path = fullpath(getIPCVpath() + "/images/dnn/");
    //    net = dnn_readmodel(dnn_path + "lenet5.pb", "", "tensorflow");
    //    names = dnn_getoutputs(net)
    //    dnn_unloadmodel(net);
    //

    rhs = argn(2);
    if rhs <> 1; error("Function expects one DNN model input."); end
    if type(net) <> 17 | ~isfield(net, "ptr"); error("Input must be a DNN object."); end

    names = int_dnn_getUnconnectedOutLayerNames(net.ptr);
endfunction
