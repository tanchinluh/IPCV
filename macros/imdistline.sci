//=============================================================================
// IPCV - Scilab Image Processing and Computer Vision toolbox
// Copyright (C) 2017  Tan Chin Luh
//=============================================================================
function dist = imdistline()
    // Measure distance between 2 selected points in pixels.
    //
    // Syntax
    //     dist = imdistline()
    //
    // Parameters
    //     dist : Computed distance
    //
    // Description
    //    This function allows the user to select 2 points on the current figure and measure the distance between 2 points.
    //
    // Examples
    //    S = imread(fullpath(getIPCVpath() + "/images/balloons.png"));
    //    imshow(S);
    //    dist = imdistline();
    //
    // See also
    //    impixel
    //    improfile
    //
    // Authors
    //    Tan Chin Luh
    //



    [b,xc,yc]=xclick(); //get a point
    plot([xc xc],[yc yc]);
    r=gce();//
    rep=[xc,yc,-1];first=%f;

    while rep(3)==-1 do // mouse just moving ...
        rep=xgetmouse();
        xc1=rep(1);yc1=rep(2);
        ox = xc1;
        oy = yc1;
        r.children.data(2,:) = [ox,oy];
        first=%f;
    end


    dist = sqrt((xc - ox).^2 + (yc - oy).^2);

    x_mid = min(xc,ox) + abs(xc - ox)/2;
    y_mid = min(yc,oy) + abs(yc - oy)/2;
    xstring(x_mid,y_mid,string(round(dist*100)/100),0,2);
    e = gce();
    e.fill_mode = 'on';
    //disp([x_mid,y_mid]);
endfunction



