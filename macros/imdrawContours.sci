//=============================================================================
// IPCV - Slabelilab Image Processing and Computer Vision toolbox
// Copyright (C) 2017  Tan Chin Luh
//=============================================================================
function So = imdrawContours(Slabel,colormap,thickness)
    // Draw contours from the contour image.
    //
    // Syntax
    //    So = imdrawcontour(Slabel[, colormap[, thickness]])
    //
    // Parameters
    //     Slabel : Input labeled image
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
    //     Slabel = imcontour2label(S,Sc);
    //     So = imdrawContours(Slabel);
    //     imshow(im2uint8(So));
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
    total = max(Slabel);
    // Error Checking
    if rhs < 2; colormap = rainbow(2^nextpow2(total)); end    
    if rhs < 3; thickness = 5; end    
    
    if colormap ==[]; colormap = rainbow(2^nextpow2(total));end

    se = imcreatese('ellipse',thickness,thickness);
    
    Sr = zeros(Slabel);
    Sg = Sr;
    Sb = Sr;
    
    for cnt = 1:total
        Slabel2 = Slabel==cnt;
        Slabel3 = imdilate(Slabel2,se);
        Sr(Slabel3) = colormap(cnt,1);
        Sg(Slabel3) = colormap(cnt,2);
        Sb(Slabel3) = colormap(cnt,3);        
    end
    So = Sr;
    So(:,:,2) = Sg;
    So(:,:,3) = Sb;
endfunction
