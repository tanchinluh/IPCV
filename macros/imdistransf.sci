//=============================================================================
// IPCV - Scilab Image Processing and Computer Vision toolbox
// Copyright (C) 2020  Tan Chin Luh
//=============================================================================

function imout = imdistransf(imin,method)
    // Distance Transform
    //
    // Syntax
    //     imout = imdistransf(imin)
    //     
    // Parameters
    //     imin : Input binary image or 8-bit, single-channel (binary)
    //     method : Distance type, l1, l2, or c where the setting shall correspond to 1, 2 and 3 respectively:
    //      l1 : distance = |x1-x2| + |y1-y2|, use 1
    //      l2 : the simple euclidean distance, use 2
    //      c  : distance = max(|x1-x2|,|y1-y2|), use 3
    //     imout : Output image with calculated distances. It is a double precision single-channel image of the same size as input
    //      
    // Description
    //    This function used to calculates the distance to the closest zero pixel for each pixel of the source image.
    //
    // Examples
    //    S = imread(fullpath(getIPCVpath() + "/images/three_objects.png") , IMREAD_COLOR = 1);
    //    Sgray = rgb2gray(S);
    //    Sb = im2bw(Sgray,0.1);
    //    Sd = imdistransf(Sb);
    //    subplot(211);imshow(Sb);subplot(212);imshow(Sd);
    //
    // See also
    //     imwatershed
    //
    // Authors
    //    Tan Chin Luh
    //
    // Bibliography
    //    1. OpenCV 4.1.2 Online Documentation
    
    rhs=argn(2);

    // Error Checking
    if rhs < 1; error("At least 1 argument expected, binary image."); end    
    if rhs < 2; method = 1; end
    
    if isempty(method); method = 1; end
    
    imout = int_imdistransf(imin,method);
        
endfunction
