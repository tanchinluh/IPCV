//=============================================================================
// IPCV - Scilab Image Processing and Computer Vision toolbox
//=============================================================================
function flops = dnn_getflops(net, input_size, channels)
    // Estimate DNN floating point operations for an input shape
    //
    // Syntax
    //    flops = dnn_getflops(net, input_size, channels)
    //
    // Parameters
    //    net : DNN object loaded by dnn_readmodel
    //    input_size : [width, height] network input size
    //    channels : number of input channels
    //    flops : estimated floating point operations
    //
    // Examples
    //    dnn_path = fullpath(getIPCVpath() + "/images/dnn/");
    //    net = dnn_readmodel(dnn_path + "lenet5.pb", "", "tensorflow");
    //    flops = dnn_getflops(net, [28, 28], 1)
    //    dnn_unloadmodel(net);
    //

    rhs = argn(2);
    if rhs < 2; error("At least 2 arguments expected, DNN model and input_size."); end
    if rhs < 3; channels = 3; end
    if type(net) <> 17 | ~isfield(net, "ptr"); error("Input must be a DNN object."); end
    if type(input_size) <> 1 | size(input_size, "*") <> 2 then
        error("input_size must be [width, height].");
    end
    if type(channels) <> 1 | ~isscalar(channels) then
        error("channels must be a double scalar.");
    end
    if min(input_size) <= 0 | channels <= 0 then
        error("input_size and channels must be positive.");
    end

    flops = int_dnn_getFLOPS(net.ptr, input_size, channels);
endfunction
