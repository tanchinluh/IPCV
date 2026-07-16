function value = imvar(image)
    // Return the sample variance of an image.
    //
    // Syntax
    //    value = imvar(image)
    //
    // RGB images are treated as one combined sample population.
    //
    // Examples
    //    image = imread(fullpath(getIPCVpath() + "/images/coins_gray.jpg"));
    //    value = imvar(image);
    //    disp(value);
    //    imshow(image);
    //
    // See also
    //    immean2
    //    imstd2
    //
    // Authors
    //    Tan Chin Luh
    //
    // History
    //    5.0.0: Function introduced.

    if argn(2) <> 1 then error("imvar: one image is required."); end
    values = matrix(double(image), -1, 1);
    if size(values, "*") < 2 then value = 0; else
        average = mean(values);
        value = sum((values - average) .^ 2) / (size(values, "*") - 1);
    end
endfunction
