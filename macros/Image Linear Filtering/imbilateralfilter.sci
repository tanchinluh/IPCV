function imout = imbilateralfilter(imin, diameter, sigmaColor, sigmaSpace)
    // Blur an image while preserving edges with a bilateral filter.
    //
    // Syntax
    //    imout = imbilateralfilter(imin)
    //    imout = imbilateralfilter(imin, diameter)
    //    imout = imbilateralfilter(imin, diameter, sigmaColor)
    //    imout = imbilateralfilter(imin, diameter, sigmaColor, sigmaSpace)
    //
    // Parameters
    //    imin : Input image.
    //    diameter : Diameter of each pixel neighborhood. Default is 5.
    //    sigmaColor : Filter sigma in color space. Default is 75.
    //    sigmaSpace : Filter sigma in coordinate space. Default is 75.
    //    imout : Filtered image with the same type and size as imin.
    //
    // Description
    //    imbilateralfilter applies OpenCV 5 bilateralFilter to each image channel.
    //
    // Examples
    //    im = imread(fullpath(getIPCVpath() + "/images/" + "baboon.png"));
    //    out = imbilateralfilter(im, 7, 50, 50);
    //    imshow(out);
    //
    // See also
    //    imblur
    //    imgaussianblur
    //    imfilter
    //
    // Authors
    //    Tan Chin Luh

    rhs = argn(2);
    if rhs < 1 | rhs > 4 then
        error("imbilateralfilter: Wrong number of input arguments.");
    end
    if rhs < 2 then
        diameter = 5;
    end
    if rhs < 3 then
        sigmaColor = 75;
    end
    if rhs < 4 then
        sigmaSpace = 75;
    end

    diameter = round(diameter);
    if diameter <= 0 then
        error("imbilateralfilter: diameter must be positive.");
    end
    if sigmaColor <= 0 | sigmaSpace <= 0 then
        error("imbilateralfilter: sigma values must be positive.");
    end

    imout = int_imbilateralfilter(imin, diameter, sigmaColor, sigmaSpace);
endfunction
