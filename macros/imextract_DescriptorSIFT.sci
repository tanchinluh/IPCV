//=============================================================================
// IPCV - Scilab Image Processing and Computer Vision toolbox
// Copyright (C) 2017  Tan Chin Luh
//=============================================================================
function des = imextract_DescriptorSIFT(im1,fobj1);
    // Computes the descriptors for a set of keypoints detected in an image  with SIFT method.
    //
    // Syntax
    //     des = imextract_DescriptorSIFT(im1,fobj1);
    //
    // Parameters
    //     im1 : Input image
    //     fobj1 : Features 
    //     des : Descriptors for the features
    //        
    // Description
    //    This function extracts the descriptors of an image's features with ORB method
    //
    // Examples
    //    S = imcreatechecker(8,4,[1 0.5]);
    //    fobj = imdetect_SIFT(S);
    //    imshow(S); plotfeature(fobj);
    //    des = imextract_DescriptorSIFT(S,fobj);
    //
    // See also
    //     imextract_DescriptorSIFT 
    //     imextract_DescriptorSURF
    //     imextract_DescriptorBRIEF
    //     imextract_DescriptorBRISK
    //     imextract_DescriptorORB
    //     imextract_DescriptorFREAK 
    //
    // Authors
    //    Tan Chin Luh
    //
    // Bibliography
    //    1. OpenCV 2.4 Online Documentation


    //

    rhs=argn(2);

    // Error Checking
    if rhs < 2; error("At least 2 argument expected, an image and a features object"); end    
    if fobj1.n == 0 ; error("Empty features"); end 
    
    f1 = [fobj1.x;fobj1.y;fobj1.size;fobj1.angle;fobj1.response;fobj1.octave;fobj1.class_id];
    if typeof(im1) ~= 'uint8'
        im1 = im2uint8(im1);
    end        
    des = int_imextract_DescriptorSIFT(im1,f1);
    
    
      
endfunction










