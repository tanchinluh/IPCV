function [mask, foreground] = imgrabcut(image, rect, iterations)
    // Extract a foreground region using OpenCV GrabCut.
    //
    // Syntax
    //    [mask, foreground] = imgrabcut(image, rect)
    //    [mask, foreground] = imgrabcut(image, rect, iterations)
    //
    // rect is [x y width height] in image coordinates with origin at the
    // upper-left corner. mask contains 0 or 1 values; foreground is black
    // outside the detected foreground.
    //
    // Examples
    //    image = imread(fullpath(getIPCVpath() + "/images/people.jpg"));
    //    [h, w] = size(image);
    //    rect = [round(w * 0.12) round(h * 0.08) round(w * 0.76) round(h * 0.84)];
    //    [mask, foreground] = imgrabcut(image, rect, 5);
    //    imshow(foreground);
    //
    // See also
    //    imsegkmeans
    //    imoverlaymask
    //
    // Authors
    //    Tan Chin Luh
    //
    // History
    //    5.0.0: Function introduced.

    rhs = argn(2);
    if rhs < 2 | rhs > 3 then error("imgrabcut: image and rectangle are required."); end
    if size(rect, "*") <> 4 then error("imgrabcut: rect must be [x y width height]."); end
    if rhs < 3 then iterations = 5; end
    [mask, foreground] = int_imgrabcut(image, rect, iterations);
endfunction
