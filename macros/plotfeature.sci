//=============================================================================
// IPCV - Scilab Image Processing and Computer Vision toolbox
// Copyright (C) 2017  Tan Chin Luh
//=============================================================================
function plotfeature(fobj,ind);
    // Plot the features detected by feature detectors
    //
    // Syntax
    //     plotfeature(fobj [,ind]);
    //
    // Parameters
    //     fobj : Features object
    //          type : Type of features
    //          n : Numbers of detected features
    //          x : Coordinates of the detected features - X
    //          y : Coordinates of the detected features - Y
    //          size : Size of detected features
    //          angle : keypoint orientation
    //          response : The response by which the most strong keypoints have been selected.
    //          octave : pyramid octave in which the keypoint has been detected
    //          class_id : object id
    //      ind : Index to which feature to be plotted
    //
    // Description
    //    This function used to plot the features detected by feature detector
    //
    // Examples
    //    S = imcreatechecker(8,8,[1 0.5]);
    //    fobj = imdetect_ORB(S);
    //    imshow(S); plotfeature(fobj);
    //
    // See also
    //     imdetect_FAST
    //     imdetect_STAR
    //     imdetect_SIFT 
    //     imdetect_SURF
    //     imdetect_ORB
    //     imdetect_BRISK
    //     imdetect_MSER
    //     imdetect_GFTT
    //     imdetect_HARRIS
    //     imdetect_DENSE
    //     plotfeature
    //
    // Authors
    //    Tan Chin Luh
    //


    //

    rhs=argn(2);

    // Error Checking
    if rhs < 1; error("At least 1 argument expected, in 2D matrix"); end   
    if rhs < 2; ind= 1:$; end

    a_handle = gca();
    if isempty(a_handle.children )
        error("No figure with image detected");
        return
    end

    sz = size(a_handle.children.data);
    a_handle.auto_scale = 'off';

    xc = fobj.x(ind);
    yc = sz(1) - fobj.y(ind);


    a = 0:0.1:2*%pi;    


    plot(xc,yc,'x');

    if  fobj.type == 'SURF' then
        r = fobj.size(ind)./2;
        drawlater();
        for cnt = 1:size(r,2);
            x = r(cnt).*cos(a) + xc(cnt);
            y = r(cnt).*sin(a) + yc(cnt);
            plot(x,y,'g');
        end
        drawnow();
    end




endfunction










