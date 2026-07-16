function out = imshowpair(image1, image2, method, alpha)
    // Display or return a comparison of two images.
    //
    // Syntax
    //    out = imshowpair(image1, image2)
    //    out = imshowpair(image1, image2, method)
    //    out = imshowpair(image1, image2, method, alpha)
    //
    // method is "montage", "blend", "diff", or "falsecolor". The default is montage.
    //
    // Examples
    //    image1 = imread(fullpath(getIPCVpath() + "/images/lena.bmp"));
    //    image2 = imread(fullpath(getIPCVpath() + "/images/lena7030.bmp"));
    //    out = imshowpair(image1, image2, "falsecolor");
    //    imshow(out);
    //
    // See also
    //    imfuse
    //    imtile
    //
    // Authors
    //    Tan Chin Luh
    //
    // History
    //    5.0.0: Function introduced.
    rhs = argn(2);
    if rhs < 2 | rhs > 4 then error("imshowpair: Wrong number of input arguments."); end
    if rhs < 3 then method = "montage"; end
    if rhs < 4 then alpha = 0.5; end
    method = convstr(method, "l");
    if method == "montage" then
        out = imfuse(image1, image2, "cascade");
    elseif method == "blend" then
        out = imfuse(image1, image2, "composite", alpha);
    elseif method == "diff" then
        out = imfuse(image1, image2, "diff");
    elseif method == "falsecolor" then
        out = imfuse(image1, image2, "colordiff");
    else
        error("imshowpair: method must be montage, blend, diff, or falsecolor.");
    end
endfunction
