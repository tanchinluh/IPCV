//=============================================================================
// IPCV - Scilab Image Processing and Computer Vision toolbox
// Copyright (C) 2017  Tan Chin Luh
//=============================================================================
function imout = imdrawmatches(im1,im2,fobj1,fobj2,m);
    // Draw matching result for 2 images 
    //
    // Syntax
    //     imout = imdrawmatches(im1,im2,fobj1,fobj2,m);
    //
    // Parameters
    //     im1 : First input image
    //     im2 : Second input image
    //     fobj1 : First feature object
    //     fobj2 : Second feature object
    //     m : Matching matrix
    //     imout : Output matching image
    //          
    // Description
    //    This function used to draw matching result for 2 images with the features object and matching matrix provided.
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
    //     immatch_Brute
    //     imbestmatches
    //
    // Authors
    //    Tan Chin Luh
    //
    
    rhs=argn(2);

    // Error Checking
    if rhs < 5; error("At least 5 argument expected, 2 images with their 2 features objects, and 1 matching matrix"); end     

    if typeof(im1) ~= 'uint8'
        im1 = im2uint8(im1);
    end    

    if typeof(im2) ~= 'uint8'
        im2 = im2uint8(im2);
    end    

    fm1 = [fobj1.x;fobj1.y;fobj1.size;fobj1.angle;fobj1.response;fobj1.octave;fobj1.class_id];
    fm2 = [fobj2.x;fobj2.y;fobj2.size;fobj2.angle;fobj2.response;fobj2.octave;fobj2.class_id];

    imout =int_imdrawmatches(im1,im2,fm1,fm2,m);

endfunction










