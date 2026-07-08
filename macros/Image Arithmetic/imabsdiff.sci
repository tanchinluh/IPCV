////////////////////////////////////////////////////////////
// SIVP - Scilab Image and Video Processing toolbox
// Copyright (C) 2006  Shiqi Yu
//
// IPCV - Scilab Image Processing and Computer Vision toolbox
// Copyright (C) 2017  Tan Chin Luh
//
////////////////////////////////////////////////////////////
function [imdiff] = imabsdiff(im1, im2)
    //    Calculate absolute difference of two images
    //    
    //    Syntax
    //      imout = imabsdiff(im1, im2)
    //    
    //    Parameters
    //      im1, im2 : Input images, which can be any kinds of images, but must have the same width, height, class and number of channels.
    //      imout : The absolute difference of two input images.
    //    
    //    Description
    //      imabsdiff calculate the absolute difference of two images. The two input images must have the same width, height, class and number of channels.
    //
    //    If im1 and im2 are an integer matrices, the elements in the output matrix imout that exceed the range of the integer type will be truncated.
    //    
    //    Supported classes: INT8, UINT8, INT16, UINT16, INT32, DOUBLE.
    //    
    //    See also
    //      imadd
    //      imsubtract
    //      immultiply
    //      imdivide
    //      imcomplement
    //      imlincomb    
    //    
    //    Authors
    //      Shiqi Yu
    //      Tan Chin Luh

    //check the image width and height
    if( or( size(im1)<>size(im2) )) then
        error("The two images do not have the same size or the same channel number.");
        //return;
    end

    if (size(size(im1),2)>3) then
        error("The two inputs are not images");
        return;
    end
    if (size(size(im1),2)==3) then
        if (size(im1, 3)<>1) & (size(im1,3)<>3) then
            error("The two inputs are not images");
            //return;
        end	    
    end

    //must be the same class, and not be uint32
    if (type(im1(1))<>type(im2(1)) | ...
        typeof(im1(1))<>typeof(im2(1)) | ...
        typeof(im1(1))=='uint32'   ) then
        error("The two input images must be of the same class and not be"+...
        " uint32.");
    end

    //actruely abs(im1-im2) will be more efficient,
    //but abs(uint8(8)-uint8(9)) 
    //and abs(int16(2^15-1)-int16(-1))  will give error results 
    //(255 and -32768 respectively)
    //so we have to use OpenCV cvAbsDiff function for the same type at
    //these situations

    //int8 is not supported by OpenCV function cvAbsDiff
    //convert to int16 first when int8 class
    if ( typeof(im1(1))=='constant') then //double
        imdiff = abs(im1 - im2); 
    elseif ( typeof(im1(1))=='int8') then //int8
        imdiff = abs(int16(im1) - int16(im2));
        imdiff(imdiff > 127) = int16(127);
        imdiff = int8(imdiff);
    else 
        imdiff = int_imabsdiff(im1, im2);
    end

endfunction
