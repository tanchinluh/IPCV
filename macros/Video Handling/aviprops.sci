function props = aviprops()
    // Return OpenCV video capture property ids.
    //
    // Syntax
    //    props = aviprops()
    //
    // Authors
    //    Tan Chin Luh

    if argn(2) <> 0 then
        error("aviprops: Wrong number of input arguments.");
    end
    props = imvideoprops();
endfunction
