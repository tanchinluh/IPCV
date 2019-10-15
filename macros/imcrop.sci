////////////////////////////////////////////////////////////
// SIVP - Scilab Image and Video Processing toolbox
// Copyright (C) 2006  Shiqi Yu
//
// IPCV - Scilab Image Processing and Computer Vision toolbox
// Copyright (C) 2017  Tan Chin Luh
//
////////////////////////////////////////////////////////////
function [subim] = imcrop(im, rect)
    //    Crop image
    //    
    //    Syntax
    //      subim = imcrop(im, rect)
    //    
    //    Parameters
    //      im : An image, which can be one channel or three channel image.
    //      rect : rect=[x, y, width, height] is a vector. (x, y) is the top-left corner of the rentangle.
    //      subim : subim is the sub-region of the image im .
    //    
    //    Description
    //      Crop image at regin rect to subim.
    //    
    //    Examples
    //      im = imread(fullpath(getIPCVpath() + "/images/baboon.png"));
    //      subim = imcrop(im, [20, 30, 200, 300]);
    //      imshow(subim);
    //     
    //    See also
    //      imresize
    //      imchoose
    //    
    //    Authors
    //      Shiqi Yu
    //      Tan Chin Luh

// TODO : If rect is not specified, a window which showing the image should be poped out, and let the user to select the region using mouse.
    //get the image width and height
    [imh,imw] = size(im);

    //check the rectangle
    if (rect(1)<1 | rect(2)<1 | rect(1)+rect(3)-1>imw | rect(2)+rect(4)-1>imh ) then
        error("The rectangle is out of the image range.");
        return;   
    end

    if (size(size(im),2) ==2) //gray image
        subim = im(rect(2):rect(2)+rect(4)-1, rect(1):rect(1)+rect(3)-1);
    elseif (size(size(im),2) ==3)//RGB image
        subim = im(rect(2):rect(2)+rect(4)-1, rect(1):rect(1)+rect(3)-1, :);
    else
        error("Is the imput an image?");
        return;
    end
endfunction
