//=============================================================================
// IPCV - Scilab Image Processing and Computer Vision toolbox
// Copyright (C) 2017  Tan Chin Luh
//=============================================================================
function fobj = imdetect_BRISK(im,thresh,octaves,patternScale);
    // Detect features from an image with BRISK algorithm
    //
    // Syntax
    //     fobj = imdetect_BRISK(im [,thresh [,octaves [,patternScale]]]);
    //
    // Parameters
    //     im : Input image
    //     thresh : FAST/AGAST detection threshold score. Default value is 30.
    //     octaves : detection octaves. Use 0 to do single scale. Default value is 3.
    //     patternScale : apply this scale to the pattern used for sampling the neighbourhood of a keypoint. Default value is 1.0.
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
    //    This function used to detect the features of an image using BRISK method
    //
    // Examples
    //    S = imcreatechecker(8,8,[1 0.5]);
    //    fobj = imdetect_BRISK(S);
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

    // Error Checking ,octaves,patternScale
    if rhs < 1; error("At least 1 argument expected, input image"); end    
    if rhs < 2; thresh = 30; end
    if rhs < 3; octaves = 3; end
    if rhs < 4; patternScale = 1; end

    if isempty(thresh); thresh = 30; end
    if isempty(octaves); octaves = 3; end
    if isempty(patternScale); patternScale = 1; end
    
    checkrange(2,thresh,1,32767);   // TBC
    checkrange(3,octaves,0,32767);  
    checkrange(4,patternScale,0,32767);    
        
    if typeof(im) ~= 'uint8'
        im = im2uint8(im);
    end
    
    r = int_imdetect_BRISK(im,thresh,octaves,patternScale);
    
    fobj.type = 'BRISK';
    fobj.n = size(r,2);
    fobj.x = r(1,:);
    fobj.y = r(2,:);
    fobj.size = r(3,:);
    fobj.angle = r(4,:);
    fobj.response = r(5,:);
    fobj.octave = r(6,:);
    fobj.class_id = r(7,:);
   
endfunction










