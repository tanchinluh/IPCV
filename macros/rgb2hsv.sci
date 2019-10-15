////////////////////////////////////////////////////////////
// SIVP - Scilab Image and Video Processing toolbox
// Copyright (C) 2006  Shiqi Yu
//
// IPCV - Scilab Image Processing and Computer Vision toolbox
// Copyright (C) 2017  Tan Chin Luh
//
////////////////////////////////////////////////////////////
function [hsv] = rgb2hsv(rgb)
    // Convert a RGB image to the equivalent HSV image
    //
    // Syntax
    //    HSV = rgb2hsv(RGB)    
    //
    // Parameters
    //    RGB : A RGB image (matrix), the dimension of RGB should be M x N x 3 .
    //    HSV : Output image, which has the same size and type as RGB.
    //
    // Description
    //    rgb2hsv convert a RGB image to the equivalent HSV image
    //
    //    Supported classes: INT8, UINT8, INT16, UINT16, INT32, DOUBLE. 
    //
    // Examples
    //    RGB = imread(fullpath(getIPCVpath() + "/images/baboon.png"));
    //    HSV = rgb2hsv(RGB);
    //    RGB = hsv2rgb(HSV);
    //    imshow(RGB);
    //
    // See also
    //    rgb2gray
    //    mat2gray
    //    hsv2rgb
    //    rgb2ycbcr
    //    ycbcr2rgb
    //    rgb2ntsc
    //    ntsc2rgb
    //
    // Authors
    //  Shiqi Yu  
    //  Tan Chin Luh
        
    // To-do : Error handling
    hsv=int_cvtcolor(rgb, 'rgb2hsv');

endfunction

    // Description
    //    rgb2hsv convert a RGB image to the equivalent HSV image using:
    //    V = max(R,G,B)
    //    S = (V-min(R,G,B))/V if V<>0, 0 otherwise
    //    H =
    //    (G - B)/6/S, if V=R;
    //    1/2+(B - R)/6/S, if V=G;
    //    2/3+(R - G)/6/S, if V=B.
    //    Supported classes: INT8, UINT8, INT16, UINT16, INT32, DOUBLE. If RGB is not a double image, it will be converted to double image first in the procedure.
    //
