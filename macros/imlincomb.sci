////////////////////////////////////////////////////////////
// SIVP - Scilab Image and Video Processing toolbox
// Copyright (C) 2006  Shiqi Yu
//
// IPCV - Scilab Image Processing and Computer Vision toolbox
// Copyright (C) 2017  Tan Chin Luh
//
////////////////////////////////////////////////////////////

function [imout] = imlincomb(varargin)
    //    Linear combination of images
    //    
    //    Syntax
    //      imout = imlincomb(k1, im1, k2, im2, ..., kn, imn)
    //      imout = imlincomb(k1, im1, k2, im2, ..., kn, imn, K)
    //      imout = imlincomb(..., output_class)
    //    
    //    Parameters
    //      im1, im2, ..., imn : Input images with the same size and class.
    //       k1, k2, ..., kn : Double scalars.
    //       K : Offset, a double scalar.
    //      output_class : A string which specifies the output image class. The value of output_class can be 'int8', 'uint8', 'int16', 'uint16', 'int32' or 'constant'.
    //      imout : The linear combination of input images, which has the same size and class with input images or specified by output_class .
    //    
    //    Description
    //      imcomplement computes the linear combination of input images.
    //    
    //      imout = k1*im1 + k2*im2 + ... + kn*imn [+K]
    //    
    //      If imout is an integer matrix, the elements in the output matrix imout that exceed the range of the integer type will be truncated.
    //    
    //      Supported classes: INT8, UINT8, INT16, UINT16, INT32, DOUBLE.
    //    
    //    Examples
    //      im1 = uint8([0, 50, 100; 150, 200, 250]);
    //      im2 = uint8([1, 52, 103; 154, 205, 255]);
    //      imlincomb( 0.43, im1, 0.7, im2)
    //      imlincomb( 0.43, im1, 0.7, im2, 4)
    //      imlincomb( 0.43, im1, 0.7, im2, 4, 'int16')
    //      imlincomb( 0.43, im1, 0.7, im2, 4, 'constant')
    //     
    //    See also
    //      imabsdiff
    //      imadd
    //      imsubtract
    //      immultiply
    //      imdivide
    //      imcomplement
    //    
    //    Authors
    //      Shiqi Yu 
    //      Tan Chin Luh


    imtype = 'undefined';
    totype = 'undefined';

    varlen = length(varargin);
    if(typeof(varargin(varlen))=='string') then
        totype = varargin(varlen);
        varlen = varlen-1;
    end

    if varlen < 2 then
        error("Too few arguments for function imlincomb.");
    end

    for ii = 1:2:varlen
        //K
        if(ii==varlen) then
            imout = imout + varargin(ii);
        elseif ii==1 then
            kn=varargin(ii);
            imn=varargin(ii+1);

            if(prod(size(kn))<>1) then
                error("The " + string(ii) +"''th argument should be a double scalar.");
            end

            imtype = typeof(imn(1));
            imout = double(imn)*kn;
        else
            kn=varargin(ii);
            imn=varargin(ii+1);

            if(prod(size(kn))<>1) then
                error("The " + string(ii) +"''th argument should be a double scalar.");
            end

            //check image size and class
            if(imtype <> typeof(imn(1)))
                error("The input images should has the same class.");
            end
            if and(size(imout) == size(imn))==%F then
                error("The input images should has the same size.");
            end

            imout = imout + double(imn)*kn;
        end //end if ii
    end //end for ii

    //convert the output image to the same type as the input images
    //or to the user specified type
    if(totype=='undefined') then
        totype=imtype;
    end

    select totype,
    case 'uint8' then
        imout = round(imout);
        imout(imout>255) = 255;
        imout(imout<0) = 0;
        imout = uint8(imout);

    case 'int8' then
        imout = round(imout);
        imout(imout>127) = 127;
        imout(imout<-128) = -128;
        imout = int8(imout);

    case 'uint16' then
        imout = round(imout);
        imout(imout>(2^16-1)) = 2^16-1;
        imout(imout<0) = 0;
        imout = uint16(imout);

    case 'int16' then
        imout = round(imout);
        imout(imout>(2^15-1)) = 2^15-1;
        imout(imout<(-2^15)) = -2^15;
        imout = int16(imout);

    case 'int32' then
        imout = round(imout);
        imout(imout>(2^31-1)) = 2^31-1;
        imout(imout<(-2^31)) = -2^31;
        imout = int16(imout);

    case 'constant' then
        ;
    else
        error("Data type " + totype + " is not supported.");
    end

endfunction
