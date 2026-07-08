//=============================================================================
// IPCV - Scilab Image Processing and Computer Vision toolbox
// Copyright (C) 2017  Tan Chin Luh
//=============================================================================
function m = immatch_Flann(des1,des2);
    // Detect features from an image with SUFT algorithm
    //
    // Syntax
    //    m = imBruteForce_Match(des1,des2);
    //
    // Parameters
    //     des1 : First descriptor
    //     des2 : Second descriptor
    //     m : Mathching matrix
    //        
    // Description
    //    This function used to math 2 images with given keypoints using SURF method
    //
    // Examples
    //    [m,imout] = imsurfmatch(im1,im2,fobj1,fobj2);
    //
    // See also
    //     imsurfmatch
    //     imsmoothsurf
    //
    // Authors
    //    Tan Chin Luh
    //


    //

    rhs=argn(2);

    // Error Checking
    if rhs < 2; error("At least 2 arguments of descriptors expected."); end    
    
    m = int_immatch_Flann(des1,des2);
    m(1:2,:) = m(1:2,:) + 1;
      
endfunction










