function value = aviget(handle, prop)
    // Get an OpenCV property from an opened video capture.
    //
    // Syntax
    //    value = aviget(handle, prop)
    //
    // Authors
    //    Tan Chin Luh

    if argn(2) <> 2 then
        error("aviget: Wrong number of input arguments.");
    end
    value = int_avi_getproperty(handle, imvideopropid(prop));
endfunction
