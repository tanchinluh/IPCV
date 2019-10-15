//=============================================================================
// IPCV - Scilab Image Processing and Computer Vision toolbox
// Copyright (C) 2017  Tan Chin Luh
//=============================================================================
function H = imconvexHull(pts)
    // Finds the convex hull of a point set.
    //
    // Syntax
    //    H = imconvexHull(pts)
    //
    // Parameters
    //    pts : Input 2D point set.
    //    H : Output convexhull
    //     
    // Description
    //    The functions find the convex hull of a 2D point set using the Sklansky's algorithm.
    //
    // Examples
    //    S = imread(fullpath(getIPCVpath() + "/images/hand.jpg"));
    //    Sbw = im2bw(~S,0.5);
    //    imshow(Sbw);
    //    Sc = imfindContours(Sbw);
    //    [A, BB, ctr] = imblobprop(Sc);
    //    [maxV,maxI] = max(A);
    //    [row,col] = find(Sc==maxI);
    //    [cart_x,cart_y] = sub2cartesian(size(Sc), row,col);
    //    SS = [(cart_x)',(cart_y)'];
    //    H = imconvexHull(SS);
    //    sz = size(S);
    //    plot(cart_x,cart_y,'.');
    //    Hd = double(H);
    //    plot(Hd(:,1),Hd(:,2),'r');
    //  
    // See also
    //     imfindContours
    //     imdrawContours
    //     imconvexHull
    //
    // Authors
    //    Tan Chin Luh
    //
    // Bibliography
    //    1. OpenCV 2.4 Online Documentation
    
    
    if size(pts,1) == 2 then
        pts = pts';
    elseif size(pts,2) == 2
        pts = pts;
    else
        error('Input vector must be either 2 rows or 2 columns');
    end
    
    H=int_imconvexHull(SS);
    
endfunction
