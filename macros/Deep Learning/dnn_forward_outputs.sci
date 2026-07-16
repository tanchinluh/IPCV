function [outputs, names] = dnn_forward_outputs(net, image, preset, output_names)
    // Run several DNN output layers with one preprocessing configuration.
    //
    // Syntax
    //    [outputs, names] = dnn_forward_outputs(net, image, preset)
    //    [outputs, names] = dnn_forward_outputs(net, image, preset, output_names)
    //
    // Outputs are returned in a list and correspond to names in the same order.
    // A list is used because OpenCV layer names may contain slashes or dots.
    //
    // Authors
    //    Tan Chin Luh
    //
    // History
    //    5.0.0: Function introduced during Step 4.
    rhs = argn(2);
    if rhs < 3 | rhs > 4 then
        error("dnn_forward_outputs: net, image, and preset are required.");
    end
    if type(net) <> 17 | ~isfield(net, "ptr") then
        error("dnn_forward_outputs: net must be a DNN object.");
    end

    if rhs == 3 then
        names = dnn_getoutputs(net);
    else
        names = output_names;
    end
    if type(names) <> 10 | size(names, "*") == 0 then
        error("dnn_forward_outputs: output_names must be a non-empty string matrix.");
    end

    outputs = list();
    for i = 1:size(names, "*")
        outputs($ + 1) = dnn_forward_preset(net, image, preset, names(i));
    end
endfunction
