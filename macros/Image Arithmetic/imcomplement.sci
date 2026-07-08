////////////////////////////////////////////////////////////
// SIVP - Scilab Image and Video Processing toolbox
// Copyright (C) 2006  Shiqi Yu
//
// IPCV - Scilab Image Processing and Computer Vision toolbox
// Copyright (C) 2017  Tan Chin Luh
//
////////////////////////////////////////////////////////////
function [im2] = imcomplement(im)
    //    Complement image
    //    
    //    Syntax
    //      imout = imcomplement(im)
    //    
    //    Parameters
    //      im : Input image.
    //      imout : The complement image, which has the same size and class with im .
    //    
    //    Description
    //      imcomplement computes the complement image of im. In the output image imout, dark pixels become lighter and light pixels become darker.
    //    
    //      Supported classes: BOOLEAN, INT8, UINT8, INT16, UINT16, INT32, DOUBLE.
    //    
    //    Examples
    //      im = [%F, %T];
    //      imcomplement(im)
    //    
    //      im = uint8([0, 50, 100; 150, 200, 250]);
    //      imcomplement(im)
    //    
    //      im = int8([-100, -50, 0; 50, 100, 150]);
    //      imcomplement(im)
    //    
    //      im = [0, 0.2, 0.4; 0.6, 0.8, 1.0];
    //      imcomplement(im)
    //     
    //    See also
    //      imabsdiff
    //      imadd
    //      imsubtract
    //      immultiply
    //      imdivide
    //      imlincomb
    //    
    //    Authors
    //      Shiqi Yu
    //      Tan Chin Luh

    
    imtype = typeof(im(1));

    //// because hypermat can not +-*/ with an integer scalar
    //// so we have to convert the data to double first
    //// After the bug is fixed, we can reuse the following code.

    //	 select imtype
    //	  case 'boolean' then
    //	   im2 = ~im;
    //	  case 'uint8' then
    //	   im2 = uint8(- int16(im) + int16(255));
    //	  case 'int8' then
    //	   im2 = int8(-int16(im)-int16(1));
    //	  case 'uint16' then
    //	   im2 = uint16(-int32(im) + int32(2^16-1));
    //	  case 'int16' then
    //	   im2 = int16(-int32(im)-int32(1));
    //	  case 'int32' then
    //	   im2 = int32(-double(im)-1);
    //	  case 'constant' then
    //	   im2 = 1.0 - im;
    //	 else
    //	   error("Data type " + imtype + " is not supported.");
    //	 end

    // convert im to double is not efficient enough
    select imtype
    case 'boolean' then
        im2 = ~im;
    case 'uint8' then
        im2 = uint8(- double(im) + 255);
    case 'int8' then
        im2 = int8(-double(im)-double(1));
    case 'uint16' then
        im2 = uint16(-double(im) + double(2^16-1));
    case 'int16' then
        im2 = int16(-double(im)-double(1));
    case 'int32' then
        im2 = int32(-double(im)-1);
    case 'constant' then
        im2 = 1.0 - im;
    else
        error("Data type " + imtype + " is not supported.");
    end
endfunction
