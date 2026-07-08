//=============================================================================
// IPCV - Scilab Image Processing and Computer Vision toolbox
// Copyright (C) 2017  Tan Chin Luh
//=============================================================================

function [imout,n] = imlabel(imin)
    // Find blobs in an image
    //
    // Syntax
    //     [imout,n] = imlabel(imin)
    //
    // Parameters
    //    imin : Source Image
    //    n : Number of detected objects
    //    imout : Labeled Image
    //
    // Description
    //    This function find all components on an image.
    //
    // Examples
    //    A = imread(fullpath(getIPCVpath() + "/images/coins_gray.jpg"));
    //    A_edge = edge(A,'canny');
    //    se = imcreatese('ellipse',15,15);
    //    A_dilate = imdilate(A_edge,se);
    //    [A_labeled,n] = imlabel(A_dilate);
    //    imshow(A_labeled,jet(n));
    //
    // See also
    //    imblobprop
    //
    // Authors
    //    Tan Chin Luh
    //
    
    mask = im2bw(imin,0.5).*1;
    imout = int_imlabel(mask);
    n = double(max(imout));

endfunction
