//=============================================================================
// IPCV - Scilab Image Processing and Computer Vision toolbox
// Copyright (C) 2020  Tan Chin Luh
//=============================================================================
function implotContours(img, cntr, thickness)
    // Plot contours on image.
    //
    // Syntax
    //    implotContours(img, cntr[, thickness])
    //
    // Parameters
    //     img : Input image
    //     cntr : Contour in list
    //     thickness : Thickness of the contours
    //     
    // Description
    //    This function used to plot the contours on an image.
    //
    // Examples
    //     S = imread(fullpath(getIPCVpath() + "/images/coins_gray.jpg"));
    //     Sbw = im2bw(S,0.5);
    //     Sc = imfindContours(Sbw);
    //     implotContours(S,Sc,5)
    //  
    // See also
    //     imfindContours
    //     imconvexHull
    //     imconvexityDefects
    //
    // Authors
    //    Tan Chin Luh
    //
    
    rhs=argn(2);
    // Error Checking
    if rhs < 2; error("This function needs at least 2 inputs"); end    
    if rhs < 3; thickness = 1; end  
      
    if thickness == []; thickness = 1; end  
    
    
    f = gcf();
    f.visible = 'off';
    f.color_map = hsv(size(cntr));  
    imshow(img);
    for i = 1:size(cntr)
        cntr_cart = rect2cart(size(S)(1:2), cntr(i));
        plot(cntr_cart(:,1),cntr_cart(:,2));
        e = gce();
        e.children.foreground = i;
        e.children.thickness = thickness;
        
    end
    f.visible = 'on';

endfunction
