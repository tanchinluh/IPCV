////////////////////////////////////////////////////////////
// SIVP - Scilab Image and Video Processing toolbox
// Copyright (C) 2006 Shiqi Yu
//
// IPCV - Scilab Image Processing and Computer Vision toolbox
// Copyright (C) 2017  Tan Chin Luh
////////////////////////////////////////////////////////////
function [imr]=rectangle(im, position, rgb)
    //    Draw a rectangle on image
    //    
    //    Syntax
    //      imr = rectangle(im, rect, rgb)
    //    
    //    Parameters
    //      im : An image, which can be one channel or three channel image.
    //      rect : rect=[x, y, width, height] is a vector. (x, y) is the top-left corner of the rectangle.
    //      imr : imr is the the output image with the rectangle.
    //    
    //    Examples
    //      im = imread(fullpath(getIPCVpath() + "/images/baboon.png"));
    //      imr = rectangle(im, [20, 30, 50, 100], [12 155 0]);
    //      imshow(imr);
    //     
    //    See also 
    //      imrects
    //    
    //    Authors
    //      Jia Wu
    //      Tan Chin Luh

    //get the image width and height
    [imh,imw] = size(im);
    position=round(position);
    xx = position(1);
    yy = position(2)
    ww = position(3);
    hh = position(4);

    //check the rectangle position
    if (xx<1 | yy<1 | xx+ww-1>imw | yy+hh-1>imh) then
        error("The rectangle is out of the image range.");
        return;   
    end

    if (size(size(im),2) == 2)  //gray image
        im( [yy, (yy+hh-1)], xx:(xx+ww-1) )=rgb(1);
        im( [yy:(yy+hh-1)], [xx, (xx+ww-1)] )=rgb(1);  
    elseif (size(size(im),2) == 3)  //RGB image
        for i=1:3,
            im([yy,(yy+hh-1)], xx:(xx+ww-1), i)=rgb(i);
            im(yy:(yy+hh-1), [xx,(xx+ww-1)], i)=rgb(i);
        end       
    else
        error("Is the imput an image?");
        return;
    end

    imr=im;

endfunction
