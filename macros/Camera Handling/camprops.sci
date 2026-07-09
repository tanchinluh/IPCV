function props = camprops()
    // Return OpenCV camera capture property ids.
    //
    // Syntax
    //    props = camprops()
    //
    // Authors
    //    Tan Chin Luh

    if argn(2) <> 0 then
        error("camprops: Wrong number of input arguments.");
    end
    props = imvideoprops();
endfunction
