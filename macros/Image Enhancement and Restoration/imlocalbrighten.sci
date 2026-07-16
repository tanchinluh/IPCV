function out = imlocalbrighten(image, amount, sigma)
    // Brighten locally dark regions using a smooth background estimate.
    //
    // Syntax
    //    out = imlocalbrighten(image)
    //    out = imlocalbrighten(image, amount, sigma)
    //
    // Examples
    //    image = imread(fullpath(getIPCVpath() + "/images/Lena_dark.png"));
    //    out = imlocalbrighten(image, 1, 20);
    //    imshow(out);
    //
    // See also
    //    imflatfield
    //    imadjust
    //
    // Authors
    //    Tan Chin Luh
    //
    // History
    //    5.0.0: Function introduced.
    rhs = argn(2);
    if rhs < 1 | rhs > 3 then error("imlocalbrighten: Wrong number of input arguments."); end
    if rhs < 2 then amount = 1; end
    if rhs < 3 then sigma = 15; end
    if amount < 0 | sigma <= 0 then error("imlocalbrighten: amount must be non-negative and sigma positive."); end
    source = im2double(image);
    k = max(3, 2 * ceil(sigma / 3) + 1);
    background = imgaussianblur(source, [k k], sigma, sigma);
    out = source + amount .* (source - background);
    out(out < 0) = 0;
    out(out > 1) = 1;
    if typeof(image) == "uint8" then out = im2uint8(out); end
endfunction
