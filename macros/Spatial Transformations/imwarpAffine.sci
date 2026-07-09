function imout = imwarpAffine(imin, warpmat, width, height)
    // Apply an affine image warp.
    //
    // Syntax
    //    imout = imwarpAffine(imin, warpmat)
    //    imout = imwarpAffine(imin, warpmat, width, height)
    //
    // Authors
    //    Tan Chin Luh

    rhs = argn(2);
    if rhs < 2 | rhs > 4 then
        error("imwarpAffine: Wrong number of input arguments.");
    end
    if rhs < 4 then
        sz = size(imin);
        width = sz(2);
        height = sz(1);
    end
    imout = imtransform(imin, warpmat, "affine", width, height);
endfunction
