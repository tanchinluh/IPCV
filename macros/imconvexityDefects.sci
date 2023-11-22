//=============================================================================
// IPCV - Scilab Image Processing and Computer Vision toolbox
// Copyright (C) 2020  Tan Chin Luh
//=============================================================================
function D = imconvexityDefects(contours, hullinds)
    // Finds the convexity defects of a contour.
    //
    // Syntax
    //    D = imconvexityDefects(contours, hullinds)
    //
    // Parameters
    //    contours : Contours in list
    //    hullinds : Indices of contours which representing convex hulls in list of each contours.
    //    D : The output vector of convexity defects.(start_index, end_index, farthest_pt_index, fixpt_depth)
    //     
    // Description
    //    The functions finds the convexity defects of a contour.
    //
    // Examples
    //    S = imread(fullpath(getIPCVpath() + "/images/star.png"));
    //    Sbw = im2bw(S,0.5);
    //    Sc = imfindContours(Sbw);
    //    H = imconvexHull(Sc,0,1);
    //    D = imconvexityDefects(Sc,H)
    //    d = D(1);
    //    f = Sc(1)(d(:,3),:)
    //    [cart_ff] = rect2cart(size(S)(1:2), f);
    //    imshow(Sbw);
    //    plot(cart_ff(:,1),cart_ff(:,2),'g*')
    // 
    // See also
    //     imfindContours
    //     implotContours
    //     imconvexHull
    //
    // Authors
    //    Tan Chin Luh
    //
    
    rhs = argn(2);
    // Error Checking
    if rhs < 2; error("This function needs at least 2 inputs"); end;

    D = int_imconvexityDefects(contours, hullinds);
    
endfunction
