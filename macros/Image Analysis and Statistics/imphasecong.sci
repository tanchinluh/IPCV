function out = imphasecong(image, threshold)
    // Return a phase-congruency-inspired edge map.
    rhs = argn(2);
    if rhs < 1 | rhs > 2 then error("imphasecong: invalid arguments."); end
    if rhs < 2 then threshold = 0.15; end
    values = im2double(image);
    if size(size(values), "*") == 3 then values = rgb2gray(values); end
    gx = imfilter2(values, [-1 0 1; -2 0 2; -1 0 1]);
    gy = imfilter2(values, [-1 -2 -1; 0 0 0; 1 2 1]);
    magnitude = sqrt(gx .* gx + gy .* gy);
    out = magnitude > threshold * max(magnitude);
endfunction
