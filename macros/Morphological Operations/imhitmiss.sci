//=============================================================================
// IPCV - Scilab Image Processing and Computer Vision toolbox
// Copyright (C) 2017  Tan Chin Luh
//=============================================================================
function imout = imhitmiss(imin,se,iterations,anchor,borderType,borderValue)
    // Image Hit-Miss
    //
    // Syntax
    //    imout = imhitmiss(imin,se)
    //
    // Parameters
    //    imin : Input image
    //    se : Structure element
    //    imout : Output image
    //
    // Description
    //    The function perform hit-miss operation on the source image using the specified structuring element.
    //
    // Examples
    //    S = imread(fullpath(getIPCVpath() + "/images/morpex.png"));
    //    se = imcreatese('ellipse',11,11);
    //    S2 = imhitmiss(S,se);
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

    if typeof(imin(1)) == 'uint8' & size(imin,3) == 1
        if rhs < 6 then
            imout = immorphologyex(imin,se,"hitmiss",iterations,anchor,borderType);
        else
            imout = immorphologyex(imin,se,"hitmiss",iterations,anchor,borderType,borderValue);
        end
    elseif typeof(imin(1)) == 'boolean' & size(imin,3) == 1
        if rhs < 6 then
            imout = immorphologyex(imin,se,"hitmiss",iterations,anchor,borderType);
        else
            imout = immorphologyex(imin,se,"hitmiss",iterations,anchor,borderType,borderValue);
        end
    else
        error("Hit and Miss only supports single layer uint8 or binary image."); 
    end
    

//    if type(imin(1)) == 1 | type(imin(1)) == 4 then
//        imin = im2uint8(imin);
//        imout = im2double(int_immorphologyex(imin,se,int8(3)));
//
//    else type(imin(1)) == 8
        
//    end



endfunction
