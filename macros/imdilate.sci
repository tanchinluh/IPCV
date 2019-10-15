//=============================================================================
// IPCV - Scilab Image Processing and Computer Vision toolbox
// Copyright (C) 2017  Tan Chin Luh
//=============================================================================
function imout = imdilate(imin,se)
    // Image dilation
    //
    // Syntax
    //    imout = imdilate(imin,se)
    //
    // Parameters
    //    imin : Input image
    //    se : Structure element
    //    imout : Output image
    //
    // Description
    //    The function dilates the source image using the specified structuring element 
    //    that determines the shape of a pixel neighborhood over which the maximum is taken.
    //
    // Examples
    //    a = zeros(10,10);
    //    a(4:7,4:7) = 1;
    //    se = imcreatese('rect',3,3);
    //    b = imdilate(a,se);
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
    // End of Error Checking

    imout = int_imdilate(imin,se);
//    if type(imin(1)) == 1 | type(imin(1)) == 4 then
//        imin = im2uint8(imin);
//        imout = im2double(int_imdilate(imin,se));
//    else type(imin(1)) == 8
//        imout = int_imdilate(imin,se);
//    end



endfunction



