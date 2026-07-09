function m = immatch(des1, des2, method, normType)
    // Match feature descriptors.
    //
    // Syntax
    //    m = immatch(des1, des2)
    //    m = immatch(des1, des2, method)
    //    m = immatch(des1, des2, method, normType)
    //
    // Parameters
    //    des1 : First descriptor matrix.
    //    des2 : Second descriptor matrix.
    //    method : "BruteForce" or "FLANN". Default is "BruteForce".
    //    normType : OpenCV norm type used for brute-force matching. Default is 4 for uint8 descriptors and 2 otherwise.
    //    m : Matching matrix.
    //
    // Description
    //    immatch provides a compact dispatcher over the existing matcher wrappers.
    //
    // Examples
    //    im = imread(fullpath(getIPCVpath() + "/images/" + "balloons_gray.png"));
    //    f = imdetect(im, "ORB");
    //    d = imextract(im, f);
    //    m = immatch(d, d);
    //
    // See also
    //    imdetect
    //    imextract
    //    imbestmatches
    //    imdrawmatches
    //
    // Authors
    //    Tan Chin Luh

    rhs = argn(2);
    if rhs < 2 | rhs > 4 then
        error("immatch: Wrong number of input arguments.");
    end
    if rhs < 3 then
        method = "BruteForce";
    end
    if typeof(method) <> "string" | size(method, "*") <> 1 then
        error("immatch: method must be a scalar string.");
    end

    select convstr(method, "u")
    case "BRUTEFORCE" then
        if rhs < 4 then
            if typeof(des1) == "uint8" then
                normType = 4;
            else
                normType = 2;
            end
        end
        m = immatch_BruteForce(des1, des2, normType);
    case "BF" then
        if rhs < 4 then
            if typeof(des1) == "uint8" then
                normType = 4;
            else
                normType = 2;
            end
        end
        m = immatch_BruteForce(des1, des2, normType);
    case "FLANN" then
        m = immatch_Flann(des1, des2);
    else
        error("immatch: Unsupported matcher method.");
    end
endfunction
