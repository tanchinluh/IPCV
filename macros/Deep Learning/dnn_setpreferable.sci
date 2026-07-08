//=============================================================================
// IPCV - Scilab Image Processing and Computer Vision toolbox
//=============================================================================
function net = dnn_setpreferable(net, backend, target)
    // Set OpenCV DNN preferable backend and target
    //
    // Syntax
    //    net = dnn_setpreferable(net, backend, target)
    //
    // Parameters
    //    net : DNN object loaded by dnn_readmodel
    //    backend : backend string or OpenCV DNN backend enum value
    //    target : target string or OpenCV DNN target enum value
    //
    // Examples
    //    dnn_path = fullpath(getIPCVpath() + "/images/dnn/");
    //    net = dnn_readmodel(dnn_path + "lenet5.pb", "", "tensorflow");
    //    net = dnn_setpreferable(net, "opencv", "cpu");
    //    info = dnn_info(net)
    //    dnn_unloadmodel(net);
    //

    rhs = argn(2);
    if rhs < 2; backend = "opencv"; end
    if rhs < 3; target = "cpu"; end
    if isempty(backend); backend = "opencv"; end
    if isempty(target); target = "cpu"; end
    if type(net) <> 17 | ~isfield(net, "ptr"); error("Input must be a DNN object."); end

    backend_value = backend;
    backend_name = string(backend);
    if type(backend) == 10 then
        backend_name = convstr(backend(1), "l");
        select backend_name
        case "default" then
            backend_value = 0;
        case "inference_engine" then
            backend_value = 2;
        case "openvino" then
            backend_value = 2;
        case "opencv" then
            backend_value = 3;
        case "vkcom" then
            backend_value = 4;
        case "cuda" then
            backend_value = 5;
        case "webnn" then
            backend_value = 6;
        case "timvx" then
            backend_value = 7;
        case "cann" then
            backend_value = 8;
        else
            error("Unsupported DNN backend.");
        end
    elseif type(backend) <> 1 | ~isscalar(backend) then
        error("backend must be a string or scalar enum value.");
    end

    target_value = target;
    target_name = string(target);
    if type(target) == 10 then
        target_name = convstr(target(1), "l");
        select target_name
        case "cpu" then
            target_value = 0;
        case "opencl" then
            target_value = 1;
        case "opencl_fp16" then
            target_value = 2;
        case "myriad" then
            target_value = 3;
        case "vulkan" then
            target_value = 4;
        case "fpga" then
            target_value = 5;
        case "cuda" then
            target_value = 6;
        case "cuda_fp16" then
            target_value = 7;
        case "hddl" then
            target_value = 8;
        case "npu" then
            target_value = 9;
        case "cpu_fp16" then
            target_value = 10;
        else
            error("Unsupported DNN target.");
        end
    elseif type(target) <> 1 | ~isscalar(target) then
        error("target must be a string or scalar enum value.");
    end

    int_dnn_setPreferableBackendTarget(net.ptr, backend_value, target_value);
    net.backend = backend_name;
    net.target = target_name;
endfunction
