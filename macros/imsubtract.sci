////////////////////////////////////////////////////////////
// SIVP - Scilab Image and Video Processing toolbox
// Copyright (C) 2006  Shiqi Yu
//
// IPCV - Scilab Image Processing and Computer Vision toolbox
// Copyright (C) 2017  Tan Chin Luh
////////////////////////////////////////////////////////////
function [imout] = imsubtract(im1, im2)
    //    Subtract two images or subtract a constant from an image
    //    
    //    Syntax
    //      imout = imsubtract(im1, im2)
    //    
    //    Parameters
    //      im1 : Input image.
    //      im2 : Input image with the same size and same class with im1 , or a double scalar.
    //      imout : The difference of im1 and im2 .
    //    
    //    Description
    //      If im1 and im2 are images with the same size and same class, imsubtract subtracts each element in im2 from the corresponding one in im1. 
    //    
    //      If im2 is a double scalar, the element in imout is the difference of the corresponding one in im1 with the double scalar. imout has the same size and class with im1.
    //    
    //      If im1 is an integer matrix, the elements in the output matrix imout that exceed the range of the integer type will be truncated.
    //    
    //      Supported classes: INT8, UINT8, INT16, UINT16, INT32, DOUBLE.
    //    
    //    Examples
    //      im1 = imread(fullpath(getIPCVpath() + "/images/baboon.png"));
    //      im2 = imread(fullpath(getIPCVpath() + "/images/peppers.png"));
    //      ims1 = imsubtract(im1, im2);
    //      ims2 = imsubtract(im1, 50);
    //     
    //    See also
    //      imabsdiff
    //      imadd
    //      immultiply
    //      imdivide
    //      imcomplement
    //      imlincomb
    //    
    //    Authors
    //      Shiqi Yu 
    //      Tan Chin Luh

    if ( typeof(im1(1))=='constant') then //double
        imout = im1 - im2; 
    elseif ( typeof(im1(1))=='int8') then //int8
        imout = double(im1) - double(im2);
        imout(imout > 127) = 127;
        imout(imout < -128) = -128;
        imout = int8(imout);
    else 
        imout = int_imsubtract(im1, im2);
    end

endfunction
