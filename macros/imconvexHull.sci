//=============================================================================
// IPCV - Scilab Image Processing and Computer Vision toolbox
// Copyright (C) 2020  Tan Chin Luh
//=============================================================================
function H = imconvexHull(contours, cw, ind)
    // Finds the convex hull of a point set.
    //
    // Syntax
    //    H = imconvexHull(contours[, cw[, ind]])
    //
    // Parameters
    //    contours : Contours in list
    //    cw : Return points in clockwise or counter-clockwise direction, 0 as CCW, 1 as CW
    //    ind : Return points in image rectangular coordinate pairs or the indices of contours, 0 to return coor pairs, 1 to return indexes 
    //    H : Convex hulls in list in correspond to the contours
    //     
    // Description
    //    The functions find the convex hull of all the contours in list using the Sklansky's algorithm.
    //
    // Examples
    //    S = imread(fullpath(getIPCVpath() + "/images/hand.jpg"));
    //    Sbw = im2bw(~S,0.5);
    //    imshow(Sbw);
    //    Sc = imfindContours(Sbw);
    //    H = imconvexHull(Sc);
    //    implotContours(Sbw,lstcat(Sc, H),5)
    //  
    // See also
    //     imfindContours
    //     implotContours
    //     imconvexityDefects
    //
    // Authors
    //    Tan Chin Luh
    //
    
    rhs = argn(2);
    // Error Checking
    if rhs < 1; error("This function needs at least 1 input"); end;
    if rhs < 2; cw = 0; end;
    if rhs < 3; ind = 0; end;

    if cw == []; cw = 0; end;
    if ind == []; ind = 0; end;
    
    
    H = int_imconvexHull(contours, cw, ind);
    
endfunction
