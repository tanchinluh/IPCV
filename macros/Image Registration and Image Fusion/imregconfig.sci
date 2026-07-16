function config = imregconfig(mode)
    // Return a registration configuration structure for imregister workflows.
    if argn(2) < 1 then mode = "monomodal"; end
    key = convstr(mode, "l");
    if key <> "monomodal" & key <> "multimodal" then error("imregconfig: mode must be monomodal or multimodal."); end
    if key == "monomodal" then metric = "mean-squares"; else metric = "mutual-information"; end
    config = struct("Mode", key, "Metric", metric, "Optimizer", "gradient-descent", ..
        "InitialRadius", 0.01, "Epsilon", 1e-6, "MaximumIterations", 100);
endfunction
