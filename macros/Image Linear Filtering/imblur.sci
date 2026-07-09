function imout = imblur(imin, ksize)
    // Blur an image using a normalized box filter.
    //
    // Syntax
    //    imout = imblur(imin)
    //    imout = imblur(imin, ksize)
    //
    // Parameters
    //    imin : Input image.
    //    ksize : Filter size. It can be a scalar or [rows cols]. Default is [3 3].
    //    imout : Blurred image with the same type and size as imin.
    //
    // Description
    //    imblur applies OpenCV 5 blur to each image channel.
    //
    // Examples
    //    im = imread(fullpath(getIPCVpath() + "/images/" + "baboon.png"));
    //    out = imblur(im, [5 5]);
    //    imshow(out);
    //
    // See also
    //    imgaussianblur
    //    imbilateralfilter
    //    imfilter
    //
    // Authors
    //    Tan Chin Luh

    rhs = argn(2);
    if rhs < 1 | rhs > 2 then
        error("imblur: Wrong number of input arguments.");
    end
    if rhs < 2 then
        ksize = [3 3];
    end

    if size(ksize, "*") == 1 then
        krows = ksize(1);
        kcols = ksize(1);
    elseif size(ksize, "*") == 2 then
        krows = ksize(1);
        kcols = ksize(2);
    else
        error("imblur: ksize must be a scalar or [rows cols].");
    end

    krows = round(krows);
    kcols = round(kcols);
    if krows <= 0 | kcols <= 0 then
        error("imblur: ksize values must be positive.");
    end

    imout = int_imblur(imin, krows, kcols);
endfunction
