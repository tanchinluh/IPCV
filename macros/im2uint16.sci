////////////////////////////////////////////////////////////
// SIVP - Scilab Image and Video Processing toolbox
// Copyright (C) 2006  Shiqi Yu
//
// IPCV - Scilab Image Processing and Computer Vision toolbox
// Copyright (C) 2017  Tan Chin Luh
//
////////////////////////////////////////////////////////////
function [im2] = im2uint16(im)
    //    Convert image to 16-bit unsigned integers
    //    
    //    Syntax
    //      im2 = im2uint16(im)
    //    
    //    Parameters
    //      im : An matrix/image, which can be ANY image supported by IPCV.
    //      im2 : Output image, a 16-bit unsigned integer matrix.
    //    
    //    Description
    //      im2uint16 convert intensity or RGB images to 16-bit unsigned integers. If the input is of class uint16, the output image is identical to it. Otherwise, im2uint16 rescales or offsets the data, and returns the equivalent image of class uint16.
    //    
    //    See also
    //      im2bw
    //      im2uint8
    //      im2int8
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
        im2 = uint16(int32(im)*(2^16-1));
    case 'uint8' then
        im2 = uint16(double(im)*(2^16-1)/(2^8-1));
    case 'int8' then
        im2 = uint16((double(im)+(128))*(2^16-1)/(2^8-1));
    case 'uint16' then
        im2 = im; 
    case 'int16' then
        im2 = uint16(int32(im) + 2^15);
    case 'int32' then
        im2 = uint16(round((double(im)+2^31)*(2^16-1)/(2^32-1)));
    case 'constant' then
        im(im>1.0) = 1.0;
        im(im<0.0) = 0.0;
        im2 = uint16(round(im * (2^16-1)));
    else
        error("Data type " + imtype + " is not supported.");
    end
endfunction
