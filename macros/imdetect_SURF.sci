//=============================================================================
// IPCV - Scilab Image Processing and Computer Vision toolbox
// Copyright (C) 2017  Tan Chin Luh
//=============================================================================
function fobj = imdetect_SURF(im,hessianThreshold,nOctaves,nOctaveLayers,extended,upright)
    // Detect features from an image with SURF algorithm
    //
    // Syntax
    //     fobj = imdetect_SURF(im [,hessianThreshold [,nOctaves [,nOctaveLayers [,extended [,upright]]]]])
    //
    // Parameters
    //     im : Input image
    //     hessianThreshold : Threshold for hessian keypoint detector used in SURF. Default value is 1000.
    //     nOctaves : Number of pyramid octaves the keypoint detector will use. Default value is 4.
    //     nOctaveLayers : Number of octave layers within each octave. Default value is 2.
    //     extended : Extended descriptor flag. Default value is 1.
    //     upright : Up-right or rotated features flag. Default value is 0.
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
    //    This function used to detect the features of an image using SURF method
    //
    // Examples
    //    S = imcreatechecker(8,8,[1 0.5]);
    //    fobj = imdetect_SURF(S);
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
    if rhs < 2; hessianThreshold = 1000; end
    if rhs < 3; nOctaves = 4; end
    if rhs < 4; nOctaveLayers = 2; end
    if rhs < 5; extended = 1; end
    if rhs < 6; upright = 0; end

    if isempty(hessianThreshold); hessianThreshold = 1000; end
    if isempty(nOctaves); nOctaves = 4; end
    if isempty(nOctaveLayers); nOctaveLayers = 2; end
    if isempty(extended); extended = 1; end
    if isempty(upright); upright = 0; end

    checkrange(2,hessianThreshold,1,32767);   // TBC
    checkrange(3,nOctaves,1,32);
    checkrange(4,nOctaveLayers,1,32); 
    checkrange(5,extended,0,1);  
    checkrange(6,upright,0,1);  


    if typeof(im) ~= 'uint8'
        im = im2uint8(im);
    end
    
    r = int_imdetect_SURF(im,hessianThreshold,nOctaves,nOctaveLayers,extended,upright);
    
    if type(r) == 10 then
        disp(strsplit(r,';')(1));
    else
        fobj.type = 'SURF';
        fobj.n = size(r,2);
        fobj.x = r(1,:);
        fobj.y = r(2,:);
        fobj.size = r(3,:);
        fobj.angle = r(4,:);
        fobj.response = r(5,:);
        fobj.octave = r(6,:);
        fobj.class_id = r(7,:);
    end
    
endfunction










