function score = imbackproject(image, model, bins)
    // Compute a histogram back-projection score for a model image or mask.
    if argn(2) < 2 | argn(2) > 3 then error("imbackproject: image and model are required."); end
    if argn(2) < 3 then bins = 32; end
    if bins < 2 then error("imbackproject: bins must be at least 2."); end
    source = im2double(image); reference = im2double(model);
    if size(size(source), "*") == 3 then source = rgb2gray(source); end
    if size(size(reference), "*") == 3 then reference = rgb2gray(reference); end
    source = min(max(source, 0), 1); reference = min(max(reference, 0), 1);
    h = zeros(bins, 1); for k = 1:size(reference, "*"); idx = floor(reference(k) * (bins - 1)) + 1; h(idx) = h(idx) + 1; end
    h = h / max(sum(h), 1); idx = floor(source * (bins - 1)) + 1; score = h(idx);
endfunction
