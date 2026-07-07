//=============================================================================
// IPCV - Scilab Image Processing and Computer Vision toolbox
//=============================================================================
function info = dnn_info(net, input_size, channels)
    // Return metadata for a loaded DNN model
    //
    // Syntax
    //    info = dnn_info(net)
    //    info = dnn_info(net, input_size, channels)
    //
    // Parameters
    //    net : DNN object loaded by dnn_readmodel
    //    input_size : optional [width, height] network input size
    //    channels : optional number of input channels
    //    info : DNN metadata struct
    //
    // Examples
    //    dnn_path = fullpath(getIPCVpath() + "/images/dnn/");
    //    net = dnn_readmodel(dnn_path + "lenet5.pb", "", "tensorflow");
    //    info = dnn_info(net, [28, 28], 1);
    //    disp(info.outputname);
    //    disp(info.flops);
    //    dnn_unloadmodel(net);
    //

    rhs = argn(2);
    if rhs < 1; error("Function expects a DNN model input."); end
    if type(net) <> 17 | ~isfield(net, "ptr"); error("Input must be a DNN object."); end
    if rhs < 3; channels = 3; end

    info.identifier = "dnn_info";
    info.ptr = net.ptr;
    info.name = net.name;
    info.type = net.type;
    info.backend = "";
    info.target = "";
    if isfield(net, "backend") then
        info.backend = net.backend;
    end
    if isfield(net, "target") then
        info.target = net.target;
    end
    info.layername = int_dnn_getLayerNames(net.ptr);
    info.outputname = int_dnn_getUnconnectedOutLayerNames(net.ptr);
    info.layertype = int_dnn_getLayerTypes(net.ptr);
    info.layercount = int_dnn_getLayersCount(net.ptr);

    if rhs >= 2 then
        if ~isempty(input_size) then
            info.flops = dnn_getflops(net, input_size, channels);
        end
    end
endfunction
