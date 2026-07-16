function [labels, contours] = imsuperpixels(image, regionSize, ruler, iterations)
    // Generate SLICO superpixels using OpenCV contrib.
    //
    // Syntax
    //    [labels, contours] = imsuperpixels(image)
    //    [labels, contours] = imsuperpixels(image, regionSize, ruler, iterations)
    //
    // labels is a zero-based superpixel label image. contours is a uint8
    // boundary image. OpenCV 5 ximgproc is required by the native backend.
    //
    // Examples
    //    image = imread(fullpath(getIPCVpath() + "/images/baboon.png"));
    //    [labels, contours] = imsuperpixels(image, 24, 10, 10);
    //    overlay = image;
    //    overlay(repmat(contours == 255, 1, 1, 3)) = 255;
    //    imshow(overlay);
    //
    // See also
    //    imsegkmeans
    //    imlabel2rgb
    //
    // Authors
    //    Tan Chin Luh
    //
    // History
    //    5.0.0: Function introduced.

    rhs = argn(2);
    if rhs < 1 | rhs > 4 then error("imsuperpixels: Wrong number of input arguments."); end
    if rhs < 2 then regionSize = 20; end
    if rhs < 3 then ruler = 10; end
    if rhs < 4 then iterations = 10; end
    [labels, contours] = int_imsuperpixels(image, regionSize, ruler, iterations);
endfunction
