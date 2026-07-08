//=============================================================================
// IPCV - Scilab Image Processing and Computer Vision toolbox
// Copyright (C) 2017  Tan Chin Luh
//=============================================================================
function fobj = imdetect_SIFT(im,nfeatures,nOctaveLayers,contrastThreshold,edgeThreshold,sigma)
    // Detect features from an image with SIFT algorithm
    //
    // Syntax
    //     fobj = imdetect_SIFT(im [,nfeatures [,nOctaveLayers [,contrastThreshold [,edgeThreshold [,sigma]]]]])
    //
    // Parameters
    //     im : Input image
    //     nfeatures : The number of best features to retain. The features are ranked by their scores. Default value is 0.
    //     nOctaveLayers : The number of layers in each octave. Default value is 3.
    //     contrastThreshold : The contrast threshold used to filter out weak features in semi-uniform (low-contrast) regions. Default value is 0.04.
    //     edgeThreshold : The threshold used to filter out edge-like features. Default value is 10.
    //     sigma : The sigma of the Gaussian applied to the input image at the octave #0. Default value is 1.6.
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
    //    This function used to detect the features of an image using SIFT method
    //
    // Examples
    //    S = imcreatechecker(8,8,[1 0.5]);
    //    fobj = imdetect_SIFT(S);
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
    //nfeatures,nOctaveLayers,contrastThreshold,edgeThreshold,sigma

    rhs=argn(2);

    // Error Checking
    if rhs < 1; error("At least 1 argument expected, in 2D matrix"); end    
    if rhs < 2; nfeatures = 0; end
    if rhs < 3; nOctaveLayers = 3; end
    if rhs < 4; contrastThreshold = 0.04; end
    if rhs < 5; edgeThreshold = 10; end
    if rhs < 6; sigma = 1.6; end

    if isempty(nfeatures); nfeatures = 0; end
    if isempty(nOctaveLayers); nOctaveLayers = 3; end
    if isempty(contrastThreshold); contrastThreshold = 0.04; end
    if isempty(edgeThreshold); edgeThreshold = 10; end
    if isempty(sigma); sigma = 1.6; end

    checkrange(2,nfeatures,0,32767);   // TBC
    checkrange(3,nOctaveLayers,1,32767);
    checkrange(4,contrastThreshold,0,32767); 
    checkrange(5,edgeThreshold,0,32767);  
    checkrange(6,sigma,0,32767);  


    if typeof(im) ~= 'uint8'
        im = im2uint8(im);
    end


    r = int_imdetect_SIFT(im,nfeatures,nOctaveLayers,contrastThreshold,edgeThreshold,sigma);

    if type(r) == 10 then
        disp(strsplit(r,';')(1));
    else
        fobj.type = 'SIFT';
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










