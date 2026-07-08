////////////////////////////////////////////////////////////
// SIVP - Scilab Image and Video Processing toolbox
// Copyright (C) 2006  Shiqi Yu
//
// IPCV - Scilab Image Processing and Computer Vision toolbox
// Copyright (C) 2017  Tan Chin Luh
//
////////////////////////////////////////////////////////////

function [imout] = imresize(imin, varargin)
    //    Resizes image
    //    
    //    Syntax
    //      imout = imresize(imin, scale)
    //      imout = imresize(imin, scale, interp)
      //    imout = imresize(imin, [mrows ncols])
    //      imout = imresize(imin, [mrows ncols], interp)
    //    
    //    Parameters
    //      imin : An image which will be resized.
    //      scale :The size of resized image is [width, height] x scale .
    //      [mrows ncols] : The size of resized image.
    //      interp : Interpolation method. The value of interp must be one of the follows: 
    //          1. 'nearest' : nearest-neigbor interpolation (default value); 
    //          2. 'bilinear' : bilinear interpolation; 
    //          3. 'bicubic' : bicubic interpolation; 
    //          4. 'area' : resampling using pixel area relation.
    //        
    //    Description
    //      imresize resize the input image. When scale parameter is specified, the width and height of the image is resized in the same scale. There are four interpolation method can be used: nearest-neigbor, bilinear, bicubic and area methods. The default method is nearest-neigbor method.
    //    
    //    Examples
    //      im = imread(fullpath(getIPCVpath() + "/images/baboon.png"));
    //      ima = imresize(im, 1.5);
    //      imb = imresize(im, 1.5, 'bilinear');
    //      imc = imresize(im, [100,200], 'bicubic');
    //      imshow(ima);scf();imshow(imb);scf();imshow(imc);
    //     
    //    See also
    //      imcrop
    //    
    //    Authors
    //      Shiqi Yu
    //      Tan Chin Luh


    //if INT8, convert to UINT8 first
    if (typeof(imin(1))=='int8') then
        if length(varargin)==1 then
            imout = int_imresize(im2uint8(imin), varargin(1));
        elseif length(varargin)==2 then
            imout = int_imresize(im2uint8(imin), varargin(1),varargin(2));
        end

        imout = im2int8(imout);

        //if INT16, convert to UINT16 first
    elseif (typeof(imin(1))=='int16') then
        if length(varargin)==1 then
            imout = int_imresize(im2uint16(imin), varargin(1));
        elseif length(varargin)==2 then
            imout = int_imresize(im2uint16(imin), varargin(1),varargin(2));
        end

        imout = im2int16(imout);

        //    //if INT32, convert to double first
        //    elseif (typeof(imin(1))=='int32') then
        //      if length(varargin)==1 then
        //	imout = int_imresize(im2double(imin), varargin(1));
        //      elseif length(varargin)==2 then
        //	imout = int_imresize(im2double(imin), varargin(1),varargin(2));
        //      end
        //      
        //      imout = im2int32(imout);

        //UINT8, UINT16, INT32 and DOUBLE will be handled by C interface int_imresize
    else
        if length(varargin)==1 then
            imout = int_imresize(imin, varargin(1));
        elseif length(varargin)==2 then
            imout = int_imresize(imin, varargin(1),varargin(2));
        end
    end


endfunction
