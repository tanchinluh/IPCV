//=============================================================================
// IPCV - Scilab Image Processing and Computer Vision toolbox
// Copyright (C) 2017  Tan Chin Luh
//=============================================================================
function So = imcontour2label(S,Sc)
    // Create a labeled image from the contours list
    //
    // Syntax
    //    So = imcontour2label(S,Sc)
    //
    // Parameters
    //     S : Input image
    //     Sc : Contours list
    //     So : Output labeled image
    //     
    // Description
    //    This function used to create a labeled image from a contours list
    //
    // Examples
    //     S = imread(fullpath(getIPCVpath() + "/images/coins_gray.jpg"));
    //     Sbw = im2bw(S,0.5);
    //     Sc = imfindContours(Sbw);
    //     So = imcontour2label(S,Sc);
    //     imshow(So,rainbow(size(Sc)));
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
    
    
    rhs=argn(2);
    total_cnts = size(Sc);
    // Error Checking
    if rhs < 2; error("This function needs at least 2 inputs"); end;
    
    So = zeros(S(:,:,1));
    
    for cnt = 1:total_cnts
        rect_coor = Sc(cnt);
        i = sub2ind(size(S(:,:,1)),rect_coor(:,$:-1:1));
        So(i) = cnt;
    end

endfunction
