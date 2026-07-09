function ok = aviseek(handle, frameIndex)
    // Seek an opened video capture to a one-based frame index.
    //
    // Syntax
    //    ok = aviseek(handle, frameIndex)
    //
    // Authors
    //    Tan Chin Luh

    if argn(2) <> 2 then
        error("aviseek: Wrong number of input arguments.");
    end
    if frameIndex < 1 then
        error("aviseek: frameIndex must be >= 1.");
    end
    ok = aviset(handle, "pos_frames", frameIndex - 1);
endfunction
