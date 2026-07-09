function out = imnormalize(im, alpha, beta)
    // Normalize image values to a target range.
    //
    // Syntax
    //    out = imnormalize(im)
    //    out = imnormalize(im, alpha, beta)
    //
    // Parameters
    //    im : Input image.
    //    alpha : Lower output value. Default is 0.
    //    beta : Upper output value. Default is 1.
    //    out : Normalized image as double.
    //
    // Description
    //    imnormalize scales each channel independently to the range [alpha, beta].
    //
    // Examples
    //    im = imread(fullpath(getIPCVpath() + "/images/" + "baboon.png"));
    //    out = imnormalize(im);
    //
    // See also
    //    imminmax
    //    immeanstddev
    //
    // Authors
    //    Tan Chin Luh

    rhs = argn(2);
    if rhs < 1 | rhs > 3 then
        error("imnormalize: Wrong number of input arguments.");
    end
    if rhs < 2 then alpha = 0; end
    if rhs < 3 then beta = 1; end

    dims = size(im);
    out = double(im);
    if size(dims, "*") < 3 then
        channels = 1;
    else
        channels = dims(3);
    end

    for c = 1:channels
        if channels == 1 then
            plane = out;
        else
            plane = out(:, :, c);
        end
        lo = min(plane);
        hi = max(plane);
        if hi > lo then
            plane = (plane - lo) ./ (hi - lo) .* (beta - alpha) + alpha;
        else
            plane(:) = alpha;
        end
        if channels == 1 then
            out = plane;
        else
            out(:, :, c) = plane;
        end
    end
endfunction
