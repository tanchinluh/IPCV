function ok = aviset(handle, prop, value)
    // Set an OpenCV property on an opened video capture.
    //
    // Syntax
    //    ok = aviset(handle, prop, value)
    //
    // Authors
    //    Tan Chin Luh

    if argn(2) <> 3 then
        error("aviset: Wrong number of input arguments.");
    end
    ok = int_avi_setproperty(handle, imvideopropid(prop), value) <> 0;
endfunction
