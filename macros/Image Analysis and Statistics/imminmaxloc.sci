function [minValue, maxValue, minLocation, maxLocation] = imminmaxloc(im)
    // Compute per-channel extrema and their first locations.
    //
    // Syntax
    //    [minValue, maxValue, minLocation, maxLocation] = imminmaxloc(im)
    //
    // Parameters
    //    im : Input image.
    //    minValue : Row vector of per-channel minimum values.
    //    maxValue : Row vector of per-channel maximum values.
    //    minLocation : Channel-by-2 matrix of [row column] minimum locations.
    //    maxLocation : Channel-by-2 matrix of [row column] maximum locations.
    //
    // Authors
    //    Tan Chin Luh

    rhs = argn(2);
    if rhs <> 1 then
        error("imminmaxloc: Wrong number of input arguments.");
    end

    dims = size(im);
    if size(dims, "*") < 3 then
        channels = 1;
    else
        channels = dims(3);
    end
    minValue = zeros(1, channels);
    maxValue = zeros(1, channels);
    minLocation = zeros(channels, 2);
    maxLocation = zeros(channels, 2);

    for c = 1:channels
        if channels == 1 then
            plane = double(im);
        else
            plane = double(im(:, :, c));
        end
        minValue(c) = min(plane);
        maxValue(c) = max(plane);
        [r, col] = find(plane == minValue(c));
        minLocation(c, :) = [r(1), col(1)];
        [r, col] = find(plane == maxValue(c));
        maxLocation(c, :) = [r(1), col(1)];
    end
endfunction
