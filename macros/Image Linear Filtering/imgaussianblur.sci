function imout = imgaussianblur(imin, ksize, sigmaX, sigmaY)
    // Blur an image using a Gaussian kernel.
    //
    // Syntax
    //    imout = imgaussianblur(imin)
    //    imout = imgaussianblur(imin, ksize)
    //    imout = imgaussianblur(imin, ksize, sigmaX)
    //    imout = imgaussianblur(imin, ksize, sigmaX, sigmaY)
    //
    // Parameters
    //    imin : Input image.
    //    ksize : Gaussian kernel size. It can be a scalar or [rows cols]. Values must be positive and odd. Default is [5 5].
    //    sigmaX : Gaussian sigma in the X direction. Default is 0.
    //    sigmaY : Gaussian sigma in the Y direction. Default is 0.
    //    imout : Blurred image with the same type and size as imin.
    //
    // Description
    //    imgaussianblur applies OpenCV 5 GaussianBlur to each image channel.
    //
    // Examples
    //    im = imread(fullpath(getIPCVpath() + "/images/" + "baboon.png"));
    //    out = imgaussianblur(im, [7 7], 1.5);
    //    imshow(out);
    //
    // See also
    //    imblur
    //    imbilateralfilter
    //    imfilter
    //
    // Authors
    //    Tan Chin Luh

    rhs = argn(2);
    if rhs < 1 | rhs > 4 then
        error("imgaussianblur: Wrong number of input arguments.");
    end
    if rhs < 2 then
        ksize = [5 5];
    end
    if rhs < 3 then
        sigmaX = 0;
    end
    if rhs < 4 then
        sigmaY = 0;
    end

    if size(ksize, "*") == 1 then
        krows = ksize(1);
        kcols = ksize(1);
    elseif size(ksize, "*") == 2 then
        krows = ksize(1);
        kcols = ksize(2);
    else
        error("imgaussianblur: ksize must be a scalar or [rows cols].");
    end

    krows = round(krows);
    kcols = round(kcols);
    if krows <= 0 | kcols <= 0 | modulo(krows, 2) == 0 | modulo(kcols, 2) == 0 then
        error("imgaussianblur: ksize values must be positive and odd.");
    end
    if sigmaX < 0 | sigmaY < 0 then
        error("imgaussianblur: sigma values must be non-negative.");
    end

    imout = int_imgaussianblur(imin, krows, kcols, sigmaX, sigmaY);
endfunction
