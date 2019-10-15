//=============================================================================
// IPCV - Scilab Image Processing and Computer Vision toolbox
// Copyright (C) 2017  Tan Chin Luh
//=============================================================================
function fobj = imdetect_ORB(im,nfeatures, scaleFactor,nlevels,edgeThreshold,firstLevel,WTA_K,scoreType, patchSize);
    // Detect features from an image with ORB algorithm
    //
    // Syntax
    //     fobj = imdetect_ORB(im [,nfeatures [,scaleFactor [,nlevels [,edgeThreshold [,firstLevel [,WTA_K [,scoreType [,patchSize]]]]]]]]);
    //     
    //
    // Parameters
    //     im : Input image
    //     nfeatures: The maximum number of features to returned. Default value is 500. 
    //     scaleFactor : Pyramid decimation ratio, greater than 1. Default value is 1.2.
    //     nlevels : The number of pyramid levels. Default value is 8.
    //     edgeThreshold : This is size of the border where the features are not detected. It should roughly match the patchSize parameter. Default value is 31.
    //     firstLevel : It should be 0 in the current implementation. Default value is 0.
    //     WTA_K : The number of points that produce each element of the oriented BRIEF descriptor. Default value is 2.
    //     scoreType : The default HARRIS_SCORE means that Harris algorithm is used to rank features. Default value is 0.
    //     patchSize :  size of the patch used by the oriented BRIEF descriptor. Default value is 31.
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
    //    This function used to detect the features of an image using ORB method
    //
    // Examples
    //    S = imcreatechecker(8,8,[1 0.5]);
    //    fobj = imdetect_ORB(S);
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
    //    2. Ethan Rublee, Vincent Rabaud, Kurt Konolige, Gary R. Bradski: ORB: An efficient alternative to SIFT or SURF. ICCV 2011: 2564-2571.

    //

    rhs=argn(2);

    // Error Checking
    if rhs < 1; error("At least 1 argument expected, input image"); end    
    if rhs < 2; nfeatures = 500; end
    if rhs < 3; scaleFactor = 1.2; end
    if rhs < 4; nlevels = 8; end
    if rhs < 5; edgeThreshold = 31; end
    if rhs < 6; firstLevel = 0; end
    if rhs < 7; WTA_K = 2; end
    if rhs < 8; scoreType = 0; end
    if rhs < 9; patchSize = 31; end
 
    if isempty(nfeatures); nfeatures = 500; end
    if isempty(scaleFactor); scaleFactor = 1.2; end
    if isempty(nlevels); nlevels = 8; end
    if isempty(edgeThreshold); edgeThreshold = 31; end
    if isempty(firstLevel); firstLevel = 0; end
    if isempty(WTA_K); WTA_K = 2; end
    if isempty(scoreType); scoreType = 0; end //HARRIS_SCORE=0, FAST_SCORE=1
    if isempty(patchSize); patchSize = 31; end
 
    checkrange(2,nfeatures,1,32767);   // TBC
    checkrange(3,scaleFactor,1,2);
    checkrange(4,nlevels,1,128);        // TBC
    checkrange(5,edgeThreshold,1,32767);// TBC
    checkrange(6,firstLevel,0,0);   
    checkrange(7,WTA_K,1,4);
    checkrange(8,scoreType,0,1);
    checkrange(9,patchSize,1,32767);    // TBC
    
               
    if typeof(im) ~= 'uint8'
        im = im2uint8(im);
    end
    
    r = int_imdetect_ORB(im,nfeatures, scaleFactor,nlevels,edgeThreshold,firstLevel,WTA_K,scoreType, patchSize);
    
    fobj.type = 'ORB';
    fobj.n = size(r,2);
    fobj.x = r(1,:);
    fobj.y = r(2,:);
    fobj.size = r(3,:);
    fobj.angle = r(4,:);
    fobj.response = r(5,:);
    fobj.octave = r(6,:);
    fobj.class_id = r(7,:);
   
endfunction










