//=============================================================================
// IPCV - Scilab Image Processing and Computer Vision toolbox
// Copyright (C) 2017  Tan Chin Luh
//=============================================================================
function imout = imgradient(imin,se,iterations,anchor,borderType,borderValue)
    // Image gradient
    //
    // Syntax
    //    imout = imgradient(imin,se)
    //
    // Parameters
    //    imin : Input image
    //    se : Structure element
    //    imout : Output image
    //
    // Description
    //    This operation is the difference between the dilation and the erosion of an image.
    //    It is useful for finding the outline of an object .(it is assumed that the objects are bright on a dark foreground)
    //
    // Examples
    //    S = imread(fullpath(getIPCVpath() + "/images/morpex.png"));
    //    se = imcreatese('ellipse',3,3);
    //    S2 = imgradient(S,se);
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



    rhs=argn(2);

    if rhs < 2; error("Expect 2 arguments, input image and structure element"); end
    if rhs < 3 then iterations = 1; end
    if rhs < 4 then anchor = [-1 -1]; end
    if rhs < 5 then borderType = "constant"; end
    if rhs < 6 then borderValue = []; end
    // End of Error Checking


//    if type(imin(1)) == 1 | type(imin(1)) == 4 then
//        imin = im2uint8(imin);
//        imout = im2double(int_immorphologyex(imin,se,int8(4)));
//
//    else type(imin(1)) == 8
        if rhs < 6 then
            imout = immorphologyex(imin,se,"gradient",iterations,anchor,borderType);
        else
            imout = immorphologyex(imin,se,"gradient",iterations,anchor,borderType,borderValue);
        end
//    end



endfunction
