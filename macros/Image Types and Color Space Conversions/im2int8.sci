////////////////////////////////////////////////////////////
// SIVP - Scilab Image and Video Processing toolbox
// Copyright (C) 2006  Shiqi Yu
//
// IPCV - Scilab Image Processing and Computer Vision toolbox
// Copyright (C) 2017  Tan Chin Luh
//
////////////////////////////////////////////////////////////
function [im2] = im2int8(im)
    //    Convert image to 8-bit signed integers
    //    
    //    Syntax
    //      im2 = im2int8(im)
    //    
    //    Parameters
    //      im : An matrix/image, which can be ANY image supported by IPCV.
    //      im2 : Output image, an 8-bit signed integer matrix.
    //    
    //    Description
    //      im2int8 convert intensity or RGB images to 8-bit signed integers. If the input is of class int8, the output image is identical to it. Otherwise, im2int8 rescales or offsets the data, and returns the equivalent image of class int8.
    //    
    //    See also
    //      im2bw
    //      im2uint8
    //      im2uint16
    //      im2int16
    //      im2int32
    //      im2double
    //      mat2gray
    //    
    //    Authors
    //      Shiqi Yu
    //      Tan Chin Luh


    
    imtype = typeof(im(1));

    select imtype
    case 'boolean' then
        im2 = int8(int16(im)*255 - 128);
    case 'uint8' then
        im2 = int8(int16(im)-128);
    case 'int8' then
        im2 = im;
    case 'uint16' then
        im2 = int8(round(double(im)*(2^8-1)/(2^16-1) - 128));
    case 'int16' then
        im2 = int8(round((double(im) + 2^15)*(2^8-1)/(2^16-1) - 128));
    case 'int32' then
        im2 = int8(round((double(im)+2^31) * (2^8-1)/(2^32-1) - 128));
    case 'constant' then
        im(im>1.0) = 1.0;
        im(im<0.0) = 0.0;
        im2 = int8(round(im * 255 - 128));
    else
        error("Data type " + imtype + " is not supported.");
    end
endfunction
