function des = imextract(im, fobj, method)
    // Extract descriptors for a feature object.
    //
    // Syntax
    //    des = imextract(im, fobj)
    //    des = imextract(im, fobj, method)
    //
    // Parameters
    //    im : Input image.
    //    fobj : Feature object returned by imdetect or an individual detector.
    //    method : Descriptor method. Default is fobj.type.
    //    des : Descriptor matrix.
    //
    // Description
    //    imextract dispatches to ORB, SIFT, BRISK, or SURF descriptor extractors.
    //
    // Examples
    //    im = imread(fullpath(getIPCVpath() + "/images/" + "balloons_gray.png"));
    //    f = imdetect(im, "ORB");
    //    d = imextract(im, f);
    //
    // See also
    //    imdetect
    //    immatch
    //
    // Authors
    //    Tan Chin Luh

    rhs = argn(2);
    if rhs < 2 | rhs > 3 then
        error("imextract: Wrong number of input arguments.");
    end
    if rhs < 3 then
        if type(fobj) <> 17 | ~isfield(fobj, "type") then
            error("imextract: method is required when fobj.type is not available.");
        end
        method = fobj.type;
    end
    if typeof(method) <> "string" | size(method, "*") <> 1 then
        error("imextract: method must be a scalar string.");
    end

    select convstr(method, "u")
    case "ORB" then
        des = imextract_DescriptorORB(im, fobj);
    case "SIFT" then
        des = imextract_DescriptorSIFT(im, fobj);
    case "BRISK" then
        des = imextract_DescriptorBRISK(im, fobj);
    case "SURF" then
        des = imextract_DescriptorSURF(im, fobj);
    else
        error("imextract: Unsupported descriptor method.");
    end
endfunction
