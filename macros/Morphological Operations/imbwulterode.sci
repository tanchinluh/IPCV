function out = imbwulterode(image, metric)
    // Mark ultimate-erosion centers using distance-transform maxima.
    rhs = argn(2);
    if rhs < 1 | rhs > 2 then error("imbwulterode: invalid arguments."); end
    if rhs < 2 then metric = "euclidean"; end
    distance = imbwdist(image, metric);
    out = imregionalmax(distance) & distance > 0;
endfunction
