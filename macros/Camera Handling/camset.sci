function ok = camset(handle, prop, value)
    // Set an OpenCV property on an opened camera.
    //
    // Syntax
    //    ok = camset(handle, prop, value)
    //
    // Authors
    //    Tan Chin Luh

    if argn(2) <> 3 then
        error("camset: Wrong number of input arguments.");
    end
    ok = int_cam_setproperty(handle, imvideopropid(prop), value) <> 0;
endfunction
