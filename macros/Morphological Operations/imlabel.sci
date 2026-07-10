//=============================================================================
// IPCV - Scilab Image Processing and Computer Vision toolbox
// Copyright (C) 2017  Tan Chin Luh
//=============================================================================

function [imout,n] = imlabel(imin, connectivity)
    // Find blobs in an image
    //
    // Syntax
    //     [imout,n] = imlabel(imin)
    //     [imout,n] = imlabel(imin, connectivity)
    //
    // Parameters
    //    imin : Source Image
    //    n : Number of detected objects
    //    imout : Labeled Image
    //    connectivity : Pixel connectivity, 4 or 8. Default is 4.
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
    //    imconnectedcomponents
    //
    // Authors
    //    Tan Chin Luh
    //
    
    if argn(2) < 2 then connectivity = 4; end
    mask = im2bw(imin, 0.5);
    [imout, n] = imconnectedcomponents(mask, connectivity);

endfunction
