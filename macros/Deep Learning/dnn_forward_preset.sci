function out = dnn_forward_preset(net, image, preset, layer_name)
    // Run a DNN with a named or structure-based preprocessing preset.
    //
    // Syntax
    //    out = dnn_forward_preset(net, image, preset)
    //    out = dnn_forward_preset(net, image, preset, layer_name)
    //
    // preset may be a name from dnn_presets() or a structure returned by
    // dnn_zoo_modelinfo().
    //
    // Authors
    //    Tan Chin Luh
    //
    // History
    //    5.0.0: Function introduced during Step 4.
    if argn(2) < 3 | argn(2) > 4 then
        error("dnn_forward_preset: net, image, and preset are required.");
    end

    if typeof(preset) == "string" then
        presets = dnn_presets();
        presetName = convstr(preset, "l");
        if ~isfield(presets, presetName) then
            error("dnn_forward_preset: unknown preset. Use dnn_presets() to list available presets.");
        end
        if presetName == "imagenet" then
            config = presets.imagenet;
        elseif presetName == "clip" then
            config = presets.clip;
        end
    elseif typeof(preset) == "st" then
        config = preset;
    else
        error("dnn_forward_preset: preset must be a name or a preprocessing structure.");
    end

    required = ["inputSize" "scale" "mean" "std" "swapRB" "crop"];
    for field = required
        if ~isfield(config, field) then
            error("dnn_forward_preset: preset is missing field " + field + ".");
        end
    end

    layerName = [];
    if argn(2) == 4 then
        layerName = layer_name;
    end
    out = dnn_forward(net, image, config.inputSize, layerName, config.scale, config.mean, config.swapRB, config.crop, config.std);
endfunction
