function imout = imboxfilter(imin, ksize)
    // Blur an image using a normalized box filter.
    //
    // Syntax
    //    imout = imboxfilter(imin)
    //    imout = imboxfilter(imin, ksize)
    //
    // Parameters
    //    imin : Input image.
    //    ksize : Filter size. It can be a scalar or [rows cols]. Default is [3 3].
    //    imout : Blurred image with the same type and size as imin.
    //
    // Description
    //    imboxfilter is a normalized box filter wrapper compatible with OpenCV 5 boxFilter.
    //
    // Examples
    //    im = imread(fullpath(getIPCVpath() + "/images/" + "baboon.png"));
    //    out = imboxfilter(im, [5 5]);
    //    imshow(out);
    //
    // See also
    //    imblur
    //    imgaussianblur
    //    imbilateralfilter
    //
    // Authors
    //    Tan Chin Luh

    rhs = argn(2);
    if rhs < 1 | rhs > 2 then
        error("imboxfilter: Wrong number of input arguments.");
    end
    if rhs < 2 then
        ksize = [3 3];
    end

    imout = imblur(imin, ksize);
endfunction
