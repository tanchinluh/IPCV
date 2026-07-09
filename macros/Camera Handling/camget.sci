function value = camget(handle, prop)
    // Get an OpenCV property from an opened camera.
    //
    // Syntax
    //    value = camget(handle, prop)
    //
    // Authors
    //    Tan Chin Luh

    if argn(2) <> 2 then
        error("camget: Wrong number of input arguments.");
    end
    value = int_cam_getproperty(handle, imvideopropid(prop));
endfunction
