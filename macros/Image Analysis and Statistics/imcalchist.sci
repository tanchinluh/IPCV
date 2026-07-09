function [counts, cells] = imcalchist(im, bins)
    // Compute per-channel image histograms.
    //
    // Syntax
    //    [counts, cells] = imcalchist(im)
    //    [counts, cells] = imcalchist(im, bins)
    //
    // Authors
    //    Tan Chin Luh

    rhs = argn(2);
    if rhs < 1 | rhs > 2 then
        error("imcalchist: Wrong number of input arguments.");
    end
    if rhs < 2 then bins = []; end

    dims = size(im);
    if size(dims, "*") < 3 then
        if size(bins, "*") == 0 then
            [counts, cells] = imhist(im);
        else
            [counts, cells] = imhist(im, bins);
        end
    else
        channels = dims(3);
        for c = 1:channels
            if size(bins, "*") == 0 then
                [cnt, cells] = imhist(im(:, :, c));
            else
                [cnt, cells] = imhist(im(:, :, c), bins);
            end
            if c == 1 then
                counts = zeros(size(cnt, "*"), channels);
            end
            counts(:, c) = cnt;
        end
    end
endfunction
