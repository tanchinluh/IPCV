////////////////////////////////////////////////////////////
// SIVP - Scilab Image and Video Processing toolbox
// Copyright (C) 2006  Shiqi Yu
//
// IPCV - Scilab Image Processing and Computer Vision toolbox
// Copyright (C) 2017  Tan Chin Luh
//
////////////////////////////////////////////////////////////
function [im2] = im2bw(im, thresh)
    // Convert image to binary
    //
    // Syntax
    //   im2 = im2bw(im, thresh)
    //
    // Parameters
    //   im : An matrix/image, which can be ANY image supported by IPCV.
    //   thresh : Threshold value. You specify thresh in the range [0,1], regardless of the class of the input image.
    //   im2 : Boolean matrix.
    //
    // Description
    //   im2bw convert intensity or RGB images to binary images. The output is a boolean matrix, which has value of %T for all pixels in the input image with luminance grater than thresh and %F for all the other pixels. (You specify thresh in the range [0,1], regardless of the type of the input image.)
    //
    // Examples
    //   S = imread(fullpath(getIPCVpath() + "/images/balloons.png"));
    //   S2 = rgb2gray(S);
    //   Sbin = im2bw(S2,0.5);
    //   imshow(Sbin);
    //
    // See also
    //   im2uint8
    //   im2int8
    //   im2uint16
    //   im2int16
    //   im2int32
    //   im2double
    //   mat2gray 
    //  
    // Authors
    //   Shiqi Yu 
    //   Tan Chin Luh




    if (thresh < 0 | thresh > 1)
        error("thresh should be in the range [0,1]");
    end
    dims = size(im);
    if (size(dims,2)== 3) then
        if (dims(3)<>3) then
            error("The input matrix im should be MxN or M x N x 3 matrix.");
        end
        //convert the RGB image to gray image first
        im = rgb2gray(im);
    elseif (size(size(im),2)>3) then
        error("The input matrix im should be MxN or M x N x 3 matrix.");
    end

    imtype = typeof(im(1));

    select imtype
    case 'boolean' then
        im2 = im;
    case 'uint8' then
        im2 = im > uint8(round((2^8-1)*thresh));
    case 'int8' then
        im2 = im > int8(round((2^8-1)*thresh-128));
    case 'uint16' then
        im2 = im > uint16(round((2^16-1)*thresh)); 
    case 'int16' then
        im2 = im > int16(round((2^16-1)*thresh-2^15)); 
    case 'int32' then
        im2 = im > int32(round((2^32-1)*thresh-2^31)); 
    case 'constant' then
        im2 = im > thresh;
    else
        error("Data type " + imtype + " is not supported.");
    end
endfunction
