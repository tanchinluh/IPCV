function out = imcolfilt(image, window, functionName)
    // Apply a function to every sliding image neighborhood.
    //
    // Syntax
    //    out = imcolfilt(image, window, functionName)
    //
    // functionName is the name of a one-input Scilab function. The callback
    // receives each window and must return one scalar.
    //
    // Examples
    //    image = imread(fullpath(getIPCVpath() + "/images/coins_gray.jpg"));
    //    deff("y=localmean(x)", "y=mean(x)");
    //    out = imcolfilt(image, [7 7], "localmean");
    //    imshow(out);
    //
    // See also
    //    imblockslide
    //    imordfilt
    //
    // Authors
    //    Tan Chin Luh
    //
    // History
    //    5.0.0: Function introduced.

    if argn(2) <> 3 then error("imcolfilt: image, window, and function name are required."); end
    if typeof(functionName) <> "string" then error("imcolfilt: functionName must be a function name string."); end
    out = imblockslide(image, window, functionName);
endfunction
