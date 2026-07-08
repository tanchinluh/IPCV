////////////////////////////////////////////////////////////
// SIVP - Scilab Image and Video Processing toolbox
// Copyright (C) 2006  Shiqi Yu
//
// IPCV - Scilab Image Processing and Computer Vision toolbox
// Copyright (C) 2017  Tan Chin Luh
//
////////////////////////////////////////////////////////////
function [im2] = im2int32(im)
    //    Convert image to 32-bit signed integers
    //    
    //    Syntax
    //      im2 = im2int32(im)
    //    
    //    Parameters
    //      im : An matrix/image, which can be ANY image supported by IPCV.
    //      im2 : Output image, a 32-bit signed integer matrix.
    //    
    //    Description
    //      im2int32 convert intensity or RGB images to 32-bit signed integers. If the input is of class int32, the output image is identical to it. Otherwise, im2int32 rescales or offsets the data, and returns the equivalent image of class int32.
    //    
    //    See also
    //      im2bw
    //      im2uint8
    //      im2int8
    //      im2uint16
    //      im2int16
    //      im2double
    //      mat2gray
    //    
    //    Authors
    //      Shiqi Yu
    //      Tan Chin Luh

    
    imtype = typeof(im(1));

    select imtype
    case 'boolean' then
        im2 = int32(im * (2^32-1) - 2^31)
    case 'uint8' then
        im2 = int32(double(im)*(2^32-1)/(2^8-1) - 2^31);
    case 'int8' then
        im2 = int32((double(im)+128)*(2^32-1)/(2^8-1) - 2^31 );
    case 'uint16' then
        im2 = int32(double(im)*(2^32-1)/(2^16-1) - 2^31);
    case 'int16' then
        im2 = int32((double(im)+2^15)*(2^32-1)/(2^16-1) - 2^31 );
    case 'int32' then
        im2 = im;
    case 'constant' then
        im(im>1.0) = 1.0;
        im(im<0.0) = 0.0;
        //im2 = int32(im * (2^32-1) + 0.5 - 2^31);
        im2 = int32(im * (2^32-1) - 2^31);
    else
        error("Data type " + imtype + " is not supported.");
    end
endfunction
