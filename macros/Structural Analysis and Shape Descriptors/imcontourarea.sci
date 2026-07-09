function area = imcontourarea(contours, oriented)
    // Compute contour areas.
    //
    // Syntax
    //    area = imcontourarea(contours)
    //    area = imcontourarea(contours, oriented)
    //
    // Parameters
    //    contours : Contour list returned by imfindContours.
    //    oriented : If true, return signed areas. Default is %f.
    //    area : Column vector of contour areas.
    //
    // Description
    //    imcontourarea computes OpenCV 5 contourArea for each contour.
    //
    // Examples
    //    im = imread(fullpath(getIPCVpath() + "/images/" + "star.png"));
    //    bw = im2bw(im, 0.5);
    //    contours = imfindContours(bw);
    //    area = imcontourarea(contours);
    //
    // See also
    //    imfindContours
    //    imarclength
    //
    // Authors
    //    Tan Chin Luh

    rhs = argn(2);
    if rhs < 1 | rhs > 2 then
        error("imcontourarea: Wrong number of input arguments.");
    end
    if rhs < 2 then oriented = %f; end

    if oriented then
        orientedValue = 1;
    else
        orientedValue = 0;
    end

    area = int_imcontourarea(contours, orientedValue);
endfunction
