//=============================================================================
// IPCV - Scilab Image Processing and Computer Vision toolbox
// Copyright (C) 2017  Tan Chin Luh
//=============================================================================
function Sc = imfindContours(Sbw)
    // Finds contours in a binary image.
    //
    // Syntax
    //    Sc = imfindcontour(Sbw)
    //
    // Parameters
    //     Sbw : Input binary image
    //     Sc : Output labelled image with detected contours, each contour labelled with same indices. 
    //     
    // Description
    //    This function used to find the contours of a binary image, returned in labelled image format.
    //
    // Examples
    //     S = imread(fullpath(getIPCVpath() + "/images/coins_gray.jpg"));
    //     Sbw = im2bw(S,0.5);
    //     Sc = imfindContours(Sbw);
    //     So = imdrawContours(Sc);
    //     imshow(So);
    //
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

    // Error Checking
    if rhs > 1; error("This function only accept 1 input, a binary image"); end    
    if type(Sbw) ~= 4 then
        error("Only Binary image allowed."); 
    end
       
    Sc = int_imfindContours(Sbw);
      
endfunction










