function presets = dnn_presets()
    // Return common DNN preprocessing presets.
    //
    // Syntax
    //    presets = dnn_presets()
    //
    // Authors
    //    Tan Chin Luh

    rhs = argn(2);
    if rhs <> 0 then
        error("dnn_presets: Wrong number of input arguments.");
    end

    imagenet.name = "imagenet";
    imagenet.size = [224 224];
    imagenet.mean = [0.485 0.456 0.406];
    imagenet.std = [0.229 0.224 0.225];
    imagenet.scale = 1 / 255;
    imagenet.swapRB = %t;

    clip.name = "clip";
    clip.size = [224 224];
    clip.mean = [0.48145466 0.4578275 0.40821073];
    clip.std = [0.26862954 0.26130258 0.27577711];
    clip.scale = 1 / 255;
    clip.swapRB = %t;

    presets.imagenet = imagenet;
    presets.clip = clip;
endfunction
