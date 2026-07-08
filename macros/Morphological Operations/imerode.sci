//=============================================================================
// IPCV - Scilab Image Processing and Computer Vision toolbox
// Copyright (C) 2017  Tan Chin Luh
//=============================================================================

function imout = imerode(imin,se,iterations,anchor,borderType,borderValue)
    // Image erosion
    //
    // Syntax
    //    imout = imerode(imin,se)
    //    imout = imerode(imin,se,iterations)
    //    imout = imerode(imin,se,iterations,anchor,borderType,borderValue)
    //
    // Parameters
    //    imin : Input image
    //    se : Structure element
    //    iterations : Number of erosion iterations. Default is 1
    //    anchor : Two element [row col] anchor. Default is [-1 -1]
    //    borderType : Border mode name or OpenCV numeric border constant. Default is "constant"
    //    borderValue : Constant border value. If omitted, OpenCV default morphology border value is used
    //    imout : Output image
    //
    // Description
    //    The function erodes the source image using the specified structuring element 
    //    that determines the shape of a pixel neighborhood over which the minimum is taken.
    // 
    // Examples
    //    a = zeros(10,10);
    //    a(4:7,4:7) = 1;
    //    se = imcreatese('rect',3,3);
    //    b = imerode(a,se);
    //    disp(b);
    //
    // See also
    //    imcreatese
    //    imdilate
    //    imerode
    //    imopen
    //    imclose
    //    imgradient
    //    imtophat
    //    imblackhat
    //    imhitmiss
    //
    // Authors
    //    Tan Chin Luh
    //


    //

    rhs=argn(2);

    if rhs < 2; error("Expect 2 arguments, input image and structure element"); end
    if rhs < 3 then iterations = 1; end
    if rhs < 4 then anchor = [-1 -1]; end
    if rhs < 5 then borderType = "constant"; end
    if rhs < 6 then
        useDefaultBorderValue = 1;
        borderValue = 0;
    else
        useDefaultBorderValue = 0;
    end
    if size(anchor, "*") <> 2 then
        error("Anchor must be a two element [row col] vector.");
    end
    // End of Error Checking


//    if type(imin(1)) == 1 | type(imin(1)) == 4 then
//        imin = im2uint8(imin);
//        imout = im2double(int_imerode(imin,se));
//    else type(imin(1)) == 8
        borderTypeValue = ipcv_morphology_border_type(borderType);
        imout = int_imerode(imin,se,iterations,round(anchor(1)),round(anchor(2)),borderTypeValue,useDefaultBorderValue,borderValue);
//    end






endfunction
