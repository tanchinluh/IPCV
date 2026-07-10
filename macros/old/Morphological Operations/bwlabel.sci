function [labels, count] = bwlabel(image, connectivity)
    // MATLAB-style connected-component labeling entry point.
    if argn(2) < 2 then connectivity = 4; end
    [labels, count] = imlabel(image, connectivity);
endfunction
