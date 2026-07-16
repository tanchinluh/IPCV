function out = imbothat(image, se, iterations, anchor, borderType, borderValue)
    // Apply the MATLAB-style morphological bottom-hat operation.
    //
    // Syntax
    //    out = imbothat(image, se)
    //    out = imbothat(image, se, iterations, anchor, borderType, borderValue)
    //
    // The operation is the difference between the closing of the image and the
    // image. It is equivalent to OpenCV morphologyEx black-hat.
    //
    // Examples
    //    image = imread(fullpath(getIPCVpath() + "/images/morpex.png"));
    //    se = imcreatese("ellipse", 9, 9);
    //    out = imbothat(image, se);
    //    imshow(out);
    //
    // See also
    //    imblackhat
    //    imclose
    //    imtophat
    //
    // Authors
    //    Tan Chin Luh
    //
    // History
    //    5.0.0: Function introduced.

    rhs = argn(2);
    if rhs < 2 then error("imbothat: image and structuring element are required."); end
    if rhs < 3 then iterations = 1; end
    if rhs < 4 then anchor = [-1 -1]; end
    if rhs < 5 then borderType = "constant"; end
    if rhs < 6 then out = immorphologyex(image, se, "blackhat", iterations, anchor, borderType);
    else out = immorphologyex(image, se, "blackhat", iterations, anchor, borderType, borderValue); end
endfunction
