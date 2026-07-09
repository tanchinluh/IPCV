function imout = imdenoise(imin, h, hColor, templateWindowSize, searchWindowSize)
    // Denoise an image using OpenCV fast non-local means.
    //
    // Syntax
    //    imout = imdenoise(imin)
    //    imout = imdenoise(imin, h, hColor, templateWindowSize, searchWindowSize)
    //
    // Parameters
    //    imin : Input uint8 grayscale or RGB image.
    //    h : Filter strength for luminance or grayscale. Default is 3.
    //    hColor : Filter strength for color components. Default is 3.
    //    templateWindowSize : Template patch size. It must be positive and odd. Default is 7.
    //    searchWindowSize : Search window size. It must be positive and odd. Default is 21.
    //    imout : Denoised image.
    //
    // Description
    //    imdenoise applies OpenCV 5 fastNlMeansDenoising or fastNlMeansDenoisingColored.
    //
    // Examples
    //    im = imread(fullpath(getIPCVpath() + "/images/" + "baboon.png"));
    //    out = imdenoise(im, 5, 5, 7, 21);
    //    imshow(out);
    //
    // See also
    //    immedian
    //    imfilter
    //
    // Authors
    //    Tan Chin Luh

    rhs = argn(2);
    if rhs < 1 | rhs > 5 then
        error("imdenoise: Wrong number of input arguments.");
    end
    if rhs < 2 then h = 3; end
    if rhs < 3 then hColor = h; end
    if rhs < 4 then templateWindowSize = 7; end
    if rhs < 5 then searchWindowSize = 21; end

    templateWindowSize = round(templateWindowSize);
    searchWindowSize = round(searchWindowSize);
    if h <= 0 | hColor <= 0 then
        error("imdenoise: h and hColor must be positive.");
    end
    if templateWindowSize <= 0 | searchWindowSize <= 0 | modulo(templateWindowSize, 2) == 0 | modulo(searchWindowSize, 2) == 0 then
        error("imdenoise: window sizes must be positive and odd.");
    end

    imout = int_imdenoise(imin, h, hColor, templateWindowSize, searchWindowSize);
endfunction
