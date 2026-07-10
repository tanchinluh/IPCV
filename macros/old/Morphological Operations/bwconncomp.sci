function [labels, count, stats, centroids] = bwconncomp(image, connectivity)
    // Connected-component entry point with IPCV matrix outputs.
    if argn(2) < 2 then connectivity = 8; end
    [labels, count, stats, centroids] = imconnectedcomponents(image, connectivity);
endfunction
