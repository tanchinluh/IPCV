//=============================================================================
// IPCV - Scilab Image Processing and Computer Vision toolbox
// Copyright (C) 2017  Tan Chin Luh
//=============================================================================
function imout = immorphologyex(imin, se, operation, iterations, anchor, borderType, borderValue)
    // Generic OpenCV morphology operation
    //
    // Syntax
    //    imout = immorphologyex(imin, se, operation)
    //    imout = immorphologyex(imin, se, operation, iterations)
    //    imout = immorphologyex(imin, se, operation, iterations, anchor, borderType, borderValue)
    //
    // Parameters
    //    imin : Input image
    //    se : Structuring element
    //    operation : Operation name: "erode", "dilate", "open", "close", "gradient", "tophat", "blackhat", or "hitmiss"
    //    iterations : Number of operation iterations. Default is 1
    //    anchor : Two element [row col] anchor. Default is [-1 -1]
    //    borderType : Border mode name or OpenCV numeric border constant. Default is "constant"
    //    borderValue : Constant border value. If omitted, OpenCV default morphology border value is used
    //    imout : Output image
    //
    // Description
    //    Applies OpenCV morphologyEx using IPCV image exchange. This is the generic
    //    entry point behind imopen, imclose, imgradient, imtophat, imblackhat, and imhitmiss.
    //
    // Examples
    //    S = imread(fullpath(getIPCVpath() + "/images/morpex.png"));
    //    se = imcreatese("diamond", 5, 5);
    //    S2 = immorphologyex(S, se, "gradient", 2);
    //    imshow(S2);
    //
    // See also
    //    imcreatese
    //    imdilate
    //    imerode
    //    imopen
    //    imclose
    //    imthin
    //
    // Authors
    //    Tan Chin Luh
    //

    rhs = argn(2);
    if rhs < 3 then
        error("Expect at least 3 arguments, input image, structure element and operation");
    end
    if rhs < 4 then iterations = 1; end
    if rhs < 5 then anchor = [-1 -1]; end
    if rhs < 6 then borderType = "constant"; end
    if rhs < 7 then
        useDefaultBorderValue = 1;
        borderValue = 0;
    else
        useDefaultBorderValue = 0;
    end

    if size(anchor, "*") <> 2 then
        error("Anchor must be a two element [row col] vector.");
    end

    opValue = ipcv_morphology_operation(operation);
    borderTypeValue = ipcv_morphology_border_type(borderType);
    imout = int_immorphologyex(imin, se, int8(opValue), iterations, round(anchor(1)), round(anchor(2)), borderTypeValue, useDefaultBorderValue, borderValue);
endfunction
