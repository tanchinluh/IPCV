function fobj = imdetect(im, method)
    // Detect image features using a named detector.
    //
    // Syntax
    //    fobj = imdetect(im)
    //    fobj = imdetect(im, method)
    //
    // Parameters
    //    im : Input image.
    //    method : Detector name. Supported values are "ORB", "SIFT", "BRISK", "FAST", "GFTT", "MSER", "STAR", and "SURF". Default is "ORB".
    //    fobj : Feature object returned by the selected detector.
    //
    // Description
    //    imdetect provides a compact dispatcher over the individual detector wrappers.
    //
    // Examples
    //    im = imread(fullpath(getIPCVpath() + "/images/" + "balloons_gray.png"));
    //    f = imdetect(im, "ORB");
    //    imshow(im); plotfeature(f);
    //
    // See also
    //    imextract
    //    immatch
    //    plotfeature
    //
    // Authors
    //    Tan Chin Luh

    rhs = argn(2);
    if rhs < 1 | rhs > 2 then
        error("imdetect: Wrong number of input arguments.");
    end
    if rhs < 2 then
        method = "ORB";
    end
    if typeof(method) <> "string" | size(method, "*") <> 1 then
        error("imdetect: method must be a scalar string.");
    end

    select convstr(method, "u")
    case "ORB" then
        fobj = imdetect_ORB(im);
    case "SIFT" then
        fobj = imdetect_SIFT(im);
    case "BRISK" then
        fobj = imdetect_BRISK(im);
    case "FAST" then
        fobj = imdetect_FAST(im);
    case "GFTT" then
        fobj = imdetect_GFTT(im);
    case "MSER" then
        fobj = imdetect_MSER(im);
    case "STAR" then
        fobj = imdetect_STAR(im);
    case "SURF" then
        fobj = imdetect_SURF(im);
    else
        error("imdetect: Unsupported detector method.");
    end
endfunction
