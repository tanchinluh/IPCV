//=============================================================================
// IPCV - Scilab Image Processing and Computer Vision toolbox
// Copyright (C) 2017  Tan Chin Luh
//=============================================================================
function imout = imthin(imin, method)
    // Binary image thinning
    //
    // Syntax
    //    imout = imthin(imin)
    //    imout = imthin(imin, method)
    //
    // Parameters
    //    imin : Single channel input image
    //    method : Thinning method, "zhang-suen" or "guo-hall". Default is "zhang-suen"
    //    imout : Output skeleton image
    //
    // Description
    //    Applies OpenCV ximgproc thinning to a single channel image. Non-zero pixels
    //    are treated as foreground and the result is returned as a uint8 binary image.
    //
    // Examples
    //    a = uint8(zeros(9, 9));
    //    a(3:7, 5) = 255;
    //    a(5, 3:7) = 255;
    //    b = imthin(a, "guo-hall");
    //    disp(b);
    //
    // See also
    //    imcreatese
    //    imerode
    //    imdilate
    //    immorphologyex
    //
    // Authors
    //    Tan Chin Luh
    //

    rhs = argn(2);
    if rhs < 1 then
        error("Expect at least 1 argument, input image");
    end
    if rhs < 2 then
        method = "zhang-suen";
    end

    if size(imin, 3) <> 1 then
        error("imthin expects a single channel image.");
    end

    if type(method) == 10 then
        key = convstr(method, "l");
        select key
        case "zhang-suen" then
            methodValue = 0;
        case "zhangsuen" then
            methodValue = 0;
        case "guo-hall" then
            methodValue = 1;
        case "guohall" then
            methodValue = 1;
        else
            error("Unsupported thinning method. Use ''zhang-suen'' or ''guo-hall''.");
        end
    else
        methodValue = round(method);
    end

    imout = int_imthin(imin, int8(methodValue));
endfunction
