function corners = imcorner(image, maxCorners, qualityLevel, minDistance)
    // Detect Harris/Shi-Tomasi-style image corners.
    //
    // Syntax
    //    corners = imcorner(image)
    //    corners = imcorner(image, maxCorners, qualityLevel, minDistance)
    //
    // corners is an N-by-2 matrix of [x y] image coordinates with the origin
    // at the upper-left image corner.
    //
    // Examples
    //    image = imread(fullpath(getIPCVpath() + "/images/checkerbox.png"));
    //    corners = imcorner(image, 100, 0.01, 3);
    //    imshow(image);
    //    pts = rect2cart(size(image)(1:2), corners);
    //    plot(pts(:, 1), pts(:, 2), "r.");
    //
    // See also
    //    imdetect_GFTT
    //    imdetect
    //
    // Authors
    //    Tan Chin Luh
    //
    // History
    //    5.0.0: Function introduced.
    if argn(2) < 1 | argn(2) > 4 then error("imcorner: invalid arguments."); end
    if argn(2) < 2 then maxCorners = 100; end
    if argn(2) < 3 then qualityLevel = 0.01; end
    if argn(2) < 4 then minDistance = 3; end
    feature = imdetect_GFTT(image, maxCorners, qualityLevel, minDistance, 3, 0.04);
    if feature.n == 0 then corners = zeros(0, 2); else corners = [feature.x' feature.y']; end
endfunction
