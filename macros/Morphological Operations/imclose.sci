//=============================================================================
// IPCV - Scilab Image Processing and Computer Vision toolbox
// Copyright (C) 2017  Tan Chin Luh
//=============================================================================
function imout = imclose(imin,se,iterations,anchor,borderType,borderValue)
    // Image closing
    //
    // Syntax
    //    imout = imclose(imin,se)
    //
    // Parameters
    //    imin : Input image
    //    se : Structure element
    //    imout : Output image
    //
    // Description
    //    The function perform closing operation on the source image using the specified structuring element.
    //    This operation is same as obtained by the dilation of an image followed by an erosion.
    //    Useful to remove small holes.(it is assumed that the objects are bright on a dark foreground)
    //
    // Examples
    //    S = imread(fullpath(getIPCVpath() + "/images/morpex.png"));
    //    se = imcreatese('ellipse',11,11);
    //    S2 = imclose(S,se);
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
    if rhs < 3 then iterations = 1; end
    if rhs < 4 then anchor = [-1 -1]; end
    if rhs < 5 then borderType = "constant"; end
    if rhs < 6 then borderValue = []; end
    // End of Error Checking


//    if type(imin(1)) == 1 | type(imin(1)) == 4 then
//        imin = im2uint8(imin);
//        imout = im2double(int_immorphologyex(imin,se,int8(3)));
//
//    else type(imin(1)) == 8
        if rhs < 6 then
            imout = immorphologyex(imin,se,"close",iterations,anchor,borderType);
        else
            imout = immorphologyex(imin,se,"close",iterations,anchor,borderType,borderValue);
        end
//    end



endfunction
