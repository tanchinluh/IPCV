function [meanValue, stdValue] = immeanstddev(im)
    // Compute per-channel image mean and standard deviation.
    //
    // Syntax
    //    [meanValue, stdValue] = immeanstddev(im)
    //
    // Parameters
    //    im : Input image.
    //    meanValue : Row vector of per-channel mean values.
    //    stdValue : Row vector of per-channel standard deviations.
    //
    // Description
    //    immeanstddev computes OpenCV-style per-channel mean and population standard deviation.
    //
    // Examples
    //    im = imread(fullpath(getIPCVpath() + "/images/" + "baboon.png"));
    //    [m, s] = immeanstddev(im);
    //
    // See also
    //    mean2
    //    std2
    //    imhist
    //
    // Authors
    //    Tan Chin Luh

    rhs = argn(2);
    if rhs <> 1 then
        error("immeanstddev: Wrong number of input arguments.");
    end

    dims = size(im);
    if size(dims, "*") < 3 then
        channels = 1;
    else
        channels = dims(3);
    end

    meanValue = zeros(1, channels);
    stdValue = zeros(1, channels);
    for c = 1:channels
        if channels == 1 then
            plane = double(im);
        else
            plane = double(im(:, :, c));
        end
        values = matrix(plane, -1, 1);
        m = mean(values);
        meanValue(c) = m;
        stdValue(c) = sqrt(mean((values - m).^2));
    end
endfunction
