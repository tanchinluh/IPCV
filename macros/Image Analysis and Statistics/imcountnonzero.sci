function count = imcountnonzero(im)
    // Count nonzero pixels per image channel.
    //
    // Syntax
    //    count = imcountnonzero(im)
    //
    // Parameters
    //    im : Input image.
    //    count : Row vector of per-channel nonzero counts.
    //
    // Description
    //    imcountnonzero counts nonzero pixels in each channel.
    //
    // Examples
    //    bw = [%t %f; %t %t];
    //    count = imcountnonzero(bw);
    //
    // See also
    //    immeanstddev
    //    imminmax
    //
    // Authors
    //    Tan Chin Luh

    rhs = argn(2);
    if rhs <> 1 then
        error("imcountnonzero: Wrong number of input arguments.");
    end

    dims = size(im);
    if size(dims, "*") < 3 then
        channels = 1;
    else
        channels = dims(3);
    end

    count = zeros(1, channels);
    for c = 1:channels
        if channels == 1 then
            values = matrix(im, -1, 1);
        else
            values = matrix(im(:, :, c), -1, 1);
        end
        count(c) = sum(values <> 0);
    end
endfunction
