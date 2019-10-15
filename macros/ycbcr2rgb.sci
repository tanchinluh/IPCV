////////////////////////////////////////////////////////////
// SIVP - Scilab Image and Video Processing toolbox
// Copyright (C) 2006  Shiqi Yu
//
// IPCV - Scilab Image Processing and Computer Vision toolbox
// Copyright (C) 2017  Tan Chin Luh
// 
////////////////////////////////////////////////////////////
function [rgb] = ycbcr2rgb(ycc)
    //    Convert a YCbCr image to the equivalent RGB image.
    //    
    //    Syntax
    //      RGB = ycbcr2rgb(YCC)
    //    
    //    Parameters
    //      YCC : A YCbCr image (hypermat). The dimension of YCbCr should be M x N x 3 , the type should be double and the element value range should be [0,1].
    //      RGB : Output image, which has the same size as YCC and type of double.
    //    
    //    Description
    //      ycbcr2rgb convert a RGB image to the equivalent YCbCr image using:
    //      
    //      R = Y + 1.403*(Cr - 0.5)
    //    
    //      G = Y - 0.344*(Cr - 0.5) - 0.714*(Cb - 0.5)
    //    
    //      B = Y + 1.773*(Cb - 0.5)
    //    
    //    Examples
    //      RGB = imread(fullpath(getIPCVpath() + "/images/baboon.png"));
    //      YCC = rgb2ycbcr(RGB);
    //      RGB = ycbcr2rgb(YCC);
    //      imshow(RGB);
    //     
    //    See also
    //      rgb2gray
    //      mat2gray
    //      rgb2hsv
    //      hsv2rgb
    //      rgb2ycbcr
    //      rgb2ntsc
    //      ntsc2rgb
    //    
    //    Authors
    //      Shiqi Yu 
    //      Tan Chin Luh


//
    rgb=int_cvtcolor(ycc, 'ycrcb2rgb');

//    clear tmp;
endfunction
