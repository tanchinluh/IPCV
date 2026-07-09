function imout = imwarpPerspective(imin, warpmat, width, height)
    // Apply a perspective image warp.
    //
    // Syntax
    //    imout = imwarpPerspective(imin, warpmat)
    //    imout = imwarpPerspective(imin, warpmat, width, height)
    //
    // Authors
    //    Tan Chin Luh

    rhs = argn(2);
    if rhs < 2 | rhs > 4 then
        error("imwarpPerspective: Wrong number of input arguments.");
    end
    if rhs < 4 then
        sz = size(imin);
        width = sz(2);
        height = sz(1);
    end
    imout = imtransform(imin, warpmat, "perspective", width, height);
endfunction
