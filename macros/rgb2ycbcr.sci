////////////////////////////////////////////////////////////
// SIVP - Scilab Image and Video Processing toolbox
// Copyright (C) 2006  Shiqi Yu
//
// IPCV - Scilab Image Processing and Computer Vision toolbox
// Copyright (C) 2017  Tan Chin Luh
//
////////////////////////////////////////////////////////////
function [ycc] = rgb2ycbcr(rgb)
    //    Convert a RGB image to the equivalent YCbCr image.
    //    
    //    Syntax
    //      YCC = rgb2ycbcr(RGB)
    //    
    //    Parameters
    //      RGB : A RGB image (hypermat), the dimension of RGB should be M x N x 3 .
    //      YCC : Output image, which has the same size as RGB and type of double.
    //    
    //    Description
    //      rgb2ycbcr convert a RGB image to the equivalent HSV image using:
    //    
    //      Y = 0.299*R + 0.587*G + 0.114*B
    //    
    //      Cb = (B-Y)*0.564 + 0.5
    //    
    //      Cr = (R-Y)*0.713 + 0.5
    //    
    //      Supported classes: INT8, UINT8, INT16, UINT16, INT32, DOUBLE. If RGB is not a double image, it will be converted to double image first in the procedure.
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
    //      ycbcr2rgb
    //      rgb2ntsc
    //      ntsc2rgb 
    //    
    //    Authors
    //      Shiqi Yu
    //      Tan Chin Luh

    
    //rgb=im2double(rgb);
    ycc=int_cvtcolor(rgb, 'rgb2ycrcb');
//    ycc=zeros(tmp);
//
//    ycc(:,:,1) = tmp(:,:,1);
//    ycc(:,:,2) = tmp(:,:,3);
//    ycc(:,:,3) = tmp(:,:,2);
//    clear tmp;
endfunction
