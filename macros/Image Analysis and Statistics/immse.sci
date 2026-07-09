function value = immse(im1, im2)
    // Compute mean squared error between two images.
    //
    // Syntax
    //    value = immse(im1, im2)
    //
    // Parameters
    //    im1 : First image.
    //    im2 : Second image with the same size as im1.
    //    value : Mean squared error.
    //
    // Authors
    //    Tan Chin Luh

    rhs = argn(2);
    if rhs <> 2 then
        error("immse: Wrong number of input arguments.");
    end
    if or(size(im1) <> size(im2)) then
        error("immse: Input images must have the same size.");
    end

    diff = double(im1) - double(im2);
    value = mean(matrix(diff .^ 2, -1, 1));
endfunction
