//=============================================================================
// IPCV - Scilab Image Processing and Computer Vision toolbox
// Copyright (C) 2017  Tan Chin Luh
//=============================================================================
function fobj = imdetect_GFTT(im,maxCorner,qualityLevel,minDistance,blockSize,k);
    // Detect features from an image with GFTT algorithm
    //
    // Syntax
    //      fobj = imdetect_GFTT(im [,maxCorner [,qualityLevel [,minDistance [,blockSize [,k]]]]]);
    //
    // Parameters
    //     im : Input image
    //     maxCorner : Maximum corders to be returned. Default value is 1000.
    //     qualityLevel : Parameter characterizing the minimal accepted quality of image corners. Default value is 0.01.
    //     minDistance : Minimum possible Euclidean distance between the returned corners. Default value is 1.
    //     blockSize : Size of an average block for computing a derivative covariation matrix over each pixel neighborhood. Default value is 3.
    //     k : Free parameter of the Harris detector. Default value is 0.04.
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
    //    This function used to detect the features of an image using GFTT method
    //
    // Examples
    //    S = imcreatechecker(8,8,[1 0.5]);
    //    fobj = imdetect_GFTT(S);
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

    //

    rhs=argn(2);

    // Error Checking
    if rhs < 1; error("At least 1 argument expected, input image"); end    
    if rhs < 2; maxCorner = 100; end
    if rhs < 3; qualityLevel = 0.01; end
    if rhs < 4; minDistance = 1; end
    if rhs < 5; blockSize = 3; end
    if rhs < 6; k = 0.04; end

    if isempty(maxCorner); maxCorner = 100; end
    if isempty(qualityLevel); qualityLevel = 0.01; end
    if isempty(minDistance); minDistance = 1; end
    if isempty(blockSize); blockSize = 3; end
    if isempty(k); k = 0.04; end

    checkrange(2,maxCorner,1,32767);   // TBC
    checkrange(3,qualityLevel,0,32767);
    checkrange(4,minDistance,0,32767); 
    checkrange(5,blockSize,0,32767);  
    checkrange(6,k,0,32767);  
    
    if typeof(im) ~= 'uint8'
        im = im2uint8(im);
    end

    r = int_imdetect_GFTT(im,maxCorner,qualityLevel,minDistance,blockSize,k);

    fobj.type = 'HARRIS';
    fobj.n = size(r,2);
    fobj.x = r(1,:);
    fobj.y = r(2,:);
    fobj.size = r(3,:);
    fobj.angle = r(4,:);
    fobj.response = r(5,:);
    fobj.octave = r(6,:);
    fobj.class_id = r(7,:);

endfunction










