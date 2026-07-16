function out = imguidedfilter(inputImage, guide, radius, epsilon)
    // Apply a grayscale guided-filter approximation.
    rhs = argn(2); if rhs < 1 | rhs > 4 then error("imguidedfilter: invalid arguments."); end
    if rhs < 2 then guide = inputImage; end
    if rhs < 3 then radius = 4; end
    if rhs < 4 then epsilon = 0.01; end
    if radius < 1 | epsilon <= 0 then error("imguidedfilter: radius must be positive and epsilon must be positive."); end
    if size(size(inputImage), "*") == 3 then inputValues = rgb2gray(inputImage); else inputValues = inputImage; end
    if size(size(guide), "*") == 3 then guideValues = rgb2gray(guide); else guideValues = guide; end
    window = [2 * round(radius) + 1 2 * round(radius) + 1]; p = im2double(inputValues); g = im2double(guideValues);
    meanG = imlocalmean(g, window); meanP = imlocalmean(p, window); corrG = imlocalmean(g .* g, window); corrGP = imlocalmean(g .* p, window);
    varianceG = max(corrG - meanG .* meanG, 0); coefficient = (corrGP - meanG .* meanP) ./ (varianceG + epsilon); intercept = meanP - coefficient .* meanG;
    out = imlocalmean(coefficient, window) .* g + imlocalmean(intercept, window);
endfunction
