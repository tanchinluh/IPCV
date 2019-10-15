//=============================================================================
// IPCV - Scilab Image Processing and Computer Vision toolbox
// Copyright (C) 2017  Tan Chin Luh
//=============================================================================
function fobj = imdetect_MSER(im,delta, min_area, max_area, max_variation, min_diversity, max_evolution, area_threshold, min_margin, edge_blur_size);
    // Detect features from an image with MSER algorithm
    //
    // Syntax
    //     fobj = imdetect_MSER(im [,delta [,min_area [,max_area [,max_variation [,min_diversity [,max_evolution [,area_threshold [,min_margin [,edge_blur_size]]]]]]]]]);
    //     
    //
    // Parameters
    //     im : Input image
    //     delta: Compares (sizei - sizei-delta)/sizei-delta. Default value is 5. 
    //     min_area : Prune the area which smaller than minArea. Default value is 60.
    //     max_area : Prune the area which bigger than maxArea. Default value is 14400.
    //     max_variation : Prune the area have simliar size to its children. Default value is 0.25.
    //     min_diversity : For color image, trace back to cut off mser with diversity less than min_diversity. Default value is 0.2.
    //     max_evolution : For color image, the evolution steps. Default value is 200.
    //     area_threshold : For color image, the area threshold to cause re-initialize. Default value is 1.01.
    //     min_margin : For color image, ignore too small margin. Default value is 0.003.
    //     edge_blur_size : For color image, the aperture size for edge blur. Default value is 5.
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
    //    This function used to detect the features of an image using MSER method
    //
    // Examples
    //    S = imcreatechecker(8,8,[1 0.5]);
    //    fobj = imdetect_MSER(S,1);
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

    if rhs < 1; error("At least 1 argument expected, input image"); end    
    if rhs < 2; delta = 5; end
    if rhs < 3; min_area = 60; end
    if rhs < 4; max_area = 14400; end
    if rhs < 5; max_variation = 0.25; end
    if rhs < 6; min_diversity = 0.2; end
    if rhs < 7; max_evolution = 200; end
    if rhs < 8; area_threshold = 1.01; end
    if rhs < 9; min_margin = 0.003; end
    if rhs < 10; edge_blur_size = 5; end
 
    if isempty(delta); delta = 5; end
    if isempty(min_area); min_area = 60; end
    if isempty(max_area); max_area = 14400; end
    if isempty(max_variation); max_variation = 0.25; end
    if isempty(min_diversity); min_diversity = 0.2; end
    if isempty(max_evolution); max_evolution = 200; end
    if isempty(area_threshold); area_threshold = 1.01; end
    if isempty(min_margin); min_margin = 0.003; end
    if isempty(edge_blur_size); edge_blur_size = 5; end
    
    checkrange(2,delta,1,32767);   // TBC
    checkrange(3,min_area,1,32767);  
    checkrange(4,max_area,1,32767);         // TBC
    checkrange(5,max_variation,0,32767);// TBC
    checkrange(6,min_diversity,0,32767);   
    checkrange(7,max_evolution,1,32767);
    checkrange(8,area_threshold,0,32767);
    checkrange(9,min_margin,0,32767);    // TBC
    checkrange(10,edge_blur_size,1,32767);
     
    if typeof(im) ~= 'uint8'
        im = im2uint8(im);
    end
    
    r = int_imdetect_MSER(im,delta, min_area, max_area, max_variation, min_diversity, max_evolution, area_threshold, min_margin, edge_blur_size);
    
    fobj.type = 'MSER';
    fobj.n = size(r,2);
    fobj.x = r(1,:);
    fobj.y = r(2,:);
    fobj.size = r(3,:);
    fobj.angle = r(4,:);
    fobj.response = r(5,:);
    fobj.octave = r(6,:);
    fobj.class_id = r(7,:);
   
endfunction










