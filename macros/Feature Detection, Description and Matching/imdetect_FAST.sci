//=============================================================================
// IPCV - Scilab Image Processing and Computer Vision toolbox
// Copyright (C) 2017  Tan Chin Luh
//=============================================================================
function fobj = imdetect_FAST(im,th,nmS,nb);
    // Detect features from an image with FAST algorithm. Usually used for corner features.
    //
    // Syntax
    //     fobj = imdetect_FAST(im [,th [,nmS [,nb]]]);  
    //
    // Parameters
    //     im : Input image
    //     th : threshold on difference between intensity of the central pixel and pixels of a circle around this pixel. Default value is 1.
    //     nms : nonmaxSuppression, if 1, non-maximum suppression is applied to detected corners (keypoints). Default value is 1.
    //     nb : one of the three neighborhoods, TYPE_5_8 = 0, TYPE_7_12 = 1, TYPE_9_16 = 2. Default value is 2.
    //     fobj : Features object contains following fields - 
    //          type : Type of features
    //          n : Numbers of detected features
    //          x : Coordinates of the detected features - X
    //          y : Coordinates of the detected features - Y
    //          size : Size of detected features
    //          angle : keypoint orientation
    //          response : The response by which the most strong keypoints have been selected.
    //          octave : pyramid octave in which the keypoint has been detected
    //          class_id : object id
    //
    // Description
    //    This function used to detect the features of an image using FAST method.Good for corner detection.
    //
    // Examples
    //    S = imcreatechecker(8,8,[1 0.5]);
    //    fobj = imdetect_FAST(S);
    //    imshow(S); plotfeature(fobj);
    //
    // See also
    //     imdetect_FAST
    //     imdetect_STAR
    //     imdetect_SIFT 
    //     imdetect_SURF
    //     imdetect_ORB
    //     imdetect_BRISK
    //     imdetect_MSER
    //     imdetect_GFTT
    //     imdetect_HARRIS
    //     imdetect_DENSE
    //     plotfeature
    //
    // Authors
    //    Tan Chin Luh
    //
    // Bibliography
    //    1. OpenCV 2.4 Online Documentation
    //    2. Rosten. Machine Learning for High-speed Corner Detection, 2006.


    //

    rhs=argn(2);
    
    // Error Checking
    if rhs < 1; error("At least 1 argument expected, in 2D matrix"); end    
    if rhs < 2;  th = 1; end 
    if rhs < 3;  nmS = 1; end
    if rhs < 4;  nb = 2; end
    
    if isempty(th);th = 1;end
    if isempty(nmS);nmS = 1;end
    if isempty(nb);nb = 2;end
    
    checkrange(2,th,1,255);
    checkrange(3,nmS,0,1);
    checkrange(4,nb,0,2);
    
    if typeof(im) ~= 'uint8'
        im = im2uint8(im);
    end
    
    r = int_imdetect_FAST(im,th,nmS,nb);
    
    fobj.type = 'FAST';
    fobj.n = size(r,2);
    fobj.x = r(1,:);
    fobj.y = r(2,:);
    fobj.size = r(3,:);
    fobj.angle = r(4,:);
    fobj.response = r(5,:);
    fobj.octave = r(6,:);
    fobj.class_id = r(7,:);
       
endfunction










