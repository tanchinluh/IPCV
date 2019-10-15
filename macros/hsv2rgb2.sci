////////////////////////////////////////////////////////////
// SIVP - Scilab Image and Video Processing toolbox
// Copyright (C) 2006  Shiqi Yu
//
// IPCV - Scilab Image Processing and Computer Vision toolbox
// Copyright (C) 2017  Tan Chin Luh
//
////////////////////////////////////////////////////////////

function [rgb] = hsv2rgb2(hsv)
    // Convert a HSV image to the equivalent RGB image.
    //
    // Syntax
    //    RGB = hsv2rgb2(HSV)   
    //
    // Parameters
    //    HSV : A HSV image (hypermat). The dimension of HSV should be M x N x 3 , the type should be double and the element value range should be [0,1].
    //    RGB : Output image, which has the same size and type as HSV.
    //
    // Description
    //    hsv2rgb convert a HSV image to the equivalent RGB image. 
    //
    //    Supported classes: INT8, UINT8, INT16, UINT16, INT32, DOUBLE. 
    //
    // Examples
    //    RGB = imread(fullpath(getIPCVpath() + "/images/baboon.png"));
    //    HSV = rgb2hsv(RGB);
    //    RGB = hsv2rgb2(HSV);
    //    imshow(RGB);
    //
    // See also
    //    rgb2gray
    //    mat2gray
    //    rgb2hsv
    //    rgb2ycbcr
    //    ycbcr2rgb
    //    rgb2ntsc
    //    ntsc2rgb
    //
    // Authors
    //    Shiqi Yu  
    //    Tan Chin Luh
    
    // To-do : Error handling
    rgb=int_cvtcolor(hsv, 'hsv2rgb');

endfunction

//hsv2rgb convert a HSV image to the equivalent RGB image. The relationship between RGB and HSV described as follows:
//V = max(R,G,B)
//S = (V-min(R,G,B))/V if V<>0, 0 otherwise
//H =
//(G - B)/6/S, if V=R;
//1/2+(B - R)/6/S, if V=G;
//2/3+(R - G)/6/S, if V=B.
//Supported classe: DOUBLE.
