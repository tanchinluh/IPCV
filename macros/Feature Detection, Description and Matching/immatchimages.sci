function [out, f1, f2, matches] = immatchimages(im1, im2, method, n, draw)
    // Detect, describe, match, and optionally draw best image matches.
    //
    // Syntax
    //    out = immatchimages(im1, im2)
    //    [out, f1, f2, matches] = immatchimages(im1, im2, method, n, draw)
    //
    // Authors
    //    Tan Chin Luh

    rhs = argn(2);
    if rhs < 2 | rhs > 5 then
        error("immatchimages: Wrong number of input arguments.");
    end
    if rhs < 3 then method = "ORB"; end
    if rhs < 4 then n = 10; end
    if rhs < 5 then draw = %t; end

    f1 = imdetect(im1, method);
    f2 = imdetect(im2, method);
    d1 = imextract(im1, f1, method);
    d2 = imextract(im2, f2, method);
    matches = immatch(d1, d2);
    n = min(n, size(matches, 2));
    [bf1, bf2, bm] = imbestmatches(f1, f2, matches, n);

    if draw then
        out = imdrawmatches(im1, im2, bf1, bf2, bm);
    else
        out.f1 = bf1;
        out.f2 = bf2;
        out.matches = bm;
    end
endfunction
