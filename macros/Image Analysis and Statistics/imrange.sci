function value = imrange(image)
    // Return the intensity range of an image.
    //
    // Syntax
    //    value = imrange(image)
    //
    // The range is max(image(:)) - min(image(:)).
    //
    // Examples
    //    image = imread(fullpath(getIPCVpath() + "/images/coins_gray.jpg"));
    //    value = imrange(image);
    //    disp(value);
    //    imshow(image);
    //
    // See also
    //    imminmax
    //    imnormalize
    //
    // Authors
    //    Tan Chin Luh
    //
    // History
    //    5.0.0: Function introduced.

    if argn(2) <> 1 then error("imrange: one image is required."); end
    values = double(image);
    value = max(values) - min(values);
endfunction
