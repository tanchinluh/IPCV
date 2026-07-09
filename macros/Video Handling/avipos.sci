function [frameIndex, msec, ratio] = avipos(handle)
    // Return current video capture position.
    //
    // Syntax
    //    [frameIndex, msec, ratio] = avipos(handle)
    //
    // Authors
    //    Tan Chin Luh

    if argn(2) <> 1 then
        error("avipos: Wrong number of input arguments.");
    end
    frameIndex = aviget(handle, "pos_frames") + 1;
    msec = aviget(handle, "pos_msec");
    ratio = aviget(handle, "pos_avi_ratio");
endfunction
