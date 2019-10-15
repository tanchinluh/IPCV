//=============================================================================
// IPCV - Scilab Image Processing and Computer Vision toolbox
// Copyright (C) 2017  Tan Chin Luh
//=============================================================================
function imout = imtophat(imin,se)
    // Image tophat
    //
    // Syntax
    //    imout = imtophat(imin,se)
    //
    // Parameters
    //    imin : Input image
    //    se : Structure element
    //    imout : Output image
    //
    // Description
    //    This operation is the difference between an input image and its opening
    //
    // Examples
    //    S = imread(fullpath(getIPCVpath() + "/images/morpex.png"));
    //    se = imcreatese('ellipse',7,7);
    //    S2 = imtophat(S,se);
    //    imshow(S2);
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


//    if type(imin(1)) == 1 | type(imin(1)) == 4 then
//        imin = im2uint8(imin);
//        imout = im2double(int_immorphologyex(imin,se,int8(5)));
//
//    else type(imin(1)) == 8
        imout = int_immorphologyex(imin,se,int8(5));
//    end



endfunction

