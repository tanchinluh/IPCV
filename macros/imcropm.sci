//=============================================================================
// IPCV - Scilab Image Processing and Computer Vision toolbox
// Copyright (C) 2017  Tan Chin Luh
//=============================================================================
function [y,rec2] = imcropm(S)
    // Crop an image using mouse selection
    //
    // Syntax
    //     y = imcropm(S)
    //
    // Parameters
    //    S : Source Image
    //    y : Subimage
    //
    // Description
    //    This function allows user to select the region of interest interactively
    //    using mouse. 
    //
    // Examples
    //    S = imread(fullpath(getIPCVpath() + "/images/puffin.png"));
    //    J = imcropm(S);
    //    scf; imshow(J);
    //
    // See also
    //     imcrop
    //
    // Authors
    //    Tan Chin Luh
    //



    imshow(S);

    a = gca();

    [b,xc,yc]=xclick(); //get a point
    xrect(xc,yc,0,0) //draw a rectangle entity
    r=gce();// the handle of the rectangle
    r.foreground = 5;
    rep=[xc,yc,-1];first=%f;

    while rep(3)==-1 do // mouse just moving ...
        rep=xgetmouse();
        xc1=rep(1);yc1=rep(2);
        ox=min(xc,xc1);
        oy=max(yc,yc1);
        w=abs(xc-xc1);h=abs(yc-yc1);
        r.data=[ox,oy,w,h]; //change the retangle origin, width an height
        first=%f;
    end

    rnum = find(a.children.type =='Rectangle');
    rec = a.children(rnum).data;
    [sy sx] = size(S);
    y = imcrop(S,[rec(1),sy - rec(2), rec(3),rec(4)]);
    rec2 = [rec(1),sy - rec(2), rec(3),rec(4)];

endfunction

