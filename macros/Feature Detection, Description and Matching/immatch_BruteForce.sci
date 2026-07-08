//=============================================================================
// IPCV - Scilab Image Processing and Computer Vision toolbox
// Copyright (C) 2017  Tan Chin Luh
//=============================================================================
function m = immatch_BruteForce(des1,des2,normType);
    // Brute-force matcher for features matching.
    //
    // Syntax
    //    m = immatch_BruteForce(des1,des2,normType);
    //
    // Parameters
    //     des1 : First descriptor
    //     des2 : Second descriptor
    //     normType : One of NORM_L1, NORM_L2, NORM_HAMMING, NORM_HAMMING2. L1 and L2 norms are preferable choices for SIFT and SURF descriptors, NORM_HAMMING should be used with ORB, BRISK and BRIEF, NORM_HAMMING2 should be used with ORB when WTA_K==3 or 4 (see ORB::ORB constructor description).
    //     m : Mathching matrix
    //        
    // Description
    //    This function used to Brute-force matcher to match the given descriptors.
    //
    // Examples
    //    // Read the image and rotate it by 45 degrees
    //    S = imread(fullpath(getIPCVpath() + "/images/balloons_gray.png"));
    //    S2 = imrotate(S,45);
    //    // Use the ORB to detect features
    //    f1 = imdetect_ORB(S)
    //    f2 = imdetect_ORB(S2)
    //    // Extract the descriptor
    //    d1 = imextract_DescriptorORB(S,f1);
    //    d2 = imextract_DescriptorORB(S2,f2);
    //    // Feature matching
    //    m = immatch_BruteForce(d1,d2,4)
    //    // Find the 10 best matches
    //    [fout1,fout2,mout] = imbestmatches(f1,f2,m,10);
    //    // Draw the matches
    //    SS = imdrawmatches(S,S2,fout1,fout2,mout);
    //    // Show the comparison
    //    imshow(SS);
    //
    // See also
    //     imbestmatches
    //     imdrawmatches
    //
    // Authors
    //    Tan Chin Luh
    //
    // Bibliography
    //    1. OpenCV 2.4 Online Documentation

    //

    rhs=argn(2);

    // Error Checking
    if rhs < 2; error("At least 2 arguments of descriptors expected."); end    
    if rhs < 3; normType = 2; end    
       
    m = int_immatch_BruteForce(des1,des2,normType);
    m(1:2,:) = m(1:2,:) + 1;
      
endfunction










