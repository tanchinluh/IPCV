//=============================================================================
// IPCV - Scilab Image Processing and Computer Vision toolbox
// Copyright (C) 2017  Tan Chin Luh
//=============================================================================
function fobj = imdetect_STAR(im,maxSize,responseThreshold,lineThresholdProjected,lineThresholdBinarized,suppressNonmaxSize);
    // Detect features from an image with STAR algorithm
    //
    // Syntax
    //     fobj = imdetect_STAR(im [,maxSize [,responseThreshold [,lineThresholdProjected [,lineThresholdBinarized [,suppressNonmaxSize]]]]]);  
    //
    // Parameters
    //     im : Input image
    //     maxSize : Maximum size of the features. Default value is 16.
    //     responseThreshold : Response threshold. Default value is 30.
    //     lineThresholdProjected : Default value is 10.
    //     lineThresholdBinarized : Default value is 8.
    //     suppressNonmaxSize : Default value is 5.
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
    //    This function used to detect the features of an image using STAR method
    //
    // Examples
    //    S = imcreatechecker(8,8,[1 0.5]);
    //    fobj = imdetect_STAR(S);
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
    
    rhs=argn(2);

    // Error Checking
    if rhs < 1; error("At least 1 argument expected, in 2D matrix"); end    
    if rhs < 2; maxSize = 16; end
    if rhs < 3; responseThreshold = 30; end
    if rhs < 4; lineThresholdProjected = 10; end
    if rhs < 5; lineThresholdBinarized = 8; end
    if rhs < 6; suppressNonmaxSize = 5; end

    if isempty(maxSize); maxSize = 16; end
    if isempty(responseThreshold); responseThreshold = 30; end
    if isempty(lineThresholdProjected); lineThresholdProjected = 10; end
    if isempty(lineThresholdBinarized); lineThresholdBinarized = 8; end
    if isempty(suppressNonmaxSize); suppressNonmaxSize = 5; end
    
    checkrange(2,maxSize,1,32767);   // TBC
    checkrange(3,responseThreshold,1,32767);
    checkrange(4,lineThresholdProjected,1,32767); 
    checkrange(5,lineThresholdBinarized,1,32767);  
    checkrange(6,suppressNonmaxSize,1,32767);  
   
    if typeof(im) ~= 'uint8'
        im = im2uint8(im);
    end
    
    maxSize=16, 
    responseThreshold=30,
    lineThresholdProjected = 10,
    lineThresholdBinarized = 8
    suppressNonmaxSize=5 
    
    
    r = int_imdetect_STAR(im,maxSize,responseThreshold,lineThresholdProjected,lineThresholdBinarized,suppressNonmaxSize);
    
    fobj.type = 'STAR';
    fobj.n = size(r,2);
    fobj.x = r(1,:);
    fobj.y = r(2,:);
    fobj.size = r(3,:);
    fobj.angle = r(4,:);
    fobj.response = r(5,:);
    fobj.octave = r(6,:);
    fobj.class_id = r(7,:);
   
endfunction










