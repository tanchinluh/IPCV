function [counts, xcells, ycells] = imhist2(x, y, bins)
    // Compute a two-dimensional joint histogram.
    //
    // Syntax
    //    [counts, xcells, ycells] = imhist2(x, y)
    //    [counts, xcells, ycells] = imhist2(x, y, bins)
    //
    // Authors
    //    Tan Chin Luh

    rhs = argn(2);
    if rhs < 2 | rhs > 3 then
        error("imhist2: Wrong number of input arguments.");
    end
    if rhs < 3 then bins = [32 32]; end
    if size(bins, "*") == 1 then bins = [bins bins]; end
    if or(size(x) <> size(y)) then
        error("imhist2: inputs must have the same size.");
    end

    xv = matrix(double(x), -1, 1);
    yv = matrix(double(y), -1, 1);
    xcells = linspace(min(xv), max(xv), bins(1));
    ycells = linspace(min(yv), max(yv), bins(2));
    if bins(1) > 1 then xedges = [xcells, xcells($) + (xcells(2) - xcells(1))] - (xcells(2) - xcells(1)) / 2; else xedges = [xcells(1)-0.5 xcells(1)+0.5]; end
    if bins(2) > 1 then yedges = [ycells, ycells($) + (ycells(2) - ycells(1))] - (ycells(2) - ycells(1)) / 2; else yedges = [ycells(1)-0.5 ycells(1)+0.5]; end

    counts = zeros(bins(1), bins(2));
    [xi] = dsearch(xv, xedges);
    [yi] = dsearch(yv, yedges);
    for i = 1:size(xi, "*")
        if xi(i) >= 1 & xi(i) <= bins(1) & yi(i) >= 1 & yi(i) <= bins(2) then
            counts(xi(i), yi(i)) = counts(xi(i), yi(i)) + 1;
        end
    end
    xcells = xcells';
    ycells = ycells';
endfunction
