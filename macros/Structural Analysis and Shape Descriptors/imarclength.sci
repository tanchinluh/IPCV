function length = imarclength(contours, closed)
    // Compute contour arc lengths or perimeters.
    //
    // Syntax
    //    length = imarclength(contours)
    //    length = imarclength(contours, closed)
    //
    // Parameters
    //    contours : Contour list returned by imfindContours.
    //    closed : If true, treat contours as closed curves. Default is %t.
    //    length : Column vector of contour arc lengths.
    //
    // Description
    //    imarclength computes OpenCV 5 arcLength for each contour.
    //
    // Examples
    //    im = imread(fullpath(getIPCVpath() + "/images/" + "star.png"));
    //    bw = im2bw(im, 0.5);
    //    contours = imfindContours(bw);
    //    perimeter = imarclength(contours);
    //
    // See also
    //    imfindContours
    //    imcontourarea
    //
    // Authors
    //    Tan Chin Luh

    rhs = argn(2);
    if rhs < 1 | rhs > 2 then
        error("imarclength: Wrong number of input arguments.");
    end
    if rhs < 2 then closed = %t; end

    if closed then
        closedValue = 1;
    else
        closedValue = 0;
    end

    length = int_imarclength(contours, closedValue);
endfunction
