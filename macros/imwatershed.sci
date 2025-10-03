//=============================================================================
// IPCV - Scilab Image Processing and Computer Vision toolbox
// Copyright (C) 2020  Tan Chin Luh
//=============================================================================

function imout = imwatershed(imin,markers)
    // Performs a marker-based image segmentation using the watershed algorithm.
    //
    // Syntax
    //     imout = imwatershed(imin)
    //     
    // Parameters
    //     imin : Input 8-bit 3-channel image.
    //     markers : Double precision single-channel image (map) of markers. It should have the same size as image.
    //     imout : Output labelled image
    //      
    // Description
    //    The function implements one of the variants of watershed, non-parametric marker-based segmentation algorithm.
    //
    // Examples
    //    S = imread(fullpath(getIPCVpath() + "/images/three_objects.png"), IMREAD_COLOR = 1);
    //    Sgray = rgb2gray(S);
    //    Sb = im2bw(Sgray,0.1);
    //    Sd = imdistransf(Sb);
    //    dist = Sd > 0.4;
    //    [markers,n] = imlabel(dist);
    //    markers(1:5,1:5) = 255;
    //    Sw = imwatershed(S, markers);
    //    imshow(Sw,hsv(3));
    //
    // See also
    //    imdistransf
    //
    // Authors
    //    Tan Chin Luh
    //
    // Bibliography
    //    1. OpenCV 4.1.2 Online Documentation
    
    rhs=argn(2);

    // Error Checking
    if rhs ~= 2; error("2 arguments expected, input 3 channles image and markers 1 channel image"); end    
    if  size(imin,3) ~= 3; error("First argument must be a 3 channels image."); end
    if  size(markers,3) ~= 1; error("Second argument must be a single channel image."); end
    
    [Sd, imout] = int_imwatershed(imin, markers,max(markers(markers<255)));
    
    imout(imout==-1) = 0;
    imout(imout==255) = 0;
        
endfunction
