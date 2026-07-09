function [minValue, maxValue] = imminmax(im)
    // Compute per-channel image minimum and maximum values.
    //
    // Syntax
    //    [minValue, maxValue] = imminmax(im)
    //
    // Parameters
    //    im : Input image.
    //    minValue : Row vector of per-channel minimum values.
    //    maxValue : Row vector of per-channel maximum values.
    //
    // Description
    //    imminmax reports per-channel minimum and maximum values.
    //
    // Examples
    //    im = imread(fullpath(getIPCVpath() + "/images/" + "baboon.png"));
    //    [lo, hi] = imminmax(im);
    //
    // See also
    //    immeanstddev
    //    imcountnonzero
    //
    // Authors
    //    Tan Chin Luh

    rhs = argn(2);
    if rhs <> 1 then
        error("imminmax: Wrong number of input arguments.");
    end

    dims = size(im);
    if size(dims, "*") < 3 then
        channels = 1;
    else
        channels = dims(3);
    end

    minValue = zeros(1, channels);
    maxValue = zeros(1, channels);
    for c = 1:channels
        if channels == 1 then
            values = matrix(double(im), -1, 1);
        else
            values = matrix(double(im(:, :, c)), -1, 1);
        end
        minValue(c) = min(values);
        maxValue(c) = max(values);
    end
endfunction
