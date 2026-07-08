//=============================================================================
// IPCV - Scilab Image Processing and Computer Vision toolbox
// Copyright (C) 2017  Tan Chin Luh
//=============================================================================
function pts = imselect(n, bnd)
    // Select points on an image.
    //
    // Syntax
    //    pts = imselect(n [, bnd])
    //
    // Parameters
    //    n : Number of maximum points to select, or it could be less by using right click.
    //    bnd : optional 1x4 vector [xmin, ymin, xmax, ymax]; 
    //          if present, mouse coordinates are displayed in status bar, when pointer is in boundaries
    //    pts : Selected points coordinates, axes coordinates returns.
    //
    // Description
    //    This function allows user to select the up to the maximum points specified in n, 
    //    or the last points could be selected by using right click. The returned coordinates 
    //    are in cartesian, which need to be manually converted to image coordinates if required.
    //
    // Examples
    //    S = imread(fullpath(getIPCVpath() + "/images/puffin.png"));
    //    imshow(S);
    //    pts = imselect(5);
    //
    // See also
    //    imcrop
    //    imroi
    //    imcropm
    //
    // Authors
    //    Tan Chin Luh
    //

    smsg = ''; // status bar message
    if argn(2)<2 then
        bnd = []; // if not specified, nothing is displayed in the status bar
    end

           /////////////////
        f = gcf();
        if f.children.zoom_box ~=[] then
            xx = f.children.zoom_box(1);
            yy = f.children.zoom_box(2);
        else
            xx=0;
            yy=0;
        end
        
//            pts(cnt,1) = round(xc1)+round(xx);
//            pts(cnt,2) = round(yc1)+round(yy);
////            pts(1) = pts(1) + round(xx);
////            pts(2) = pts(2) + round(yy);
//
//        else

    for cnt = 1:n

        rep=[0,0,-1];first=%f;

        while rep(3)==-1 do // mouse just moving ...
            rep=xgetmouse();
            xc1=rep(1);yc1=rep(2);
            if bnd <> [] then 
                if xc1<bnd(1) | yc1<bnd(2) | xc1>bnd(3) | yc1>bnd(4) then
                    smsg = '';
                else 
                    smsg = 'x='+string(round(xc1)+round(xx))+', y='+string(round(yc1)+round(yy));
                end
                //if execstr('xinfo(smsg)','errcatch')<>0 then
                //    return;
                //end
                gcf().info_message = smsg;
            end
            first=%f;
        end

 
            pts(cnt,1) = round(xc1);
            pts(cnt,2) = round(yc1);
    
        //disp([xc1,yc1]);//
        plot(xc1,yc1,'r*');
        xnumb(xc1,yc1,cnt,2)
        e = gce();
        e.fill_mode = 'on';
        e.font_foreground = -1;
        e.foreground = 0;
        e.background = -2;
        e.font_size = 3;

        if rep(3)==12 // mouse just moving ...
            break;
        end
    end



endfunction

