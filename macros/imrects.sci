//=============================================================================
// IPCV - Scilab Image Processing and Computer Vision toolbox
// Copyright (C) 2017  Tan Chin Luh
//=============================================================================

function imrects(BB,rgb)
    // Draw Bounding Boxes on An Image
    //
    // Syntax
    //     imrects(BB,rgb)
    //
    // Parameters
    //    BB : Bounding Boxes, 4 by M, in which each column representing 1 box in [x,y,w,h].
    //    rgb : RGB values with value from 0 to 255 in [R,G,B] format
    //
    // Description
    //    This function draw rectangles on the image using given bounding boxes paremeters.
    //
    // Examples
    //    A = imread(fullpath(getIPCVpath() + "/images/coins.png"));
    //    Agray = rgb2gray(A);
    //    Abin = im2bw(Agray,imgraythresh(Agray));
    //    se = imcreatese('ellipse',15,15);
    //    A_close = imclose(~Abin,se);
    //    [A_labeled,n] = imlabel(A_close);  
    //    [Area, BB] = imblobprop(A_labeled);
    //    imshow(A);
    //    imrects(BB,[255 0 0]);
    // 
    // See also
    //     imlabel
    //     imblobprop
    //
    // Authors
    //    Tan Chin Luh
    //



    f = gcf();
    
    h = findobj('image_type','rgb');
    
    if h ==[]  then
        h = findobj('image_type','index');
    end
    
    if h ==[]  then
        h = findobj('image_type','gray');
    end
    //pause
    //sz = size(f.children.children.data);
    sz = size(h.data);

    id = color(rgb(1),rgb(2),rgb(3));

    xx = BB(1,:);
    yy = sz(1)-BB(2,:)+1;
    ww = BB(3,:);
    hh = BB(4,:);
    // pause
    xrects([xx;yy;ww;hh],-id*ones(xx));
    

endfunction


