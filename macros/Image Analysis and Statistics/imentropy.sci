function value = imentropy(image, bins)
    // Compute the base-2 Shannon entropy of an image.
    //
    // Syntax
    //    value = imentropy(image)
    //    value = imentropy(image, bins)
    //
    // RGB images are converted to grayscale. bins defaults to 256.
    //
    // Examples
    //    image = imread(fullpath(getIPCVpath() + "/images/baboon.png"));
    //    value = imentropy(image);
    //    disp(value);
    //    imshow(image);
    //
    // See also
    //    imhist
    //    imcalchist
    //
    // Authors
    //    Tan Chin Luh
    //
    // History
    //    5.0.0: Function introduced.

    rhs = argn(2);
    if rhs < 1 | rhs > 2 then error("imentropy: Wrong number of input arguments."); end
    if size(size(image), "*") == 3 then image = rgb2gray(image); end
    if rhs < 2 then bins = 256; end
    [counts, cells] = imhist(image, round(bins));
    probabilities = counts / sum(counts);
    probabilities = probabilities(probabilities > 0);
    value = -sum(probabilities .* log2(probabilities));
endfunction
