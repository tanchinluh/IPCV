function result = imtexture(image, window)
    // Return local mean, standard deviation, entropy, and contrast maps.
    if argn(2) < 1 | argn(2) > 2 then error("imtexture: invalid arguments."); end
    if argn(2) < 2 then window = [7 7]; end
    values = im2double(image); meanMap = imlocalmean(values, window); stdMap = imlocalstd(values, window);
    entropyMap = imlocalentropy(values, window); contrastMap = stdMap ./ (meanMap + %eps);
    result = struct("Mean", meanMap, "Std", stdMap, "Entropy", entropyMap, "Contrast", contrastMap);
endfunction
