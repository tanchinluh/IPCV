function mask = imsegactivecontour(image, initialMask, iterations, smoothing)
    // Apply a compact Chan-Vese-style region segmentation baseline.
    rhs = argn(2);
    if rhs < 2 | rhs > 4 then error("imsegactivecontour: image and initial mask are required."); end
    if rhs < 3 then iterations = 20; end
    if rhs < 4 then smoothing = 1; end
    values = im2double(image);
    if size(size(values), "*") == 3 then values = rgb2gray(values); end
    if size(initialMask, 1) <> size(values, 1) | size(initialMask, 2) <> size(values, 2) then error("imsegactivecontour: mask size must match image."); end
    if typeof(initialMask) == "boolean" then mask = initialMask; else mask = double(initialMask) <> 0; end
    for iter = 1:iterations
        inside = values(mask); outside = values(~mask);
        if isempty(inside) | isempty(outside) then break; end
        insideMean = mean(inside); outsideMean = mean(outside);
        score = (values - insideMean) .^ 2 - (values - outsideMean) .^ 2;
        mask = score < 0;
        for k = 1:smoothing
            mask = immajority(mask, [3 3]);
        end
    end
endfunction
