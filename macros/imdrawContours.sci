//=============================================================================
// IPCV - Scilab Image Processing and Computer Vision toolbox
// Copyright (C) 2017  Tan Chin Luh
//=============================================================================
function So = imdrawContours(Sc,colormap,thickness)
    // Draw contours from the contour image.
    //
    // Syntax
    //    So = imdrawcontour(Sc)
    //    So = imdrawcontour(Sc,colormap)
    //    So = imdrawcontour(Sc,colormap,thickness)
    //
    // Parameters
    //     Sc : Input contour image
    //     colormap : Colormap used to draw the contour
    //     thickness : Thickness of the contours
    //     So : Output contours in RGB
    //     
    // Description
    //    This function used to draw the contours in RGB, with colormap and thickness.
    //
    // Examples
    //     S = imread(fullpath(getIPCVpath() + "/images/coins_gray.jpg"));
    //     Sbw = im2bw(S,0.5);
    //     Sc = imfindContours(Sbw);
    //     So = imdrawContours(Sc);
    //     imshow(So);
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
    total = max(Sc);
    // Error Checking
    if rhs < 2; colormap = rainbowcolormap(2^nextpow2(total)); end    
    if rhs < 3; thickness = 5; end    
    
    if colormap ==[]; colormap = rainbowcolormap(2^nextpow2(total));end
    
    se = imcreatese('ellipse',thickness,thickness);
    
    Sr = zeros(Sc);
    Sg = Sr;
    Sb = Sr;
    
    for cnt = 1:total
        Sc2 = Sc==cnt;
        Sc3 = imdilate(Sc2,se);
        Sr(Sc3) = colormap(cnt,1);
        Sg(Sc3) = colormap(cnt,2);
        Sb(Sc3) = colormap(cnt,3);        
    end
    So = Sr;
    So(:,:,2) = Sg;
    So(:,:,3) = Sb;
endfunction
